/**
    Embedded http server for tarantool
**/
class HttpServer {
    /**
     *  Server socket
     */
    private var _socket : TcpSocket;

    /**
     *  First handler
     */
    private var _firstHandler : Handler;

    /**
     *  Last handler
     */
    private var _lastHandler : Handler;

    /**
     *  Process client requests
     *  @param peer - client peer
     *  @param channel - read write channel
     */
    private function ProcessClient (peer : Peer, channel : IRWChannel) {        
        try {
            trace ("Accept client");
            // TODO: Keep-alive
            while (true) {
                var request = new HttpRequest (channel);
                var response = new HttpResponse (channel);
                var context = new HttpContext (request, response);
                _firstHandler.Process (context);
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
    }

    /**
     *  Add http request handler
     *  @param handler - request handler
     */
    public function AddHandler (handler : Handler) : Void {        
        if (_firstHandler == null) {
            _firstHandler = handler;
            _lastHandler = handler;
        }

        _lastHandler.Next = handler;
        _lastHandler = handler;
    }

    /**
     *  Bind server to host and port
     *  @param host - Example: * - for all possible ip, localhost, 192.168.0.196, mysite.ru
     *  @param port - Example: 80, 8080
     */
    public function Bind (host : String, port : Int) : Void {
        if (_firstHandler == null) throw "No handlers";

        _socket.Bind (host, port, function (p : Peer, c : IRWChannel) {
            ProcessClient (p , c);
        });
    }
}