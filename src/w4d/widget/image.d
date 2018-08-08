// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.image;
import w4d.style.color,
       w4d.task.window,
       w4d.widget.base;
import g4d.element.shape.rect,
       g4d.gl.texture,
       g4d.math.vector,
       g4d.shader.base,
       g4d.util.bitmap;
import std.math;

class ImageWidget : Widget
{
    protected RectElement _imageElm;
    protected Tex2D       _texture;
    protected vec2        _imageSize;
    protected vec2        _uv;

    override @property vec2 wantedSize ()
    {
        return _imageSize;
    }

    this ()
    {
        _imageElm  = new RectElement;
        _texture   = null;
        _imageSize = vec2(0,0);
        _uv        = vec2(0,0);
    }

    void setImage (B) ( B bmp )
        if ( isBitmap!B )
    {
        if ( !bmp ) {
            _texture   = null;
            _imageSize = vec2(0,0);
            _uv        = vec2(0,0);
            return;
        }

        _texture = new Tex2D( bmp );

        _imageSize = vec2(_texture.size);
        _uv.x      = bmp.width/_imageSize.x;
        _uv.y      = bmp.rows /_imageSize.y;
        resizeElement();
    }

    protected void resizeElement ()
    {
        if ( _texture ) {
            auto sz = style.box.clientSize;
            _imageElm.resize( sz, _uv );
        }
    }
    override vec2 layout ( vec2 pos, vec2 size )
    {
        scope(success) resizeElement();
        return super.layout( pos, size );
    }
    override void draw ( Window w, ColorSet parent )
    {
        super.draw( w, parent );

        if ( _texture ) {
            auto shader = w.shaders.rgba3;
            auto saver  = ShaderStateSaver( shader );
            auto late   = style.clientLeftTop + style.box.clientSize/2;

            shader.use();
            shader.setVectors( vec3(late,0), vec3(PI,0,0) );
            shader.uploadTexture( _texture );
            _imageElm.draw( shader );
        }
    }

    override @property bool trackable () { return false; }
    override @property bool focusable () { return false; }
}
