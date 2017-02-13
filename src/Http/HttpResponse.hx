import haxe.io.Bytes;

/**
    Response to client
**/
class HttpResponse implements IWriteChannel {
    /**
        Channel
    **/
    private var _channel : IRWChannel;

    /**
        Constructor
    **/
    public function new (channel : IRWChannel) {
        _channel = channel;
    }

    /**
        Write data
    **/
    public function Write (data: Bytes) : Int {
        return _channel.Write (data);
    }

    /**
        Write string
    **/
    public function WriteString (data: String) : Int {
        return _channel.WriteString (data);
    }

    /**
        Close channel
    **/
    public function Close () : Void {

    }
}