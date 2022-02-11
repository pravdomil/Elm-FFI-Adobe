module Adobe.Illustrator.PageItem.PlacedItem exposing (..)

import Adobe.Illustrator.Utils
import Json.Decode


type PlacedItem
    = PlacedItem Json.Decode.Value



--


decoder : Json.Decode.Decoder PlacedItem
decoder =
    Adobe.Illustrator.Utils.classDecoder "PlacedItem"
        (Json.Decode.value |> Json.Decode.map PlacedItem)
