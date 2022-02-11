module Adobe.Illustrator.PageItem.PathItem exposing (..)

import Adobe.Illustrator.Color
import Adobe.Illustrator.Utils
import JavaScript
import Json.Decode
import Json.Encode
import Length
import Point2d
import Task


type PathItem
    = PathItem Json.Decode.Value


setPoints : List (Point2d.Point2d Length.Meters coordinates) -> PathItem -> Task.Task JavaScript.Error PathItem
setPoints points a =
    JavaScript.run "a.a.setEntirePath(a.b)"
        (Json.Encode.object
            [ ( "a", a |> value )
            , ( "b", points |> Json.Encode.list Adobe.Illustrator.Utils.encodePoint2d )
            ]
        )
        (Json.Decode.succeed a)



--


fillColor : PathItem -> Maybe Adobe.Illustrator.Color.Color
fillColor (PathItem a) =
    a
        |> Json.Decode.decodeValue
            (Json.Decode.field "filled" Json.Decode.bool
                |> Json.Decode.andThen
                    (\v ->
                        if v then
                            Json.Decode.field "fillColor" Adobe.Illustrator.Color.decoder

                        else
                            Json.Decode.succeed Nothing
                    )
            )
        |> Result.withDefault Nothing


setFillColor : Maybe Adobe.Illustrator.Color.Color -> PathItem -> Task.Task JavaScript.Error PathItem
setFillColor color a =
    Adobe.Illustrator.Color.encode color
        |> Task.andThen
            (\v ->
                JavaScript.run "(function() { a.a.filled = a.b; a.a.fillColor = a.c })()"
                    (Json.Encode.object
                        [ ( "a", a |> value )
                        , ( "b", color /= Nothing |> Json.Encode.bool )
                        , ( "c", v )
                        ]
                    )
                    (Json.Decode.succeed a)
            )



--


strokeColor : PathItem -> Maybe Adobe.Illustrator.Color.Color
strokeColor (PathItem a) =
    a
        |> Json.Decode.decodeValue
            (Json.Decode.field "stroked" Json.Decode.bool
                |> Json.Decode.andThen
                    (\v ->
                        if v then
                            Json.Decode.field "strokeColor" Adobe.Illustrator.Color.decoder

                        else
                            Json.Decode.succeed Nothing
                    )
            )
        |> Result.withDefault Nothing


setStrokeColor : Maybe Adobe.Illustrator.Color.Color -> PathItem -> Task.Task JavaScript.Error PathItem
setStrokeColor color a =
    Adobe.Illustrator.Color.encode color
        |> Task.andThen
            (\v ->
                JavaScript.run "(function() { a.a.stroked = a.b; a.a.strokeColor = a.c })()"
                    (Json.Encode.object
                        [ ( "a", a |> value )
                        , ( "b", color /= Nothing |> Json.Encode.bool )
                        , ( "c", v )
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
    Adobe.Illustrator.Utils.classDecoder "PathItem"
        (Json.Decode.value |> Json.Decode.map PathItem)


value : PathItem -> Json.Decode.Value
value (PathItem a) =
    a
