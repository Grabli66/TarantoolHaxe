import haxe.io.Bytes;
import haxe.crypto.Base64;
import haxe.crypto.Sha1;
import haxe.crypto.BaseCode;
using StringTools;

/**
    State of work
**/
enum WorkState {
    /**
        Handshake with client
    **/
    HANDSHAKE;   

    /**
        Get frame type
    **/
    FRAME_TYPE;
    /**
        Get length
    **/
    LENGTH;
    /**
        Get data
    **/
    DATA;
}

/**
    Handle websocket data
**/
class InternalHandler implements IWriteChannel {
    /**
        Message mask size
    **/
    private static inline var MASK_SIZE = 4;

    /**
        One byte max body size
    **/
    private static inline var ONE_BYTE_MAX_BODY_SIZE = 125;

    /**
        Two byte body size
    **/
    private static inline var TWO_BYTE_BODY_SIZE = 126;

    /**
        Eight byte body size
    **/
    private static inline var EIGHT_BYTE_BODY_SIZE = 127;

    /**
        Sec-WebSocket-Key header name
    **/
    private static inline var SecWebSocketKey = "Sec-WebSocket-Key";

    /**
        Web socket GUID
    **/
    private static inline var WS_GUID = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";

    /**
        Client peer
    **/
    private var _peer : Peer;

    /**
        Channel for data IO
    **/
    private var _channel : IRWChannel;

    /**
        State of handler
    **/
    private var _state : WorkState;

    /**
        Handshake headers
    **/
    private var _headers : Map<String, String>;

    /**
        Frame type
    **/
    private var _frameType : Int;

    /**
        Packet length
    **/
    private var _packLen : Int;

    /**
        On connect callback
    **/
    public var OnConnect : OnWSConnect;

    /**
        On normal web socket close
    **/
    public var OnClose : OnWSClose;

    /**
        On data callback
    **/
    public var OnData : OnWSData;

    /**
        On error callback
    **/
    public var OnError : OnWSError;

    /**
        Decode hex string to Bytes
    **/
    private function decode (str : String) {
        var base = Bytes.ofString("0123456789abcdef");
        return new BaseCode(base).decodeBytes(Bytes.ofString(str.toLowerCase()));
    }

    /**
        Send error through OnError
    **/
    private function PushError (e : Dynamic) {        
        if (OnError != null) {
            OnError (_peer, e);
        }
    }

    /**
        Process handshake from client
    **/
    private function ProcessHandshake () : Void {        
        var key = _headers[SecWebSocketKey] + WS_GUID;
        var sha = Sha1.encode (key);
        var shaKey = Base64.encode (decode (sha));
        var stringBuffer = new StringBuf ();
        stringBuffer.add ("HTTP/1.1 101 Switching Protocols\r\n");
        stringBuffer.add ("Upgrade: websocket\r\n");
        stringBuffer.add ("Connection: Upgrade\r\n");
        stringBuffer.add ('Sec-WebSocket-Accept: ${shaKey}\r\n');
        stringBuffer.add ("\r\n");
        _channel.WriteString (stringBuffer.toString ());
        _state = WorkState.FRAME_TYPE;
        OnConnect (_peer, this);        
    }

    /**
        Process frame type, opcode, mask, len part
    **/
    private function ProcessFrame () : Void {
        var binaryData = _channel.Read (2);
        var frame = binaryData.get (0);

        // Close frame
        if ((frame & 0x08) > 0) {
            _frameType = FrameType.CLOSE;
        } else if ((frame & 0x02) > 0) {
            _frameType = FrameType.BINARY;
        } else {                        
            throw "Only binary frame allowed";
        }

        var len = binaryData.get (1);
        _packLen = 0;
        if ((len & 0x80) < 1) throw "Only masked message allowed";
        _packLen += len ^ 0x80;

        if (_packLen > ONE_BYTE_MAX_BODY_SIZE) {
            _state = WorkState.LENGTH;
        } else {
            _state = WorkState.DATA;
        }
    }

    /**
        Process length
    **/
    private function ProcessLength () : Void {
        if (_packLen == TWO_BYTE_BODY_SIZE) {
            var binaryData = _channel.Read (2);
            _packLen += binaryData.get (0);            
        } else if (_packLen == EIGHT_BYTE_BODY_SIZE) {
            //var binaryData = BinaryData.FromBytes (_socket.input.read (8));            
        } else {
            throw "Wrong length type";
        }

        _state = WorkState.DATA;
    }

    /**
        Process data
    **/
    private function ProcessData () : Void {
        var binaryData = _channel.Read (_packLen + MASK_SIZE);

        switch (_frameType) {
            case FrameType.CLOSE: {
                //if (_clientHandler.OnClose != null) _clientHandler.OnClose ();       
                //OnClose (_socket);
            }
            case FrameType.BINARY: {
                var mask = binaryData.sub (0, MASK_SIZE);
                var data = binaryData.sub (MASK_SIZE, binaryData.length - MASK_SIZE);                
                var res = Bytes.alloc (data.length);

                for (i in 0...data.length) {
                    var j = i % 4;
                    var b = data.get (i);
                    var d = b ^ mask.get (j);
                    res.set (i, d);
                }

                // On data
                OnData (_peer, res, this);
            }
        }      
        
        _state = WorkState.FRAME_TYPE;
    }

    /**
        Disconnect connection
    **/
    private function Disconnect () {
        try {
            _channel.Close ();
        } catch (e : Dynamic) {
            trace (e);
        }
    }

    /**
     *  Constructor
     *  @param context - http context
     */
    public function new (context : HttpContext) {
        _channel = context.Response.Channel;
        _headers = context.Request.Headers;
        _state = WorkState.HANDSHAKE;
    }

    /**
        Start to process data from client
    **/
    public function Start () : Void {
        try {
            while (true) {
                switch (_state) {
                    case WorkState.HANDSHAKE: ProcessHandshake ();
                    case WorkState.FRAME_TYPE: ProcessFrame ();
                    case WorkState.LENGTH: ProcessLength ();
                    case WorkState.DATA: ProcessData ();
                }
            }
        }
        catch (e : Dynamic) {
            PushError (e);
            //Disconnect ();
        }
    }    

    /**
        Write bunary data
    **/
    public function Write (data: Bytes) : Int {
         var frame = Bytes.alloc (2 + data.length);
        frame.set (0, 0x80 + FrameType.BINARY);  // FIN, BINARY
        frame.set (1, data.length);
        frame.blit (2, data, 0, data.length);
        return _channel.Write (frame);
    }

    /**
        Write string
    **/
    public function WriteString (data: String) : Int {
        var frame = Bytes.alloc (2 + data.length);
        frame.set (0, 0x80 + FrameType.TEXT);  // FIN, BINARY
        frame.set (1, data.length);
        var dat = Bytes.ofString (data);        
        frame.blit (2, dat, 0, dat.length);
        return _channel.Write (frame);
    }

    /**
        Close socket
    **/
    public function Close () : Void {
        _channel.Close ();
    }
}