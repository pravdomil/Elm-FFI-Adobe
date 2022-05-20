module Adobe.Illustrator.Color exposing (..)

import Adobe.Illustrator.Color.Cmyk
import Adobe.Illustrator.Color.RGB_
import Adobe.Illustrator.Utils
import JavaScript
import Json.Decode
import Json.Encode
import Task


type Color
    = CMYK Adobe.Illustrator.Color.Cmyk.CMYK
    | RGB Adobe.Illustrator.Color.RGB_.RGB
    | Unknown Json.Decode.Value



--


unknown : Color
unknown =
    Unknown Json.Encode.null


eq : Color -> Color -> Bool
eq a b =
    case ( a, b ) of
        ( CMYK a2, CMYK b2 ) ->
            Adobe.Illustrator.Color.Cmyk.eq a2 b2

        ( RGB a2, RGB b2 ) ->
            Adobe.Illustrator.Color.RGB_.eq a2 b2

        _ ->
            False



--


decoder : Json.Decode.Decoder (Maybe Color)
decoder =
    Json.Decode.oneOf
        [ noColorDecoder |> Json.Decode.map (\_ -> Nothing)
        , Adobe.Illustrator.Color.Cmyk.decoder |> Json.Decode.map (CMYK >> Just)
        , Adobe.Illustrator.Color.RGB_.decoder |> Json.Decode.map (RGB >> Just)
        , Json.Decode.value |> Json.Decode.map (Unknown >> Just)
        ]


encode : Maybe Color -> Task.Task JavaScript.Error Json.Decode.Value
encode a =
    case a of
        Just b ->
            case b of
                CMYK c ->
                    c |> Adobe.Illustrator.Color.Cmyk.encode

                RGB c ->
                    c |> Adobe.Illustrator.Color.RGB_.encode

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
