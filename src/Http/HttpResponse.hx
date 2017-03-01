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
     *  Write headers to channel
     */
    private function WriteHeaders () {
        Headers[HttpHeaders.ContentLength] = Std.string (_buffer.length);
        Headers[HttpHeaders.Server] = "tyrant";

        for (k in Headers.keys()) {
            var v = Headers.get (k);
            Channel.WriteString ('${k}: ${v}\n');
        }

        Channel.WriteString ("\n");
    }

    /**
        Constructor
    **/
    public function new (channel : IRWChannel) {
        Channel = channel;
        Headers = new Map<String, String> ();
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
     *  Write http response
     */
    public function Close () : Void {
        var descr = Status.GetDescription ();
        Channel.WriteString ('HTTP/1.1 ${Status} ${descr}\n');
        WriteHeaders ();        
        Channel.Write (_buffer.getBytes ());        
    }
}