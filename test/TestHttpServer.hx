class TestHttpServer {
    static function main () {
        App.Get ("/", function () {
            
        });
        App.Listen ({
            port : 3301
        });
    }
}