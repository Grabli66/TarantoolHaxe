/**
    Space index
**/
class Index {
    /**
        Parent space
    **/
    public var Parent (default, null) : Space;

    /**
        Index id
    **/
    public var Id (default, null) : Int;

    /**
        Constructor
    **/
    public function new (parent : Space, id : Int) {
        Parent = parent;
        Id = id;
    }
}