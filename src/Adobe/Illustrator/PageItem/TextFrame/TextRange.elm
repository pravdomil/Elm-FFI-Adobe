module Adobe.Illustrator.PageItem.TextFrame.TextRange exposing (..)

import Adobe.Illustrator.Color
import Adobe.Illustrator.Utils
import JavaScript
import Json.Decode
import Json.Encode
import Length
import Task


type TextRange
    = TextRange Json.Decode.Value


fillColor : TextRange -> Maybe Adobe.Illustrator.Color.Color
fillColor (TextRange a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.at [ "characterAttributes", "fillColor" ] Adobe.Illustrator.Color.decoder)
        |> Result.withDefault Nothing


setFillColor : Maybe Adobe.Illustrator.Color.Color -> TextRange -> Task.Task JavaScript.Error TextRange
setFillColor color a =
    Adobe.Illustrator.Color.encode color
        |> Task.andThen
            (\x ->
                JavaScript.run "a.a.characterAttributes.fillColor = a.color"
                    (Json.Encode.object
                        [ ( "a", a |> value )
                        , ( "color", x )
                        ]
                    )
                    (Json.Decode.succeed a)
            )



--


strokeColor : TextRange -> Maybe Adobe.Illustrator.Color.Color
strokeColor (TextRange a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.at [ "characterAttributes", "strokeColor" ] Adobe.Illustrator.Color.decoder)
        |> Result.withDefault Nothing


setStrokeColor : Maybe Adobe.Illustrator.Color.Color -> TextRange -> Task.Task JavaScript.Error TextRange
setStrokeColor color a =
    Adobe.Illustrator.Color.encode color
        |> Task.andThen
            (\x ->
                JavaScript.run "a.a.characterAttributes.strokeColor = a.color"
                    (Json.Encode.object
                        [ ( "a", a |> value )
                        , ( "color", x )
                        ]
                    )
                    (Json.Decode.succeed a)
            )


strokeWidth : TextRange -> Length.Length
strokeWidth (TextRange a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.at [ "characterAttributes", "strokeWeight" ] (Json.Decode.float |> Json.Decode.map Length.points))
        |> Result.withDefault (Length.points 1)



--


fontFamily : TextRange -> String
fontFamily (TextRange a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.at [ "characterAttributes", "textFont", "family" ] Json.Decode.string)
        |> Result.withDefault ""


fontStyle : TextRange -> String
fontStyle (TextRange a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.at [ "characterAttributes", "textFont", "style" ] Json.Decode.string)
        |> Result.withDefault ""


fontSize : TextRange -> Length.Length
fontSize (TextRange a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.at [ "characterAttributes", "size" ] (Json.Decode.float |> Json.Decode.map Length.points))
        |> Result.withDefault (Length.points 1)



--


text : TextRange -> String
text (TextRange a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "contents" Json.Decode.string)
        |> Result.withDefault ""



--


decoder : Json.Decode.Decoder TextRange
decoder =
    Adobe.Illustrator.Utils.classDecoder "TextRange"
        (Json.Decode.value |> Json.Decode.map TextRange)


value : TextRange -> Json.Decode.Value
value (TextRange a) =
    a
