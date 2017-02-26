/*
 * Copyright (c) 2017 Grabli66
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/**
 *  Chocolate app
 */
@:final
class Chocolate {    
    /**
     *  Http server
     */
    private var _httpServer : HttpServer;    

    /**
     *  Routes 
     */
    private var _routes : Map<String, Route>;

    /**
     *  On error callback
     */
    private var _errorHandlers : Map<HttpStatus, RequestCall>;

    /**
     *  App instance
     */
    public static var App (default, null) : Chocolate;

    /**
     *  Web socket instance
     */
    public var WebSocket (default, null) : WebSocket;

    /**
     *  On init class
     */
    private static function __init__ () : Void {
        App = new Chocolate ();
    }

    /**
     *  Constructor
     */
    private function new () {
        _httpServer = new HttpServer ();
        _routes = new Map<String, Route> ();
        _errorHandlers = new Map<HttpStatus, RequestCall> ();
        this.WebSocket = new WebSocket ();
    }

    /**
     *  On http error
     *  @param c - http context
     *  @param error - http status
     */
    private function OnHttpError (c : HttpContext, error : HttpStatus) : Void {
        if (_errorHandlers.exists (error)) {
            var call = _errorHandlers.get (error);
            var req = new Request (c.Request);
            var resp = call (req);
            WriteResponse (c, resp);
        }
    }
    
    /**
     *  Write response to client
     *  @param c - Http context for write
     *  @param response - response from server
     */
    private function WriteResponse (c : HttpContext, response : Response) {
        c.Response.WriteString (response.ToString ());
    }

    /**
     *  Process http request
     */
    private function OnHttpRequest (c : HttpContext) : Void {
        try {
            for (kv in _routes) {
                if (kv.IsMatch (c.Request.Resource)) {
                    var req = new Request (c.Request);
                    var resp = kv.Process (req);
                    WriteResponse (c, resp);
                    break;
                }
            }
        } catch (e : Dynamic) {
            trace (e);
        }
    }

    /**
     *  Add route for get method
     *  @param pattern - path to handle. Example: /mypage/id/1
     *  @param call - callback to handle request
     */
    public function Get (pattern : String, call : RequestCall) : Void {
        _routes[pattern] = new Route (pattern, call);
    }

    /**
     *  Add route to post method
     *  @param pattern - path to handle. Example: /mypage/id/1
     *  @param call - callback to handle request
     */
    public function Post (pattern : String, call : RequestCall) : Void {
        _routes[pattern] = new Route (pattern, call);
    }

    /**
     *  For process http error
     *  @param err - error type
     *  @param call - callback to process error
     */
    public function OnError (err : HttpStatus, call : RequestCall) : Void {
        _errorHandlers[err] = call;
    }

    /**
     *  Start listen
     *  @param options - various options like port to listen
     */
    public function Listen (options : AppOptions) {
        var httpHandler = new HttpHandler (OnHttpRequest);
        var errorHandler = new ErrorHandler (OnHttpError);
        _httpServer.AddHandler (errorHandler);

        if (options.HandleWebSocket != null) {
            var wshandler = new WebSocketHandler (WebSocket.Handler);
            _httpServer.AddHandler (wshandler);
        }

        if (options.StaticDir != null) {
            var staticHandler = new StaticHandler ();
            staticHandler.AddPath (options.StaticDir);
            _httpServer.AddHandler (staticHandler);
        }
        
        _httpServer.AddHandler (httpHandler);
        _httpServer.Bind ("*", options.Port);
    }
}