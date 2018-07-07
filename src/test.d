// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;

class TestWidget : Widget
{
    this ()
    {
        super();

        import g4d.math.vector;
        import w4d.style.rect,
               w4d.style.scalar;
        _style.box.margins     = Rect( Scalar(5,ScalarUnit.Pixel) );
        _style.box.borderWidth = Rect( Scalar(1,ScalarUnit.Pixel) );
        _style.box.bgColor     = vec4(1,1,1,1);
        _style.box.borderColor = vec4(1,0,0,1);
    }
}

int main ( string[] args )
{
    auto app = new App( args );

    auto widget = new TestWidget;

    auto win = new Window( widget, vec2i(640,480), "TEST", WindowHint.Resizable );
    app.addTask( win );

    win.show();
    return app.exec();
}
