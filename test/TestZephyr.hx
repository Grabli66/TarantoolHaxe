import Chocolate.App;
import HtmlBuilder.*;
import haxe.io.Bytes;

class TestZephyr {
    static function main () {
        App.Get ("/", function (req : Request) {
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

        App.WebSocket.OnConnect (function (p : Peer, c : IWriteChannel) {
            trace ("CONNECTED");
        });
        App.WebSocket.OnData (function (p : Peer, data : Bytes, c : IWriteChannel) {
            trace ("DATA");
        });

        App.Listen ({
            Port : 8081,
            StaticDir : "./out/media",
            HandleWebSocket : true           
        });
    }
}