class TestBox {
    static function main () {
        Box.Cfg ({
            listen : 3301,
            slab_alloc_arena : 0.1,
            work_dir : "./snaps",
            wal_dir : ".",
        });

        Box.Once ("first", function () {
            var space = Space.Create ("test", {
                id : 1
            });

            space.CreateIndex ("primary", {
                unique : true, 
                type : IndexType.tree,
                parts : [
                    {
                        field_no : 1, type : IndexFieldType.string
                    },
                    /*{  
                        field_no : 2, type : IndexFieldType.string
                    },*/
                ]
            });
            space.Insert ([Uuid.String (),34,4,5]);
            space.Insert ([Uuid.String (),35,4,5]);
            space.Insert ([Uuid.String (),44,4,5]);
            space.Insert ([Uuid.String (),12,5,8]);
        });

        var chan = new FiberChannel ();

        var fiber = Fiber.Create (function (ch : FiberChannel) {            
            var space = Space.Get ("test");
            while (true) {
                var d = ch.Get ();
                trace (d.good);
                Fiber.Sleep (1);
            }
        }, chan);

        var fiber2 = Fiber.Create (function (ch : FiberChannel) {
            while (true) {
                ch.Put ({
                    good : 42
                });
                Fiber.Sleep (5);
            }
        }, chan);        
    }
}