module Adobe.Illustrator.PageItem exposing (..)

import Adobe.Illustrator.PageItem.PathItem
import Adobe.Illustrator.PageItem.PlacedItem
import Adobe.Illustrator.PageItem.TextFrame
import Adobe.Illustrator.Utils
import Angle
import BoundingBox2d
import JavaScript
import Json.Decode
import Json.Encode
import Length
import Quantity
import Task
import Vector2d


{-| <https://github.com/pravdomil/Types-for-Adobe/blob/5053d9a06b6f7f4759bea9ea1bdf4f20eee14106/Illustrator/2015.3/index.d.ts#L9700>
-}
type PageItem
    = PathItem Adobe.Illustrator.PageItem.PathItem.PathItem
    | PlacedItem Adobe.Illustrator.PageItem.PlacedItem.PlacedItem
    | TextFrame Adobe.Illustrator.PageItem.TextFrame.TextFrame
    | Unknown Json.Decode.Value



--


opacity : PageItem -> Quantity.Quantity Float Quantity.Unitless
opacity a =
    a
        |> value
        |> Json.Decode.decodeValue (Json.Decode.field "opacity" (Json.Decode.float |> Json.Decode.map Quantity.float))
        |> Result.withDefault (Quantity.float 100)


boundingBox : PageItem -> BoundingBox2d.BoundingBox2d Length.Meters coordinates
boundingBox a =
    a |> value |> Adobe.Illustrator.Utils.decodeBoundingBox "geometricBounds"



--


duplicate : PageItem -> Task.Task JavaScript.Error PageItem
duplicate a =
    JavaScript.run "a.duplicate()"
        (a |> value)
        decoder


remove : PageItem -> Task.Task JavaScript.Error ()
remove a =
    JavaScript.run "a.remove()"
        (a |> value)
        (Json.Decode.succeed ())



--


scale : Float -> Float -> PageItem -> Task.Task JavaScript.Error PageItem
scale scaleX scaleY a =
    JavaScript.run "a.a.resize(a.b, a.c)"
        (Json.Encode.object
            [ ( "a", a |> value )
            , ( "b", scaleX |> (*) 100 |> Json.Encode.float )
            , ( "c", scaleY |> (*) 100 |> Json.Encode.float )
            ]
        )
        (Json.Decode.succeed a)


rotate : Angle.Angle -> PageItem -> Task.Task JavaScript.Error PageItem
rotate angle a =
    JavaScript.run "a.a.rotate(a.b)"
        (Json.Encode.object
            [ ( "a", a |> value )
            , ( "b", angle |> Angle.inDegrees |> Json.Encode.float )
            ]
        )
        (Json.Decode.succeed a)


translate : Vector2d.Vector2d Length.Meters coordinates -> PageItem -> Task.Task JavaScript.Error PageItem
translate vector a =
    JavaScript.run "a.a.translate(a.b, a.c)"
        (Json.Encode.object
            [ ( "a", a |> value )
            , ( "b", vector |> Vector2d.xComponent |> Length.inPoints |> Json.Encode.float )
            , ( "c", vector |> Vector2d.yComponent |> Quantity.negate |> Length.inPoints |> Json.Encode.float )
            ]
        )
        (Json.Decode.succeed a)



--


decoder : Json.Decode.Decoder PageItem
decoder =
    Json.Decode.oneOf
        [ Adobe.Illustrator.PageItem.PathItem.decoder
            |> Json.Decode.map PathItem
        , Adobe.Illustrator.PageItem.PlacedItem.decoder
            |> Json.Decode.map PlacedItem
        , Adobe.Illustrator.PageItem.TextFrame.decoder
            |> Json.Decode.map TextFrame
        , Json.Decode.value
            |> Json.Decode.map Unknown
        ]


value : PageItem -> Json.Decode.Value
value a =
    case a of
        PathItem (Adobe.Illustrator.PageItem.PathItem.PathItem b) ->
            b

        PlacedItem (Adobe.Illustrator.PageItem.PlacedItem.PlacedItem b) ->
            b

        TextFrame (Adobe.Illustrator.PageItem.TextFrame.TextFrame b) ->
            b

        Unknown b ->
            b
