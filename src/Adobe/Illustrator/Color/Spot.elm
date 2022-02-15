module Adobe.Illustrator.Color.Spot exposing (..)

import Adobe.Illustrator.Utils
import BoundingBox2d
import JavaScript
import Json.Decode
import Json.Encode
import Length
import Task


type Spot
    = Spot Json.Decode.Value


decoder : Json.Decode.Decoder Spot
decoder =
    Adobe.Illustrator.Utils.classDecoder "Spot"
        (Json.Decode.value |> Json.Decode.map Spot)
