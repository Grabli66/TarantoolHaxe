import haxe.io.Bytes;

/**
    Interface for Input/Output Channel
**/
interface IChannel {
    /**
        Close channel
    **/
    public function Close () : Void;
}