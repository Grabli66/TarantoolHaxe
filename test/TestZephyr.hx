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

        App.Listen ({
            port : 8081
        });
    }
}