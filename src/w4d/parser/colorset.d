// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.parser.colorset;
import w4d.parser.exception,
       w4d.style.color,
       w4d.style.widget;
import g4d.math.vector;
import dyaml;
import std.uni;

private @property WidgetState toState ( string v )
{
    switch ( v.toLower ) with ( WidgetState ) {
        case "focused" : return Focused;
        case "tracked" : return Tracked;
        case "pressed" : return Pressed;
        case "hovered" : return Hovered;
        case "selected": return Selected;
        case "default" : return None;

        default:
            throw new ParsingException( "Unknown state." );
    }
}

vec4 parseColor ( Node seq )
{
    enforce( seq.isSequence, "Color must be specified by sequence." );

    auto arr = seq.sequence!float;
    switch ( arr.length ) {
        case 0:
            return vec4( 0, 0, 0, 0 );
        case 1:
            return vec4( arr[0], arr[0], arr[0], 1 );
        case 3:
            return vec4( arr[0], arr[1], arr[2], 1 );
        case 4:
            return vec4( arr[0], arr[1], arr[2], arr[3] );

        default:
            throw new ParsingException( "Invalid color sequence." );
    }
}

void parseColorSet ( Node block, ref ColorSet colorset )
{
    foreach ( string name, Node node; block ) {
        colorset[name] = parseColor( node );
    }
}

void parseColorSets ( Node root, WidgetStyle style )
{
    foreach ( string name, Node node; root ) {
        auto state = name.toState;
        if ( state !in style.colorsets ) {
            style.colorsets[state] = ColorSet();
        }
        parseColorSet( node, style.colorsets[state] );
    }
}

void parseColorSetsFromFile ( string path, WidgetStyle style )
{
    Loader.fromFile(path).load().parseColorSets( style );
}
void parseColorSetsFromFile ( string path ) ( WidgetStyle style )
{
    Loader.fromString(import(path)).load().parseColorSets( style );
}
