module Adobe.Illustrator.PageItem.PathItem exposing (..)

import Adobe.Illustrator.Color
import JavaScript
import Json.Decode
import Json.Encode
import Length
import Task


type PathItem
    = PathItem Json.Decode.Value


fillColor : PathItem -> Adobe.Illustrator.Color.Color
fillColor (PathItem a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "fillColor" Adobe.Illustrator.Color.decoder)
        |> Result.withDefault Adobe.Illustrator.Color.unknown


setFillColor : Adobe.Illustrator.Color.Color -> PathItem -> Task.Task JavaScript.Error PathItem
setFillColor color a =
    Adobe.Illustrator.Color.encode color
        |> Task.andThen
            (\v ->
                JavaScript.run "a.a.fillColor = a.color"
                    (Json.Encode.object
                        [ ( "a", a |> value )
                        , ( "color", v )
                        ]
                    )
                    (Json.Decode.succeed a)
            )



--


strokeColor : PathItem -> Adobe.Illustrator.Color.Color
strokeColor (PathItem a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "strokeColor" Adobe.Illustrator.Color.decoder)
        |> Result.withDefault Adobe.Illustrator.Color.unknown


setStrokeColor : Adobe.Illustrator.Color.Color -> PathItem -> Task.Task JavaScript.Error PathItem
setStrokeColor color a =
    Adobe.Illustrator.Color.encode color
        |> Task.andThen
            (\v ->
                JavaScript.run "a.a.strokeColor = a.color"
                    (Json.Encode.object
                        [ ( "a", a |> value )
                        , ( "color", v )
                        ]
                    )
                    (Json.Decode.succeed a)
            )


strokeWidth : PathItem -> Length.Length
strokeWidth (PathItem a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "strokeWidth" (Json.Decode.float |> Json.Decode.map Length.points))
        |> Result.withDefault (Length.points 1)


setStrokeWidth : Length.Length -> PathItem -> Task.Task JavaScript.Error PathItem
setStrokeWidth width a =
    JavaScript.run "a.a.strokeWidth = a.b"
        (Json.Encode.object
            [ ( "a", a |> value )
            , ( "b", width |> Length.inPoints |> Json.Encode.float )
            ]
        )
        (Json.Decode.succeed a)



--


decoder : Json.Decode.Decoder PathItem
decoder =
    Json.Decode.field "typename" Json.Decode.string
        |> Json.Decode.andThen
            (\v ->
                if v == "PathItem" then
                    Json.Decode.value |> Json.Decode.map PathItem

                else
                    Json.Decode.fail "Not a PathItem."
            )


value : PathItem -> Json.Decode.Value
value (PathItem a) =
    a
