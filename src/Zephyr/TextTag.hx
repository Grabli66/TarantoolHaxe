class TextTag extends TagInternal {
    /**
     *  Tag inner text
     */
    public var Text (default, null) : String;

    /**
     *  Constructor
     *  @param name - 
     *  @param text - 
     *  @param tags - 
     */
    public function new (name : String, ?options : TextTagOptions, ?tags : Array<Tag>) {
        super (name, options, tags);
        Text = "";
        if (options != null) {
            Text = options.text != null ? options.text : "";
        }
    }

    /**
     *  Translate all tags to string
     *  @return String
     */
    public override function ToString () : String {
        var s = RenderName ();        
        if (Text != "") s.add (Text);        
        RenderChilds (s);
        CloseTag (s);        
        return s.toString ();
    }
}