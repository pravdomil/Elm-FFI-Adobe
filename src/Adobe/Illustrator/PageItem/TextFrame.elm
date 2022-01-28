module Adobe.Illustrator.PageItem.TextFrame exposing (..)

import Adobe.Illustrator.PageItem.TextFrame.TextRange
import Json.Decode


type TextFrame
    = TextFrame Json.Decode.Value


textRanges : TextFrame -> List Adobe.Illustrator.PageItem.TextFrame.TextRange.TextRange
textRanges (TextFrame a) =
    a
        |> Json.Decode.decodeValue
            (Json.Decode.field "textRanges" (Json.Decode.list Adobe.Illustrator.PageItem.TextFrame.TextRange.decoder))
        |> Result.withDefault []



--


decoder : Json.Decode.Decoder TextFrame
decoder =
    Json.Decode.field "typename" Json.Decode.string
        |> Json.Decode.andThen
            (\v ->
                if v == "TextFrame" then
                    Json.Decode.value |> Json.Decode.map TextFrame

                else
                    Json.Decode.fail "Not a TextFrame."
            )
