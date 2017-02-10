import haxe.io.Bytes;

class TestWsServer {
    static function main() {       
       var wsock = new WebSocketServer ();
       wsock.OnConnect (function (p : Peer, c : IWriteChannel) {
           trace ("CONNECT");
       });

       wsock.OnData (function (p : Peer, c : IWriteChannel, data : Bytes) {
           trace (data.toString ());
           c.WriteString ("Привет");
           c.WriteString ("GOOD");
       });

       wsock.OnDisconnect (function (p : Peer) {
           trace ("DISSCON");
       });

       wsock.OnError (function (p : Peer, e : Dynamic) {
           trace (e);
       });

       wsock.Bind ("localhost", 3301);
    }
}

