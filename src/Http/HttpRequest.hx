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

import haxe.io.Bytes;
import tink.Url;
using StringTools;

/**
    Request from client
**/
class HttpRequest {
    /**
        Version
    **/
    public var Version : HttpVersion;

    /**
        Method
    **/
    public var Method : HttpMethod;

    /**
     *  Request resource       
     */
    public var Resource : Url;  // TODO: make own URL class with lua patterns

    /**
        Request headers
    **/
    public var Headers (default, null) : Map<String, String>;

    /**
        Request body
    **/
    public var Body : Bytes;

    /**
        Read all headers
    **/
    private function ReadHeaders (channel : IRWChannel) : Void {
        var text = channel.ReadUntil ("\n");
        if (text == null) throw "Connection closed";    // TODO: create internal error class to catch them
        var line = text.trim ();
        var parts = line.split (" ");
        if (parts.length != 3) throw HttpStatus.BadRequest;
        Method = HttpMethod.createByName (parts[0].toLowerCase ());
        Resource = parts[1];
        trace ('$Method $Resource');

        Headers = new Map<String, String> ();

        line = channel.ReadUntil ("\n").trim ();
        while (line.length > 0) {
            var head = line.split (": ");
            if (head.length < 2) throw HttpStatus.BadRequest;
            Headers[head[0]] = head[1];
            line = channel.ReadUntil ("\n").trim ();
        }
    }

    /**
        Read body
    **/
    private function ReadBody (channel : IRWChannel) : Void {
        Body = null;
        if (Method == HttpMethod.get) return;

        if (Headers.exists ("Content-Length")) {
            var len = Std.parseInt (Headers ["Content-Length"]);
            Body = channel.Read (len);
        } else if (Headers["Transfer-Encoding"] == "chunked") {
            
        }
    }

    /**
        Constructor
    **/
    public function new (channel : IRWChannel) {                
        ReadHeaders (channel);
        ReadBody (channel);
    }
}