module Adobe.Illustrator.Utils exposing (..)

import BoundingBox2d
import Json.Decode
import Json.Encode
import Length
import Point2d
import Quantity


decodeBoundingBox : String -> Json.Decode.Value -> BoundingBox2d.BoundingBox2d Length.Meters coordinates
decodeBoundingBox path a =
    let
        zeroBox : BoundingBox2d.BoundingBox2d units coordinates
        zeroBox =
            BoundingBox2d.fromExtrema
                { minX = Quantity.zero, maxX = Quantity.zero, minY = Quantity.zero, maxY = Quantity.zero }
    in
    a
        |> Json.Decode.decodeValue (Json.Decode.field path boundingBoxDecoder)
        |> Result.withDefault zeroBox


boundingBoxDecoder : Json.Decode.Decoder (BoundingBox2d.BoundingBox2d Length.Meters coordinates)
boundingBoxDecoder =
    Json.Decode.map4
        (\x1 y1 x2 y2 ->
            BoundingBox2d.fromExtrema
                { minX = Length.points x1
                , maxX = Length.points x2
                , minY = Length.points -y1
                , maxY = Length.points -y2
                }
        )
        (Json.Decode.index 0 Json.Decode.float)
        (Json.Decode.index 1 Json.Decode.float)
        (Json.Decode.index 2 Json.Decode.float)
        (Json.Decode.index 3 Json.Decode.float)


encodeBoundingBox : BoundingBox2d.BoundingBox2d Length.Meters coordinates -> Json.Decode.Value
encodeBoundingBox a =
    a
        |> BoundingBox2d.extrema
        |> (\v ->
                Json.Encode.list
                    (Length.inPoints >> Json.Encode.float)
                    [ v.minX
                    , v.minY |> Quantity.negate
                    , v.maxX
                    , v.maxY |> Quantity.negate
                    ]
           )



--


encodePoint2d : Point2d.Point2d Length.Meters coordinates -> Json.Decode.Value
encodePoint2d a =
    [ a |> Point2d.xCoordinate
    , a |> Point2d.yCoordinate |> Quantity.negate
    ]
        |> Json.Encode.list
            (\v ->
                v |> Length.inPoints |> Json.Encode.float
            )



--


lengthEq : Length.Length -> Length.Length -> Bool
lengthEq a b =
    Quantity.equalWithin tolerance a b


pointEq : Point2d.Point2d Length.Meters coordinates -> Point2d.Point2d Length.Meters coordinates -> Bool
pointEq a b =
    Quantity.equalWithin tolerance (Point2d.xCoordinate a) (Point2d.xCoordinate b)
        && Quantity.equalWithin tolerance (Point2d.yCoordinate a) (Point2d.yCoordinate b)


boundingBoxEq : BoundingBox2d.BoundingBox2d Length.Meters coordinates -> BoundingBox2d.BoundingBox2d Length.Meters coordinates -> Bool
boundingBoxEq a b =
    let
        a2 =
            a |> BoundingBox2d.extrema

        b2 =
            b |> BoundingBox2d.extrema
    in
    Quantity.equalWithin tolerance a2.minX b2.minX
        && Quantity.equalWithin tolerance a2.maxX b2.maxX
        && Quantity.equalWithin tolerance a2.minY b2.minY
        && Quantity.equalWithin tolerance a2.maxY b2.maxY


tolerance : Length.Length
tolerance =
    Length.millimeters 0.01
