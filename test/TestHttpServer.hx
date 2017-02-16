class TestHttpServer {
    static function main () {
        App.Get ("/", function (req : Request) {
            return "GOOD";
        });

        App.Get ("/home", function (req : Request) {
            return "home";
        });

        App.Listen ({
            port : 8081
        });
    }
}