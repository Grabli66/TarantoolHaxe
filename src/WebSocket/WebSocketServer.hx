import haxe.io.Bytes;

/**
    WebSocket server over tarantool socket
**/
class WebSocketServer {
    /**
        Socket
    **/
    private var _sock : TcpSocket;

    /**
        On connect callback
    **/
    private var _onConnect : Peer -> IWriteChannel -> Void;

    /**
        On connect callback
    **/
    private var _onDisconnect : Peer -> Void;

    /**
        On data callback
    **/
    private var _onData : Peer -> IWriteChannel -> Bytes -> Void;

    /**
        On error callback
    **/
    private var _onError : Peer -> Dynamic -> Void;

    /**
        Handle accept
    **/
    private function Handler (p : Peer, s : IRWChannel) : Void {        
        var ih = new InternalHandler (p, s);
        ih.OnConnect = _onConnect;
        ih.OnData = _onData;
        ih.OnError = _onError;
        ih.Start ();
    }

    /**
        Set on connect callback
    **/
    public function OnConnect (call : Peer -> IWriteChannel -> Void) : Void {
        _onConnect = call;
    }

    /**
        Set on data callback
    **/
    public function OnData (call : Peer -> IWriteChannel -> Bytes -> Void) : Void {
        _onData = call;
    }

    /**
        Set on disconnect callback
    **/
    public function OnDisconnect (call : Peer -> Void) : Void {
        _onDisconnect = call;
    }

    /**
        Set on error callback
    **/
    public function OnError (call : Peer -> Dynamic -> Void) : Void {
        _onError = call;
    }

    /**
        Constructor
    **/
    public function new () {
        _sock = new TcpSocket ();
    }

    /**
        Bind
    **/
    public function Bind (host : String, port : Int) : Void {
        if (_onData == null) throw "No data handler";
        _sock.Bind (host, port, Handler);        
    }
}