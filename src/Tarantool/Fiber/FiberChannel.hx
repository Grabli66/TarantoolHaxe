/**
    Channel for fiber IPC
**/
abstract FiberChannel (Dynamic) {
    /**
        Constructor
    **/
    public function new () {
        this = untyped Fiber.Module["channel"] ();
    }

    /**
        Put message.
        Timeout in seconds
    **/
    public function Put (data : Dynamic, ?timeout : Int) : Void {
        untyped this.put (data);
    }

    /**
        Get message.
        Timeout in seconds
    **/
    public function Get (?timeout : Int) : Dynamic {
        return untyped this.get ();
    }
}