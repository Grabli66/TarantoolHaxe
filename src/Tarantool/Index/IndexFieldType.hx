/**
    Type of index field
**/
enum IndexFieldType {
    /**
        Unsigned integers between 0 and 18446744073709551615, about 18 quintillion.         
        Legal in memtx TREE or HASH indexes, and in vinyl TREE indexes
    **/
    unsigned;

    /**
        Any set of octets, up to the maximum length. May also be called ‘str’. 
        Legal in memtx TREE or HASH or BITSET indexes, and in vinyl TREE indexes
    **/
    string;

    /**
        Integers between -9223372036854775808 and 18446744073709551615. May also be called ‘int’. 
        Legal in memtx TREE or HASH indexes, and in vinyl TREE indexes.
    **/
    integer;

    /**
        Integers between -9223372036854775808 and 18446744073709551615, single-precision floating point numbers, or double-precision floating point numbers. 
        Legal in memtx TREE or HASH indexes, and in vinyl TREE indexes.
    **/    
    number;

    /**
        Array of integers between -9223372036854775808 and 9223372036854775807. Legal in memtx RTREE indexes
    **/
    array;

    /**
        Booleans (true or false), or integers between -9223372036854775808 and 18446744073709551615, or single-precision floating point numbers, or double-precison floating-point numbers, or strings. 
        When there is a mix of types, the key order is: booleans, then numbers, then strings. 
        Legal in memtx TREE or HASH indexes, and in vinyl TREE indexes
    **/
    scalar;
}