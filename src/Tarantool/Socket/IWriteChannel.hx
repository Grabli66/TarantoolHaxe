import haxe.io.Bytes;

/**
    Interface for output Channel
**/
interface IWriteChannel extends IChannel {
    /**
        Write data
    **/
    public function Write (data: Bytes) : Int;

    /**
        Write string
    **/
    public function WriteString (data: String) : Int;    
}