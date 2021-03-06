// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.scroll;
import w4d.layout.lineup,
       w4d.layout.split,
       w4d.style.color,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.panel,
       w4d.widget.scrollbar,
       w4d.util.vector;
import g4d.math.matrix,
       g4d.math.vector,
       g4d.shader.base;
import std.algorithm;

class ScrollPanelWidget(bool Horizon) : PanelWidget
{
    protected class CustomScrollBarWidget : ScrollBarWidget!Horizon
    {
        this ()
        {
            super();
        }
        override void handleScroll ( float v )
        {
            super.handleScroll( v );
            _contents.setScroll( v*_contents.size.length!Horizon );
        }
    }
    protected class CustomPanelWidget : PanelWidget
    {
        protected float _scroll;
        vec2 size;

        override bool handleMouseScroll ( vec2 amount, vec2 pos )
        {
            if ( super.handleMouseScroll( amount, pos ) ) return true;
            return _scrollbar.handleMouseScroll( amount, pos );
        }

        this ()
        {
            super();
            _scroll = 0f;
            size   = vec2(0,0);

            setLayout!( LineupLayout!Horizon );
            style.box.size.width  = Scalar.Auto;
            style.box.size.height = Scalar.Auto;
        }

        void setScroll ( float len )
        {
            auto amount = vec2(0,0);
            amount.lengthRef!Horizon = -(len-_scroll);
            shiftChildren( amount );

            _scroll = len;
        }

        protected void updatePageSize ()
        {
            auto clientSize = style.box.clientSize;
            if ( children.length ) {
                auto last = children[$-1];
                size = last.style.translate +
                    last.style.box.collisionSize;
                size -= style.clientLeftTop;
            } else {
                size = clientSize;
            }
            static if ( Horizon ) {
                _scrollbar.setBarLength( clientSize.x/size.x );
            } else {
                _scrollbar.setBarLength( clientSize.y/size.y );
            }
        }
        override vec2 layout ( vec2 pos, vec2 size )
        {
            scope(success) {
                _scroll = 0;
                updatePageSize();
            }
            return super.layout( pos, size );
        }

        protected override void drawChildren ( Window w )
        {
            children.
                filter!( x => style.isWidgetInside(x.style) ).
                each!( x => x.draw( w, colorset ) );
        }
        override void draw ( Window w, ColorSet parent )
        {
            w.clip.pushRect( style.clientLeftTop, style.box.clientSize );
            super.draw( w, parent );
            w.clip.popRect();
        }
    }

    protected CustomPanelWidget     _contents;
    protected CustomScrollBarWidget _scrollbar;

    @property PanelWidget contents () { return _contents; }

    // To override.
    protected CustomPanelWidget createCustomPanel ()
    {
        return new CustomPanelWidget;
    }

    this ()
    {
        super();
        setLayout!( SplitLayout!(!Horizon) );

        _contents  = createCustomPanel();
        _scrollbar = new CustomScrollBarWidget;

        // Order of widgets is different between vertical and horizontal.
        static if ( Horizon ) {
            super.addChild( _contents  );
            super.addChild( _scrollbar );
        } else {
            super.addChild( _scrollbar );
            super.addChild( _contents  );
        }
    }

    mixin DisableModifyChildren;
}

alias HorizontalScrollPanelWidget = ScrollPanelWidget!true;
alias VerticalScrollPanelWidget   = ScrollPanelWidget!false;
