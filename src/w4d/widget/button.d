// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.button;
import w4d.parser.theme,
       w4d.task.window,
       w4d.widget.text,
       w4d.event;
import g4d.math.vector;

alias ButtonPressHandler = EventHandler!( void );

class ButtonWidget : TextWidget
{
    ButtonPressHandler onButtonPress;

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) {
            return true;
        }
        if ( !style.isPointInside(pos) ) {
            return false;
        }
        if ( btn == MouseButton.Left && !status ) {
            handleButtonPress();
            return true;
        }
        return false;
    }

    void handleButtonPress ()
    {
        onButtonPress.call();
    }

    this ()
    {
        super();
        textOriginRate = vec2(0.5,0.5);
        textPosRate    = vec2(0.5,0.5);

        parseThemeFromFile!"theme/pressable.yaml"( style );
    }

    override @property bool trackable () { return true; }
    override @property bool focusable () { return true; }
}
