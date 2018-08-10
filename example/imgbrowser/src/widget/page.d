// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.widget.page;
import imgbrowser.util.htmlimg,
       imgbrowser.context;
import w4d, g4d;

class PageWidget : VerticalScrollPanelWidget
{
    protected ImgSearcher _searcher;
    protected Task[]      _taskStack;

    this ( string url )
    {
        super();

        _searcher = new ImgSearcher( url );
        reload();
    }

    protected void addImage ( BitmapRGBA bmp )
    {
        if ( !bmp ) return;

        auto image = new ImageWidget;
        image.setImage( bmp );
        contents.addChild( image );
    }

    protected void reload ()
    {
        contents.removeAllChildren();

        while ( true )
        {
            auto url = _searcher.pop;
            if ( url == "" ) break;

            try {
                auto media = new MediaFile( url );
                auto bmp   = media.decodeNextImage();
                addImage( bmp );
                bmp.dispose();
                media.dispose();
            } catch ( Exception e ) {
                import std.stdio;
                "Failed decoding: %s (%s)".writefln(url,e.msg);
            }
        }
    }
}
