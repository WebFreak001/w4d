// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.popup.base;
import w4d.widget.base,
       w4d.widget.panel,
       w4d.widget.root,
       w4d.exception;
import g4d.math.vector;

class PopupWidget : RootWidget
{
    // WindowContext of target of popup.
    protected WindowContext _objectContext;

    override void handlePopup ( bool opened, WindowContext w )
    {
        if ( opened ) {
            _objectContext = w;
        } else {
            _objectContext.requestRedraw();
            _objectContext = null;
        }
    }

    this ()
    {
        super();
    }

    void move ( vec2 pos, vec2 size )
    {
        .Widget.layout( pos, size );
    }
    void close ()
    {
        enforce( _objectContext,
                "The popup is not opened yet." );
        _objectContext.setPopup( null );
    }

    override vec2 layout ( vec2 leftTop, vec2 size )
    {
        return vec2(0,0);
    }
}
