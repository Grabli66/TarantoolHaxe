import haxe.io.Bytes;
using StringTools;

/**
    Request from client
**/
class HttpRequest {
    /**
        Version
    **/
    public var Version : HttpVersion;

    /**
        Method
    **/
    public var Method : HttpMethod;

    /**
        Request resource
    **/
    public var Resource : String;

    /**
        Request headers
    **/
    public var Headers (default, null) : Map<String, String>;

    /**
        Request body
    **/
    public var Body : Bytes;

    /**
        Read all headers
    **/
    private function ReadHeaders (channel : IRWChannel) : Void {
        var line = channel.ReadUntil ("\n").trim ();
        var parts = line.split (" ");        
        if (parts.length != 3) throw "Bad request";
        Method = HttpMethod.createByName (parts[0].toLowerCase ());
        Resource = parts[1];
        trace (Method);
        trace (Resource);

        Headers = new Map<String, String> ();

        line = channel.ReadUntil ("\n").trim ();
        while (line.length > 0) {
            var head = line.split (": ");
            if (head.length < 2) throw "Bad request";
            Headers[head[0]] = head[1];
            line = channel.ReadUntil ("\n").trim ();
        }
    }

    /**
        Read body
    **/
    private function ReadBody (channel : IRWChannel) : Void {
        Body = null;
        if (Method == HttpMethod.get) return;

        if (Headers.exists ("Content-Length")) {
            var len = Std.parseInt (Headers ["Content-Length"]);
            Body = channel.Read (len);
        } else if (Headers["Transfer-Encoding"] == "chunked") {
            
        }
    }

    /**
        Constructor
    **/
    public function new (channel : IRWChannel) {        
        try {
            ReadHeaders (channel);
            ReadBody (channel);
        } catch (e : Dynamic) {
            throw "Bad request";
        }
    }
}