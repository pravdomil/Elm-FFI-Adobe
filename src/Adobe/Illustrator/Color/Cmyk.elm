module Adobe.Illustrator.Color.Cmyk exposing (..)

import Adobe.Illustrator.Utils
import JavaScript
import Json.Decode
import Json.Encode
import Quantity
import Task


type alias Cmyk =
    { cyan : Float
    , magenta : Float
    , yellow : Float
    , key : Float
    }


eq : Cmyk -> Cmyk -> Bool
eq a b =
    Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.cyan) (Quantity.float b.cyan)
        && Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.magenta) (Quantity.float b.magenta)
        && Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.yellow) (Quantity.float b.yellow)
        && Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.key) (Quantity.float b.key)


white : Cmyk
white =
    Cmyk 0 0 0 0


cyan : Cmyk
cyan =
    Cmyk 100 0 0 0


magenta : Cmyk
magenta =
    Cmyk 0 100 0 0


yellow : Cmyk
yellow =
    Cmyk 0 0 100 0


black : Cmyk
black =
    Cmyk 0 0 0 100


richBlack : Cmyk
richBlack =
    Cmyk 60 40 40 100



--


decoder : Json.Decode.Decoder Cmyk
decoder =
    let
        decoder_ : Json.Decode.Decoder Cmyk
        decoder_ =
            Json.Decode.map4
                Cmyk
                (Json.Decode.field "cyan" Json.Decode.float)
                (Json.Decode.field "magenta" Json.Decode.float)
                (Json.Decode.field "yellow" Json.Decode.float)
                (Json.Decode.field "black" Json.Decode.float)
    in
    Adobe.Illustrator.Utils.classDecoder "CMYKColor" decoder_


encode : Cmyk -> Task.Task JavaScript.Error Json.Decode.Value
encode a =
    JavaScript.run "(function () { var b = new CMYKColor(); b.cyan = a[0]; b.magenta = a[1]; b.yellow = a[2]; b.black = a[3]; return b; })()"
        (Json.Encode.list Json.Encode.float [ a.cyan, a.magenta, a.yellow, a.key ])
        Json.Decode.value
