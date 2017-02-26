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
     *  Raw channel for write/read data
     */
    public var Channel (default, null) : IRWChannel;

    /**
        Response headers
    **/
    public var Headers (default, null) : Map<String, String>;

    /**
     *  Response status
     */
    public var Status : HttpStatus = HttpStatus.Ok;    

    /**
        Constructor
    **/
    public function new (channel : IRWChannel) {
        Channel = channel;
        Reset ();
    }

    /**
     *  Reset response
     */
    public function Reset () {
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
        var descr = Status.GetDescription ();
        Channel.WriteString ('HTTP/1.1 ${Status} ${descr}\n');
        Channel.WriteString ('Content-Length: ${_buffer.length}');
        Channel.WriteString ("\n\n");
        Channel.Write (_buffer.getBytes ());
    }
}