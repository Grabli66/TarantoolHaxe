import haxe.io.Bytes;

/**
    Binding for tarantool socket
**/
class TcpSocket implements IRWChannel {
    /**
        Socket module
    **/
    private var _module : Dynamic;

    /**
        Tarantool socket
    **/
    private var _sock : Dynamic;

    /**
        Constructor
    **/
    public function new (?luaSock : Dynamic) {
        if (luaSock != null) {
            _sock = luaSock;
        } else {
            _module = untyped require ('socket');
        }
    }

    /**
        Connect to server
    **/
    public function Connect (host : String, port : Int) : Void {
        _sock = untyped _module["tcp_connect"] (host, port);
    }

    /**
        Read bytes
    **/
    public function Read (size : Int) : Bytes {
        var res = untyped _sock.read (size);
        if (res == "") return null;
        if (res == null) throw "Socket error";
        return Bytes.ofString (res);
    }

    /**
        Write bytes
    **/
    public function Write (data: Bytes) : Int {
        var s = data.toString ();
        return untyped _sock.write (s);
    }

    /**
        Write string
    **/
    public function WriteString (data: String) : Int {        
        return untyped _sock.write (data);
    }    

    /**
        Read string with delimeter
    **/
    public function ReadUntil (delimeter : String) : String {        
        var res = untyped _sock.read (delimeter);
        if (res == "") return null;
        if (res == null) throw "Socket error";
        return res;
    }

    /**
        Wait until something is readable, or until a timeout value expires
    **/
    public function Readable (?timeout : Int) : Bool {
        if (timeout != null) {
            return untyped _sock.readable ();
        } else {
            return untyped _sock.readable (timeout);
        }
    }

    /**
        Wait until something is writable, or until a timeout value expires.
    **/
    public function Writeable (?timeout : Int) : Bool {
        if (timeout != null) {
            return untyped _sock.writeable ();
        } else {
            return untyped _sock.writeable (timeout);
        }
    }

    /**
        Close socket
    **/
    public function Close () : Void {
        untyped _sock.shutdown ();
    }

    /**
        Bind to socket
    **/
    public function Bind (host : String, port : Int, handler : Peer -> IRWChannel -> Void) : Void {
        _sock = untyped _module["tcp_server"] (host, port, function (s, e) {                      
            handler (new Peer (), new TcpSocket (s));
        });
    }
}