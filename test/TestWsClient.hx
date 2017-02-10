import haxe.io.Bytes;
import js.html.WebSocket;
import js.html.BinaryType;

class TestWsClient {
    static function main () {
        var ws = new WebSocket ("ws://localhost:3301");
        ws.binaryType = BinaryType.ARRAYBUFFER;
        ws.onopen = function (s) {
            trace ("OPEN");
            var buff = Bytes.ofString ("123");
            //trace (buff.toHex ());
            ws.send (buff.getData ());
        }

        ws.onclose = function (s) {
            trace ("CLOSE");
        }

        ws.onerror = function (e) {
            trace (e);
        }

        ws.onmessage = function (m) {            
            trace (m.data);
        }
    }
}