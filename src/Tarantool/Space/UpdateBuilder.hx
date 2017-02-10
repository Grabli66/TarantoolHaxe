/**
    Build update query
**/
class UpdateBuilder {    
    /**
        Queries
    **/
    private var _query : Array<UpdateItem>;

    /**
        Start query
    **/
    public static function Begin () : UpdateBuilder {
        return new UpdateBuilder ();
    }

    /**
        Constructor
    **/
    public function new () {
        _query = new Array<UpdateItem> ();
    }

    /**
        Begin query
    **/
    public function AddEqual (pos : Int, value : Dynamic) : UpdateBuilder {
        _query.push ({
            Operator : OperatorType.Equal,
            Position : pos,
            Value : value
        });
        return this;
    }

    /**
        Begin query
    **/
    public function End () : Array<UpdateItem> {
        return _query;
    }
}