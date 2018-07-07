// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.base;
import w4d.element.background,
       w4d.layout.base,
       w4d.layout.fill,
       w4d.style.widget,
       w4d.task.window,
       w4d.exception;
import g4d.math.vector;

class Widget : WindowContent
{
    protected WidgetStyle _style;
    @property style () { return _style; }

    protected Layout _layout;

    protected BackgroundElement _background;

    override void handleMouseEnter ( bool entered )
    {
    }
    override bool handleMouseMove ( vec2 pos )
    {
        return false;
    }
    override bool handleMouseButton ( MouseButton btn, bool status )
    {
        return false;
    }
    override bool handleMouseScroll ( vec2 amount )
    {
        return false;
    }

    override bool handleKey ( Key key, KeyState status )
    {
        return false;
    }
    override bool handleTextInput ( dchar c )
    {
        return false;
    }

    this ()
    {
        _style = new WidgetStyle;

        setLayout!FillLayout();
    }

    void setLayout (L) ()
    {
        _layout = new L(style);
    }

    override void resize ( vec2i newSize )
    {
        resize( vec2(newSize) );
    }
    void resize ( vec2 newSize )
    {
        enforce( _layout, "Layout is null." );
        _layout.fix( newSize );

        if ( !_background ) {
            _background = new BackgroundElement;
        }
        _background.resize( _style.box );
    }

    protected void drawBg ( Window win )
    {
        if ( !_style.box.bgColor.a ) return;

        auto shader = win.shaders.fill3;
        shader.use();
        shader.setVectors( vec3(_style.translate,0) );
        shader.color = _style.box.bgColor;

        _background.draw( shader );
    }
    override void draw ( Window win )
    {
        drawBg( win );
    }
}
