module Adobe.Illustrator.PageItem.TextFrame exposing (..)

import Adobe.Illustrator.PageItem.TextFrame.TextRange
import Adobe.Illustrator.Utils
import Json.Decode


type TextFrame
    = TextFrame Json.Decode.Value


textRanges : TextFrame -> List Adobe.Illustrator.PageItem.TextFrame.TextRange.TextRange
textRanges (TextFrame a) =
    a
        |> Json.Decode.decodeValue
            (Json.Decode.field "textRanges" (Json.Decode.list Adobe.Illustrator.PageItem.TextFrame.TextRange.decoder))
        |> Result.withDefault []


paragraphs : TextFrame -> List Adobe.Illustrator.PageItem.TextFrame.TextRange.TextRange
paragraphs (TextFrame a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "paragraphs" (Json.Decode.list Adobe.Illustrator.PageItem.TextFrame.TextRange.decoder))
        |> Result.withDefault []



--


decoder : Json.Decode.Decoder TextFrame
decoder =
    Adobe.Illustrator.Utils.classDecoder "TextFrame"
        (Json.Decode.value |> Json.Decode.map TextFrame)
