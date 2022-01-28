module Adobe.Illustrator.Color.CMYK exposing (..)

import JavaScript
import Json.Decode
import Json.Encode
import Quantity
import Task


type alias CMYK =
    { cyan : Float
    , magenta : Float
    , yellow : Float
    , key : Float
    }


eq : CMYK -> CMYK -> Bool
eq a b =
    Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.cyan) (Quantity.float b.cyan)
        && Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.magenta) (Quantity.float b.magenta)
        && Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.yellow) (Quantity.float b.yellow)
        && Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.key) (Quantity.float b.key)


white : CMYK
white =
    CMYK 0 0 0 0


cyan : CMYK
cyan =
    CMYK 100 0 0 0


magenta : CMYK
magenta =
    CMYK 0 100 0 0


yellow : CMYK
yellow =
    CMYK 0 0 100 0


black : CMYK
black =
    CMYK 0 0 0 100


richBlack : CMYK
richBlack =
    CMYK 60 40 40 100



--


decoder : Json.Decode.Decoder CMYK
decoder =
    let
        decoder_ : Json.Decode.Decoder CMYK
        decoder_ =
            Json.Decode.map4
                CMYK
                (Json.Decode.field "cyan" Json.Decode.float)
                (Json.Decode.field "magenta" Json.Decode.float)
                (Json.Decode.field "yellow" Json.Decode.float)
                (Json.Decode.field "black" Json.Decode.float)
    in
    Json.Decode.field "typename" Json.Decode.string
        |> Json.Decode.andThen
            (\v ->
                if v == "CMYKColor" then
                    decoder_

                else
                    Json.Decode.fail "Not a CMYKColor."
            )


encode : CMYK -> Task.Task JavaScript.Error Json.Decode.Value
encode a =
    JavaScript.run "(function () { var b = new CMYKColor(); b.cyan = a[0]; b.magenta = a[1]; b.yellow = a[2]; b.black = a[3]; return b; })()"
        (Json.Encode.list Json.Encode.float [ a.cyan, a.magenta, a.yellow, a.key ])
        Json.Decode.value
