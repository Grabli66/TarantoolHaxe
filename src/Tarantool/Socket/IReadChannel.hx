import haxe.io.Bytes;

/**
    Interface for Input Channel
**/
interface IReadChannel extends IChannel {
    /**
        Read data
    **/
    public function Read (size : Int) : Bytes;

    /**
        Read string with delimeter
    **/
    public function ReadUntil (delimeter : String) : String;    
}