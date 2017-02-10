class TestBox {
    static function main () {
        Box.Cfg ({
            listen : 3301,
            slab_alloc_arena : 0.1,
            work_dir : "./snaps",
            wal_dir : "."
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
                        field_no : 1, type : IndexFieldType.unsigned
                    },
                    {  
                        field_no : 2, type : IndexFieldType.string
                    },
                ]
            });
            space.AutoIncrement (["dd",34,4,5]);
            space.AutoIncrement (["dd",35,4,5]);
            space.AutoIncrement (["ff",44,4,5]);
            space.AutoIncrement (["ss",12,5,8]);
        });        

        var space = Space.Get ("test");        
        var dat = space.Select ([ 1, "dd" ]);
        for (d in dat) {
            trace (d);
        }        
    }
}