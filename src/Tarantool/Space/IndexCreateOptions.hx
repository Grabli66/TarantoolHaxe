/**
    Options for index create
**/
typedef IndexCreateOptions = {
    /**
        Type of index
    **/
    ?type : IndexType,

    /**
        Unique identifier
    **/
    ?id : Int,

    /**
        Index is unique
    **/
    ?unique : Bool,

    /**
        No error if duplicate name
    **/
    ?if_not_exists : Bool,

    /**
        Fields
    **/
    ?parts : Dynamic,

    /**
        Affects RTREE only
    **/
    ?dimension : Int,

    /**
        Affects RTREE only
    **/
    ?distance : DistanceType
}