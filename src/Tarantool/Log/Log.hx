abstract Log (Dynamic) {
    /**
        Uuid module
    **/
    private static var _module : Dynamic;

    /**
        On class init
    **/
    private static function __init__ () : Void {
        _module = untyped require ('log');        
    }

    /**
        Log error
    **/
    public static function Error (message : String) : Void {
        untyped _module["error"] (message);
    }


    /**
        Log warning
    **/
    public static function Warn (message : String) : Void {
        untyped _module["warn"] (message);
    }

    /**
        Log info
    **/
    public static function Info (message : String) : Void {
        untyped _module["info"] (message);
    }

    /**
        Log debug
    **/
    public static function Debug (message : String) : Void {
        untyped _module["debug"] (message);
    }
}