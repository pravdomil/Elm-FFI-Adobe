module Adobe.Illustrator.Color.Rgb exposing (..)

import Adobe.Illustrator.Utils
import JavaScript
import Json.Decode
import Json.Encode
import Quantity
import Task


type alias Rgb =
    { red : Float
    , green : Float
    , blue : Float
    }


eq : Rgb -> Rgb -> Bool
eq a b =
    Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.red) (Quantity.float b.red)
        && Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.green) (Quantity.float b.green)
        && Quantity.equalWithin (Quantity.float 0.01) (Quantity.float a.blue) (Quantity.float b.blue)



--


decoder : Json.Decode.Decoder Rgb
decoder =
    let
        decoder_ : Json.Decode.Decoder Rgb
        decoder_ =
            Json.Decode.map3
                Rgb
                (Json.Decode.field "red" Json.Decode.float)
                (Json.Decode.field "green" Json.Decode.float)
                (Json.Decode.field "blue" Json.Decode.float)
    in
    Adobe.Illustrator.Utils.classDecoder "RGBColor" decoder_


encode : Rgb -> Task.Task JavaScript.Error Json.Decode.Value
encode a =
    JavaScript.run "(function () { var b = new RGBColor(); b.red = a[0]; b.green = a[1]; b.blue = a[2]; return b; })()"
        (Json.Encode.list Json.Encode.float [ a.red, a.green, a.blue ])
        Json.Decode.value
