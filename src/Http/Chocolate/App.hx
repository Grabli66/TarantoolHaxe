/**
    Chocolate app
**/
@:final
class App {
    /**
        Http server
    **/
    private static var _httpServer : HttpServer;

    /**
        On init class
    **/
    private static function __init__ () : Void {
        _httpServer = new HttpServer ();
    }

    /**
        Add route to get method
    **/
    public static function Get (path : String, call : Void -> Void) : Void {

    }

    /**
        Add route to post method
    **/
    public static function Post (path : String, call : Void -> Void) : Void {

    }

    /**
        Start listen
    **/
    public static function Listen (options : AppOptions) {
        
    }
}