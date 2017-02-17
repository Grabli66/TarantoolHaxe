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

class TagInternal {
    /**
     *  Child tags
     */
    private var _tags : Array<Tag>;

    /**
     *  Tag attributes
     */
    private var _attributes : Map<String, String>;

    /**
     *  Tag name
     */
    public var Name (default, null) : String;

    /**
     *  Css classes
     */
    public var Css (get, null) : String;
    private function get_Css () : String {
        if (_attributes.exists ("class")) return _attributes.get ("class");
        return "";
    }

    /**
     *  Constructor
     */
    public function new (name : String, ?options : TagOptions, ?tags : Array<Tag>) {
        _attributes = new Map<String, String> ();

        Name = name;
        _tags = tags != null ? tags : new Array<Tag> ();            
                
        if (options != null) {
            if (options.css != null) _attributes["class"] = options.css;
        }        
    }

    /**
     *  Add tags to this
     *  @param tags - some tags
     */
    public function AddTags (tags : Array<Tag>) : Void {
        _tags = _tags.concat (tags);
    }    

    /**
     *  Render tag name and all attributes
     *  @return StringBuf
     */
    public function RenderName () : StringBuf {
        var s = new StringBuf ();
        s.add ('<$Name');
        for (i in _attributes.keys()) {
             s.add (" ");
             s.add ('${i}="${_attributes[i]}"');
        }
        s.add ('>');
        return s;
    }

    /**
     *  Append render tags to buffer
     *  @param s - 
     */
    public function RenderChilds (s : StringBuf) : Void {
        for (t in _tags) {
            s.add (t.ToString ());
        }
    }

    /**
     *  Append close tag
     *  @param s - 
     */
    public function CloseTag (s : StringBuf) : Void {
        s.add ('</$Name>');
    }

    /**
     *  Translate all tags to string
     *  @return String
     */
    public function ToString () : String {
        var s = RenderName ();
        RenderChilds (s);
        CloseTag (s);        
        return s.toString ();
    }
}