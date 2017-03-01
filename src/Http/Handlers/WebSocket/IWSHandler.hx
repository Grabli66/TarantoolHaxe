import haxe.io.Bytes;

interface IWSHandler {
    public function OnConnect (p : Peer, c : IWriteChannel) : Void;
    public function OnData (p : Peer, b : Bytes, c : IWriteChannel) : Void;
    public function OnClose (p : Peer) : Void;
    public function OnError (p : Peer, e : Dynamic) : Void;
}