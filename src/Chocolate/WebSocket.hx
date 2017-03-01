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

/**
 *  Web socket handler with callbacks
 */
class InternalWebSocketHandle implements IWSHandler {
    /**
     *  Connect handler
     */
    public var ConnectHandle : OnWSConnect;

    /**
     *  Data handler
     */
    public var DataHandle : OnWSData;
    
    /**
     *  Close handler
     */
    public var CloseHandle : OnWSClose;

    /**
     *  Error handler
     */
    public var ErrorHandle : OnWSError;

    /**
     *  Constructor
     */
    public function new () {
    }

    /**
     *  On connect callback
     *  @param p - 
     *  @param c - 
     */
    public function OnConnect (p : Peer, c : IWriteChannel) : Void {
        if (ConnectHandle != null) ConnectHandle (p, c);
    }

    /**
     *  On data callback
     *  @param p - 
     *  @param b - 
     *  @param c - 
     */
    public function OnData (p : Peer, b : Bytes, c : IWriteChannel) : Void {
        if (DataHandle != null) DataHandle (p, b, c);
    }

    /**
     *  On connection close callback
     *  @param p - 
     */
    public function OnClose (p : Peer) : Void {
        if (CloseHandle != null) CloseHandle (p);
    }

    /**
     *  On handler callback
     *  @param p - 
     *  @param e - 
     */
    public function OnError (p : Peer, e : Dynamic) : Void {
        if (ErrorHandle != null) ErrorHandle (p, e);
    }
}

/**
 *  Web socket
 */
class WebSocket {
    /**
     *  Callbacks
     */
    public var Handle (default, null) : InternalWebSocketHandle;

    /**
     *  Constructor
     */
    public function new () {
       Handle = new InternalWebSocketHandle ();
    }

    public function OnConnect (call : OnWSConnect) : Void {
        // Bug?
        Handle.ConnectHandle = function (p, i) {
            call (p, i);
        }
    }

    public function OnData (call : OnWSData) : Void {
        // Bug?
        Handle.DataHandle = function (p, b, c) {
            call (p, b, c);
        }
    }

    public function OnClose (call : OnWSClose) : Void {
        // Bug?
        Handle.CloseHandle = function (p) {
            call (p);
        }
    }

    public function OnError (call : OnWSError) : Void {
        // Bug?
        Handle.ErrorHandle = function (p, e) {
            call (p, e);
        }
    }
}