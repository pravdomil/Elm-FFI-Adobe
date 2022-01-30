module Adobe.Illustrator.PageItem.TextFrame.TextRange exposing (..)

import Adobe.Illustrator.Color
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
            (\v ->
                JavaScript.run "a.a.characterAttributes.fillColor = a.color"
                    (Json.Encode.object
                        [ ( "a", a |> value )
                        , ( "color", v )
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
            (\v ->
                JavaScript.run "a.a.characterAttributes.strokeColor = a.color"
                    (Json.Encode.object
                        [ ( "a", a |> value )
                        , ( "color", v )
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


decoder : Json.Decode.Decoder TextRange
decoder =
    Json.Decode.value |> Json.Decode.map TextRange


value : TextRange -> Json.Decode.Value
value (TextRange a) =
    a
