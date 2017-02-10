class TestBox {
    static function main () {
        Box.Cfg ({
            listen : 3301
        });

        Box.Once ("create", function () {
            Space.Create ("test", {
                id : 1
            });
        });

        var space = Space.Get ("test");        
        space.Select ();
    }
}