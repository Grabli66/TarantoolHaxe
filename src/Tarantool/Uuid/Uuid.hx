/**
    A “UUID” is a Universally unique identifier. 
    If an application requires that a value be unique only within a single computer or on a single database, then a simple counter is better than a UUID, because getting a UUID is time-consuming (it requires a syscall). 
    For clusters of computers, or widely distributed applications, UUIDs are better.
**/
abstract Uuid (Dynamic) {
    /**
        Uuid module
    **/
    private static var _module : Dynamic;

    /**
        On class init
    **/
    private static function __init__ () : Void {
        _module = untyped require ('uuid');        
    }

    /**
        Create uuid from string
    **/
    public inline static function FromString (uuid : String) : Uuid {
        return untyped _module["fromstr"] (uuid);
    }

    /**
        Create uuid from binary string
    **/
    public inline static function FromBinary(uuid : String) : Uuid {
        return untyped _module["frombin"] (uuid);
    }
    
    /**
        UUID converted from cdata input value.
        36-byte hexadecimal string
    **/
    public inline static function String () : String {
        return untyped _module["str"] ();
    }

    /**
        UUID converted from cdata input value
        16-byte binary string
    **/
    public inline static function Binary () : String {
        return untyped _module["bin"] ();
    }

    /**
        Convert Uuid to 36-byte hexadecimal string
    **/
    public inline function ToString () : String {
        return untyped this.str ();
    }

    /**
        Convert Uuid to 16-byte binary string
    **/
    public inline function ToBinary () : String {
        return untyped this.bin ();
    }
}