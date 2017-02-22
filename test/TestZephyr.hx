import Chocolate.App;
import HtmlBuilder.*;

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

        /*App.WebSocket.OnConnect ();
        App.WebSocket.OnData ();
        App.WebSocket.OnClose ();
        App.WebSocket.OnError ();*/

        App.Listen ({
            Port : 8081,
            StaticDir : "./out/media"            
        });
    }
}