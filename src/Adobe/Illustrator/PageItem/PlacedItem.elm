module Adobe.Illustrator.PageItem.PlacedItem exposing (..)

import Json.Decode


type PlacedItem
    = PlacedItem Json.Decode.Value



--


decoder : Json.Decode.Decoder PlacedItem
decoder =
    Json.Decode.field "typename" Json.Decode.string
        |> Json.Decode.andThen
            (\v ->
                if v == "PlacedItem" then
                    Json.Decode.value |> Json.Decode.map PlacedItem

                else
                    Json.Decode.fail "Not a PlacedItem."
            )
