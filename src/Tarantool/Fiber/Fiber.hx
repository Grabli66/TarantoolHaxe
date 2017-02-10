/**
    A fiber is a set of instructions which are executed with cooperative multitasking.
    Fibers managed by the fiber module are associated with a user-supplied function called the fiber function. 
    A fiber has three possible states: running, suspended or dead.
**/
abstract Fiber (Dynamic) {
    /**
        Fiber module
    **/
    public static var Module : Dynamic;

    /**
        On class init
    **/
    private static function __init__ () : Void {
        Module = untyped require ('fiber');
    }

    /**
        The status of fiber. One of: “dead”, “suspended”, or “running”.
    **/
    public var Status (get, never) : FiberStatus;
    private function get_Status () : FiberStatus {        
        var status = untyped this.status ();
        trace (status);
        return FiberStatus.createByName (status);        
    }

    /**
        Yield control to the transaction processor thread and sleep for the specified number of seconds. 
        Only the current fiber can be made to sleep.
    **/
    public static function Sleep (seconds : Float) : Void {
        untyped Module["sleep"] (seconds);
    }

    public static function Create (call : FiberChannel -> Void, channel : FiberChannel) : Fiber {
        var fibr = untyped Module["create"] (function () {
            Fiber.Sleep (0);
            call (channel);
        });

        return fibr;
    }

    /**
        Constructor
    **/
    private function new (call : FiberChannel -> Void, ?channel : FiberChannel) {
    /*    this = untyped Module["create"] (function () {
            Fiber.Sleep (0);
            call (channel);            
        });                        */
    }    
}