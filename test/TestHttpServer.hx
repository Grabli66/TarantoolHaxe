class TestHttpServer {
    static function main () {
        App.Get ("/", function (req : Request) {
            return "GOOD";
        });

        App.Listen ({
            port : 3301
        });
    }
}