module Adobe.Illustrator.Color exposing (..)

import Adobe.Illustrator.Color.Cmyk
import Adobe.Illustrator.Color.Rgb
import Adobe.Illustrator.Utils
import JavaScript
import Json.Decode
import Json.Encode
import Task


type Color
    = Cmyk Adobe.Illustrator.Color.Cmyk.Cmyk
    | Rgb Adobe.Illustrator.Color.Rgb.Rgb
    | Unknown Json.Decode.Value



--


unknown : Color
unknown =
    Unknown Json.Encode.null


eq : Color -> Color -> Bool
eq a b =
    case ( a, b ) of
        ( Cmyk a2, Cmyk b2 ) ->
            Adobe.Illustrator.Color.Cmyk.eq a2 b2

        ( Rgb a2, Rgb b2 ) ->
            Adobe.Illustrator.Color.Rgb.eq a2 b2

        _ ->
            False



--


decoder : Json.Decode.Decoder (Maybe Color)
decoder =
    Json.Decode.oneOf
        [ noColorDecoder |> Json.Decode.map (\_ -> Nothing)
        , Adobe.Illustrator.Color.Cmyk.decoder |> Json.Decode.map (Cmyk >> Just)
        , Adobe.Illustrator.Color.Rgb.decoder |> Json.Decode.map (Rgb >> Just)
        , Json.Decode.value |> Json.Decode.map (Unknown >> Just)
        ]


encode : Maybe Color -> Task.Task JavaScript.Error Json.Decode.Value
encode a =
    case a of
        Just b ->
            case b of
                Cmyk c ->
                    c |> Adobe.Illustrator.Color.Cmyk.encode

                Rgb c ->
                    c |> Adobe.Illustrator.Color.Rgb.encode

                Unknown c ->
                    c |> Task.succeed

        Nothing ->
            encodeNoColor



--


noColorDecoder : Json.Decode.Decoder ()
noColorDecoder =
    Adobe.Illustrator.Utils.classDecoder "NoColor"
        (Json.Decode.succeed ())


encodeNoColor : Task.Task JavaScript.Error Json.Decode.Value
encodeNoColor =
    JavaScript.run "new NoColor()"
        Json.Encode.null
        Json.Decode.value
