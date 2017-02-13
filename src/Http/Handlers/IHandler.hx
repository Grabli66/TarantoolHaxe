/**
    Handler for request
**/
interface IHandler {
    /**
        Can handler process that request
    **/
    public function CanProcess (request : HttpRequest) : Bool;

    /**
        Process request
    **/
    public function Process (context : HttpContext) : Void; 
}