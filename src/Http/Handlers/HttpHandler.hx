/**
    Process http request
**/
class HttpHandler implements IHandler {
    /**
        On request callback
    **/
    private var _onRequest : HttpContext -> Void;

    /**
        Constructor
    **/
    public function new (call : HttpContext -> Void) {
        _onRequest = call;
    }    

    /**
        Can handler process that request
    **/
    public function CanProcess (request : HttpRequest) : Bool {
        return true;
    }

    /**
        Process request
    **/
    public function Process (context : HttpContext) : Void {
        if (_onRequest != null) {
            _onRequest (context);
            context.Response.Close ();
        }                
    }
}