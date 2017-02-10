import lua.Table;

/**
    Box module
**/
class Box {    
    /**
        Cfg function
    **/
    public static function Cfg (options : ConfigOptions) : Void {
        var listen : Dynamic = options.listen;
        var pidFile : Dynamic = options.pid_file;
        var tbl = Table.create ({
            listen : listen,
            pid_file : pidFile
        });
        untyped box["cfg"] (tbl);
    }

    /**
        Run once function
    **/
    public static function Once (id : String, func : Void -> Void) : Void {
        untyped box["once"] (id, func);
    }
}