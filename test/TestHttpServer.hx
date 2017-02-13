class TestHttpServer {
    static function main () {
        var httpServer = new HttpServer ();
        httpServer.AddHandler (new HttpHandler ());
        httpServer.Bind ("*", 8082);
    }
}