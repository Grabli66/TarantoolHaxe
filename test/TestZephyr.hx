import Chocolate.App;
import Chocolate.WebSocket;
import HtmlBuilder.*;
import haxe.io.Bytes;

class TestZephyr {
    static function main () {        
        App.Get ("/", function (req : Request) {
            trace (req.Headers);
            return html ([
                    head (),
                    body ([
                        div({ text : "GOOD", css : "shit" }, [
                            p ({ text : "Hello world!" })
                        ]),
                        div ()
                    ])
                ]);
        });

        App.OnError (HttpStatus.NotFound, function (req : Request) {
            return html ([
                    head (),
                    body ([
                        h1 ({ text : "Not found!" })
                    ])
                ]);
        });

/*        WebSocket.OnConnect (function (p : Peer, c : IWriteChannel) {
            trace ("CONNECTED");
            //c.WriteString ("COOL");
        });

        WebSocket.OnData (function (p : Peer, data : Bytes, c : IWriteChannel) {
            trace (data.toString ());
        });

        WebSocket.OnError (function (p : Peer, e : Dynamic) {
            trace (e);
        });*/

        App.Listen ({
            Port : 8081,
            StaticDir : "./out/media",
            WebSocket : true           
        });
    }
}