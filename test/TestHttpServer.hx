class TestHttpServer {
    static function main () {
        var httpServer = new HttpServer ();
        httpServer.OnRequest (function (c : HttpContext) {
            c.Response.WriteString ("<h1>Привет ебучий мир!!!</h1>");
            c.Response.WriteString ("<p>Говножопосрань</p>");
        });
        httpServer.Bind ("*", 8082);
    }
}