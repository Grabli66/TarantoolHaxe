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
        var walDir : Dynamic = options.wal_dir;
        var workDir : Dynamic = options.work_dir;
        var slabAllocArena : Dynamic = options.slab_alloc_arena;        
        var tbl = Table.create ({
            listen : listen,
            pid_file : pidFile,
            wal_dir : walDir,
            work_dir : workDir,
            slab_alloc_arena : slabAllocArena
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