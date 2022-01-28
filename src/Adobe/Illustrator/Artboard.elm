module Adobe.Illustrator.Artboard exposing (..)

import Adobe.Illustrator.Utils
import BoundingBox2d
import JavaScript
import Json.Decode
import Json.Encode
import Length
import Task


type Artboard
    = Artboard Json.Decode.Value


boundingBox : Artboard -> BoundingBox2d.BoundingBox2d Length.Meters coordinates
boundingBox (Artboard a) =
    a |> Adobe.Illustrator.Utils.decodeBoundingBox "artboardRect"


resize : BoundingBox2d.BoundingBox2d Length.Meters coordinates -> Artboard -> Task.Task JavaScript.Error Artboard
resize box a =
    JavaScript.run "a.a.artboardRect = a.b"
        (Json.Encode.object
            [ ( "a", (\(Artboard v) -> v) a )
            , ( "b", Adobe.Illustrator.Utils.encodeBoundingBox box )
            ]
        )
        (Json.Decode.succeed a)


decoder : Json.Decode.Decoder Artboard
decoder =
    Json.Decode.value |> Json.Decode.map Artboard
