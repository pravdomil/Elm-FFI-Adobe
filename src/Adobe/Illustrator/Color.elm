module Adobe.Illustrator.Color exposing (..)

import Adobe.Illustrator.Color.CMYK
import Adobe.Illustrator.Color.None
import Adobe.Illustrator.Color.RGB
import JavaScript
import Json.Decode
import Json.Encode
import Task


type Color
    = None Adobe.Illustrator.Color.None.None
    | CMYK Adobe.Illustrator.Color.CMYK.CMYK
    | RGB Adobe.Illustrator.Color.RGB.RGB
    | Unknown Json.Decode.Value



--


unknown : Color
unknown =
    Unknown Json.Encode.null


eq : Color -> Color -> Bool
eq a b =
    case ( a, b ) of
        ( None a2, None b2 ) ->
            Adobe.Illustrator.Color.None.eq a2 b2

        ( CMYK a2, CMYK b2 ) ->
            Adobe.Illustrator.Color.CMYK.eq a2 b2

        ( RGB a2, RGB b2 ) ->
            Adobe.Illustrator.Color.RGB.eq a2 b2

        _ ->
            False



--


decoder : Json.Decode.Decoder Color
decoder =
    Json.Decode.oneOf
        [ Adobe.Illustrator.Color.None.decoder |> Json.Decode.map None
        , Adobe.Illustrator.Color.CMYK.decoder |> Json.Decode.map CMYK
        , Adobe.Illustrator.Color.RGB.decoder |> Json.Decode.map RGB
        , Json.Decode.value |> Json.Decode.map Unknown
        ]


encode : Color -> Task.Task JavaScript.Error Json.Decode.Value
encode a =
    case a of
        None b ->
            b |> Adobe.Illustrator.Color.None.encode

        CMYK b ->
            b |> Adobe.Illustrator.Color.CMYK.encode

        RGB b ->
            b |> Adobe.Illustrator.Color.RGB.encode

        Unknown b ->
            b |> Task.succeed
