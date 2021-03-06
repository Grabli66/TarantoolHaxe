/*
 * Copyright (c) 2017 Grabli66
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/**
 *  Handle errors
 */
class ErrorHandler extends Handler {
    /**
     *  Callback to process error
     */
    private var _onError : HttpContext -> HttpStatus -> Void;

    /**
     *  Process error
     */
    private function ProcessError (c : HttpContext, err : HttpStatus) {
        c.Response.Reset ();
        c.Response.Status = err;

        if (_onError != null) {
            try {                
                _onError (c, err);
            } catch (e : Dynamic) {
                c.Response.Reset ();
                c.Response.Status = HttpStatus.Internal;
            }
        }            

        c.Response.Close ();
    }

    /**
     *  Constructor
     */
    public function new (call : HttpContext -> HttpStatus -> Void) {
        _onError = call;
    }    

    /**
     *  Process request
     *  @param context - Http context
     */
    public override function Process (context : HttpContext) : Void {
        try {
            CallNext (context);
        } catch (e : HttpStatus) {
            ProcessError (context, e);
        } catch (e : Dynamic) {
            ProcessError (context, HttpStatus.Internal);
        }
    }
}