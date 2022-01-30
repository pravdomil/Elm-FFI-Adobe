module Adobe.Illustrator.Color exposing (..)

import Adobe.Illustrator.Color.CMYK
import Adobe.Illustrator.Color.RGB
import JavaScript
import Json.Decode
import Json.Encode
import Task


type Color
    = CMYK Adobe.Illustrator.Color.CMYK.CMYK
    | RGB Adobe.Illustrator.Color.RGB.RGB
    | Unknown Json.Decode.Value



--


unknown : Color
unknown =
    Unknown Json.Encode.null


eq : Color -> Color -> Bool
eq a b =
    case ( a, b ) of
        ( CMYK a2, CMYK b2 ) ->
            Adobe.Illustrator.Color.CMYK.eq a2 b2

        ( RGB a2, RGB b2 ) ->
            Adobe.Illustrator.Color.RGB.eq a2 b2

        _ ->
            False



--


decoder : Json.Decode.Decoder (Maybe Color)
decoder =
    Json.Decode.oneOf
        [ noColorDecoder |> Json.Decode.map (\_ -> Nothing)
        , Adobe.Illustrator.Color.CMYK.decoder |> Json.Decode.map (CMYK >> Just)
        , Adobe.Illustrator.Color.RGB.decoder |> Json.Decode.map (RGB >> Just)
        , Json.Decode.value |> Json.Decode.map (Unknown >> Just)
        ]


encode : Maybe Color -> Task.Task JavaScript.Error Json.Decode.Value
encode a =
    case a of
        Just b ->
            case b of
                CMYK c ->
                    c |> Adobe.Illustrator.Color.CMYK.encode

                RGB c ->
                    c |> Adobe.Illustrator.Color.RGB.encode

                Unknown c ->
                    c |> Task.succeed

        Nothing ->
            encodeNoColor



--


noColorDecoder : Json.Decode.Decoder ()
noColorDecoder =
    Json.Decode.field "typename" Json.Decode.string
        |> Json.Decode.andThen
            (\v ->
                if v == "NoColor" then
                    Json.Decode.succeed ()

                else
                    Json.Decode.fail "Not a NoColor."
            )


encodeNoColor : Task.Task JavaScript.Error Json.Decode.Value
encodeNoColor =
    JavaScript.run "new NoColor()"
        Json.Encode.null
        Json.Decode.value
