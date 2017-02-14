/**
    Embedded http server for tarantool
**/
class HttpServer {
    /**
        Server socket
    **/
    private var _socket : TcpSocket;

    /**
        Request handlers
    **/
    private var _handlers : Array<IHandler>;

    /**
        Add default handlers like http, static files
    **/
    private function AddDefaultHandlers () : Void {
        AddHandler (new HttpHandler ());
    }

    /**
        Process client requests
    **/
    private function ProcessClient (peer : Peer, channel : IRWChannel) {        
        try {
            var response = new HttpResponse (channel);
            while (true) {
                var request = new HttpRequest (channel);
                var context = new HttpContext (request, response);

                for (h in _handlers) {
                    if (h.CanProcess (request)) h.Process (context);
                }
            }
        } catch (e : Dynamic) {
            trace (e);
            channel.Close ();
        }
    }    

    /**
        Constructor
    **/
    public function new () {
        _socket = new TcpSocket ();
        _handlers = new Array<IHandler> ();
        AddDefaultHandlers ();
    }

    /**
        Add http request handler
    **/
    public function AddHandler (handler : IHandler) : Void {        
        _handlers.push (handler);
    }

    /**
        Bind server to host and port
    **/
    public function Bind (host : String, port : Int) : Void {
        if (_handlers.length < 1) throw "No handlers";
        _socket.Bind (host, port, function (p : Peer, c : IRWChannel) {
            ProcessClient (p , c);
        });
    }

    /**
        Set callback on client request
    **/
    public function OnRequest (call : HttpContext -> Void) : Void {        
        var h : HttpHandler = cast (_handlers[0], HttpHandler);
        h.OnRequest (call);
    }
}