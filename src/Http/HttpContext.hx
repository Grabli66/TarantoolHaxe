/**
    Context for request and response
**/
@:final
class HttpContext {
    /**
        Request
    **/
    public var Request (default, null) : HttpRequest;

    /**
        Response
    **/
    public var Response (default, null) : HttpResponse;

    /**
        Constructor
    **/
    public function new (request : HttpRequest, response : HttpResponse) {
        Request = request;
        Response = response;
    }
}