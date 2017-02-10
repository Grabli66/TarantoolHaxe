/**
    Data for working/storing in Tarantool database
**/
abstract TaranData (Dynamic) {
    /**
        Constructor
    **/
    public function new (e : Dynamic) {
        this = e;
    }

    /**
        Convert from int
    **/
    @:from public static inline function fromInt(e : Int) : TaranData {
        return new TaranData(e);
    }

    /**
        Convert from string
    **/
    @:from public static inline function fromString(e : String) : TaranData {
        return new TaranData(e);
    }   

    /**
        Convert from array of dynamic
    **/
    @:from public static inline function fromArray(e : Array<Dynamic>) : TaranData {        
        return new TaranData (Convert.ConvertDynamic (e));
    }

    /**
        Convert from map of dynamic
    **/
    @:from public static inline function fromMap(e : Map<Dynamic, Dynamic>) : TaranData {            
        return new TaranData (Convert.ConvertDynamic (e));
    }
}