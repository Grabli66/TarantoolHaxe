/**
    Options for space create
**/
typedef SpaceCreateOptions = {
    /**
        Space contents are temporary: changes are not stored in the write-ahead log and there is no replication. 
        Note re storage engine: vinyl does not support temporary spaces
    **/
    ?temporary : Bool,
    
    /**
        Unique identifier: users can refer to spaces with the id instead of the name
    **/
    ?id : Int,

    /**
        Fixed count of fields: for example if field_count=5, 
        it is illegal to insert a tuple with fewer than or more than 5 fields
    **/
    ?field_count : Int,

    /**
        Create space only if a space with the same name does not exist already, 
        otherwise do nothing but do not cause an error
    **/
    ?if_not_exists : Bool,

    /**
        Storage engine
    **/
    ?engine : EngineType,

    /**
        Name of the user who is considered to be the space’s owner for authorization purposes
    **/
    ?user : String,

    /**
        Field names and types
    **/
    //?format : 
}