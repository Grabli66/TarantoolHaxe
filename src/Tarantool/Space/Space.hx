import lua.Table;

/**
    Space structure
**/
class Space {
    /**
        Space name
    **/
    public var Name (default, null) : String;

    /**
        Space id
    **/
    public var Id (get, null) : Int;    
    private function get_Id () : Int 
    {
        return untyped box.space[Name].id;
    }

    /**
        Field count
    **/
    public var FieldCount (get, null) : Int;    
    private function get_FieldCount () : Int 
    {
        return untyped box.space[Name].field_count;
    }

    /**
        Create new schema
    **/
    public static function Create (name : String, ?options : SpaceCreateOptions) : Space {        
        var table : Dynamic = null;
        if (options != null) {
            table = lua.Table.create ();
            if (options.id != null) untyped table["id"] = options.id;
        }
        
        untyped box.schema.space["create"] (name, table);
        return new Space (name);
    }

    /**
        Check space Exists
    **/
    public static function Exists (name : String) : Bool {        
        var res = untyped (box.space[name]);
        return res != null;
    }

    /**
        Get space, if not exists return null
    **/
    public static function Get (name : String) : Space {
        var res = untyped (box.space[name]);
        return res == null ? null : new Space (name);
    }

    /**
        Constructor
    **/
    public function new (name : String) {
        Name = name;        
    }    

    /**
        Drop space
    **/
    public function Drop () : Void {
        untyped box.space[Name].drop ();
    }

    /**
        Create new index
    **/
    public function CreateIndex (name : String, ?options : IndexCreateOptions) : Index {
        var tbl = Table.create ();
        if (options != null) {
            if (options.unique != null) untyped tbl["unique"] = options.unique;
            if (options.type != null) untyped tbl["type"] = options.type.getName ();

            if (options.parts != null) {
                var parts = Table.create ();
                var i = 0;
                for (e in options.parts) {
                    var fn = e.field_no;
                    var name = e.type.getName ();                    
                    var pos = i * 2 + 1;                    
                    untyped parts[pos] = fn;
                    untyped parts[pos + 1] = name;
                    i += 1;
                }
                untyped tbl["parts"] = parts;
            }
        }

        trace (tbl);
        var res = untyped box.space[Name].create_index (name, tbl);
        return new Index (this, res.id);
    }
    
    /**
        Get index by id
    **/
    public function GetIndexById (id : Int) : Index {
        var res = untyped box.space[Name]["index"][id];
        if (res == null) return null;
        return new Index (this, id);
    }

    /**
        Get index by name
    **/
    public function GetIndexByName (name : String) : Index {
        var res = untyped box.space[Name]["index"][name];
        return new Index (this, res.id);
    }

    /**
        Insert data
    **/
    public function Insert (data : Dynamic) : Void {
        var tuple = Convert.DynamicToTable (data);
        untyped box.space[Name].insert (tuple);
    }

    /**
        Insert with auto-increment primary key
    **/
    public function AutoIncrement (data : Dynamic) : Void {
        var tuple = Convert.DynamicToTable (data);
        untyped box.space[Name].auto_increment (tuple);
    }

    /**
        Return number of record in space
    **/
    public function Len () : Int {
        return untyped box.space[Name].len ();
    }

    /**
        Deletes all records
    **/
    public function Truncate () : Void {
        return untyped box.space[Name].truncate ();
    }

    /**
        Update data
    **/
    public function Update (keys : Dynamic, query : Array<Array<Dynamic>>) : Void {
        var ks = Convert.ConvertDynamic (keys);
        var qu = Convert.ConvertDynamic (query);
        untyped box.space[Name].update (ks, qu);       
    }
    
    /**
        Select data by keys
    **/
    public function Select (?keys : Dynamic) : Array<Dynamic> {
        var table : AnyTable;

        if (keys != null) {
            var keys = Convert.ConvertDynamic (keys);
            table = untyped box.space[Name].select (keys);            
        } else {
            table = untyped box.space[Name].select ();            
        }
        
        return Convert.FromTable (table);
    }

    /**
        Delete a tuple identified by a primary key.
        Return the deleted tuple
    **/
    public function Delete (keys : Dynamic) : Array<Dynamic> {
        var keys = Convert.ConvertDynamic (keys);
        var table = untyped box.space[Name].select (keys);
        return Convert.FromTable (table);
    }
}