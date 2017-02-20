/**
    Embedded http server for tarantool
**/
class HttpServer {
    /**
     *  Server socket
     */
    private var _socket : TcpSocket;

    /**
     *  Request handlers
     */
    private var _handlers : Array<IHandler>;    

    /**
     *  Process client requests
     *  @param peer - client peer
     *  @param channel - read write channel
     */
    private function ProcessClient (peer : Peer, channel : IRWChannel) {        
        try {            
            while (true) {                
                var request = new HttpRequest (channel);
                var response = new HttpResponse (channel);
                var context = new HttpContext (request, response);                

                for (h in _handlers) {
                    if (h.Process (context)) break;                    
                }
            }
        } catch (e : Dynamic) {
            trace (e);
            channel.Close ();
        }
    }

    /**
     *  Constructor
     */
    public function new () {
        _socket = new TcpSocket ();
        _handlers = new Array<IHandler> ();
    }

    /**
     *  Add http request handler
     *  @param handler - request handler
     */
    public function AddHandler (handler : IHandler) : Void {        
        _handlers.push (handler);
    }

    /**
     *  Bind server to host and port
     *  @param host - 
     *  @param port - 
     */
    public function Bind (host : String, port : Int) : Void {
        if (_handlers.length < 1) throw "No handlers";
        _socket.Bind (host, port, function (p : Peer, c : IRWChannel) {
            ProcessClient (p , c);
        });
    }
}