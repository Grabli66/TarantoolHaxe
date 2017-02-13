/**
    Process http request
**/
class HttpHandler implements IHandler {
    /**
        Constructor
    **/
    public function new () {        
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
        context.Response.WriteString ("HTTP/1.1 200 OK\n");
        context.Response.WriteString ("Content-Length: 4");
        context.Response.WriteString ("\n\n");
        context.Response.WriteString ("GOOD\n");
    }
}