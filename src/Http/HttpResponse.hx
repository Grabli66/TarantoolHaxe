import haxe.io.Bytes;
import haxe.io.BytesBuffer;

/**
    Response to client
**/
class HttpResponse implements IWriteChannel {
    /**
        Buffer for response
    **/
    private var _buffer : BytesBuffer;

    /**
        Channel
    **/
    private var _channel : IRWChannel;

    /**
        Constructor
    **/
    public function new (channel : IRWChannel) {
        _channel = channel;
        _buffer = new BytesBuffer ();
    }

    /**
        Write data
    **/
    public function Write (data: Bytes) : Int {
        _buffer.addBytes (data, 0, data.length);
        return data.length;
    }

    /**
        Write string
    **/
    public function WriteString (data: String) : Int {
        _buffer.addString (data);
        return data.length;
    }

    /**
        Close channel
    **/
    public function Close () : Void {
        _channel.WriteString ("HTTP/1.1 200 OK\n");
        _channel.WriteString ('Content-Length: ${_buffer.length}');
        _channel.WriteString ("\n\n");
        _channel.Write (_buffer.getBytes ());
    }
}