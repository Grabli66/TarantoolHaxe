import lua.Table;

class Convert {
    /**
        Check type is possible to convert
    **/
    public static inline function IsSimpleType (data : Dynamic) : Bool {
        if (Std.is (data, Int) || Std.is (data, Float) || Std.is (data, String)) {
            return true;
        }
        return false;
    }

    /**
        Convert object to: 
        Simple type -> Simple type
        Array<Dynamic> -> Table as array
        Map<Dynamic, Dynamic> -> Table as map
        Object -> Table as map
    **/
    public static function ConvertDynamic (object : Dynamic) : Dynamic {                
        if (IsSimpleType (object)) {
            return object;
        } else if (Std.is (object, Array)) {                
            return ArrayToTable (cast (object, Array<Dynamic>));
        } else if (Std.is (object, Map)) {
            return MapToTable (cast (object, Map<Dynamic, Dynamic>));
        } else if (Reflect.isObject (object)) {            
            var tbl : Table<Dynamic, Dynamic> = Table.create ();
            var fields = Reflect.fields(object);
            for (i in 1...fields.length + 1) {
                var f = fields[i-1];
                var v = Reflect.getProperty (object, f);
                var d = ConvertDynamic (v);
                untyped tbl[f] = d;
            }
            return tbl;
        }
        return null;
    }

    /**
        Convert Array<Dynamic> to lua.Table
    **/
    public static function ArrayToTable (data : Array<Dynamic>) {        
        var tbl : Table<Dynamic, Dynamic> = Table.create ();        
        for (i in 1...data.length + 1) {            
            var d = data[i - 1];            
            tbl[i] = ConvertDynamic (d);
        }
        return tbl;
    }

    /**
        Convert map to table
    **/
    public static function MapToTable (data : Map<Dynamic, Dynamic>) {
        var tbl : Table<Dynamic, Dynamic> = Table.create ();        
        for (k in data.keys ()) {
            var v = data[k];          
            if (IsSimpleType (k)) {
                tbl[k] = ConvertDynamic (v);
            }
        }
        return tbl;
    }

    /**
        Convert dynamic to lua.Table
    **/
    public static function DynamicToTable (data : Dynamic) {
        var res = ConvertDynamic (data);
        if (Std.is (res, Table)) {
            return res;
        } else {
            var tbl : Table<Dynamic, Dynamic> = Table.create ();
            tbl[1] = res;
            return tbl;
        }

        return null;
    }
}