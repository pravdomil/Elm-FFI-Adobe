module Adobe.Illustrator.Document exposing (..)

import Adobe.Illustrator.Artboard
import Adobe.Illustrator.Color.Spot
import Adobe.Illustrator.File
import Adobe.Illustrator.PageItem
import Adobe.Illustrator.PageItem.PathItem
import Adobe.Illustrator.PageItem.TextFrame
import Adobe.Illustrator.Utils
import JavaScript
import Json.Decode
import Json.Encode
import Task


{-| <https://github.com/aenhancers/Types-for-Adobe/blob/5053d9a06b6f7f4759bea9ea1bdf4f20eee14106/Illustrator/2015.3/index.d.ts#L8312>
-}
type Document
    = Document Json.Decode.Value


opened : Task.Task JavaScript.Error (List Document)
opened =
    JavaScript.run "app.documents"
        Json.Encode.null
        (Json.Decode.list decoder)


active : Task.Task JavaScript.Error (Maybe Document)
active =
    JavaScript.run "app.activeDocument"
        Json.Encode.null
        (Json.Decode.nullable decoder)
        |> Task.onError (\_ -> Task.succeed Nothing)



--


selection : Document -> List Adobe.Illustrator.PageItem.PageItem
selection (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "selection" (Json.Decode.list Adobe.Illustrator.PageItem.decoder))
        |> Result.withDefault []


setSelection : List Adobe.Illustrator.PageItem.PageItem -> Document -> Task.Task JavaScript.Error ()
setSelection items (Document doc) =
    JavaScript.run "a.doc.selection = a.value"
        (Json.Encode.object
            [ ( "doc", doc )
            , ( "value", Json.Encode.list Adobe.Illustrator.PageItem.value items )
            ]
        )
        (Json.Decode.succeed ())



--


type ColorSpace
    = Cmyk
    | Rgb


colorSpace : Document -> ColorSpace
colorSpace (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.at [ "documentColorSpace", "typename" ] Json.Decode.string)
        |> Result.withDefault ""
        |> (\x ->
                if x == "DocumentColorSpace.CMYK" then
                    Cmyk

                else
                    Rgb
           )


colorSpaceToString : ColorSpace -> String
colorSpaceToString a =
    case a of
        Cmyk ->
            "CMYK"

        Rgb ->
            "RGB"


{-| <https://community.adobe.com/t5/illustrator/change-documentcolorspace-to-rgb-via-javascript/m-p/11109097#M175761>
-}
setColorSpace : ColorSpace -> Document -> Task.Task JavaScript.Error ()
setColorSpace a (Document _) =
    let
        cmd : String
        cmd =
            case a of
                Cmyk ->
                    "doc-color-cmyk"

                Rgb ->
                    "doc-color-rgb"
    in
    JavaScript.run "app.executeMenuCommand(a)"
        (Json.Encode.string cmd)
        (Json.Decode.succeed ())



--


spotColors : Document -> List Adobe.Illustrator.Color.Spot.Spot
spotColors (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "spots" (Json.Decode.list Adobe.Illustrator.Color.Spot.decoder))
        |> Result.withDefault []



--


fileName : Document -> String
fileName (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "name" Json.Decode.string)
        |> Result.withDefault ""


folder : Document -> Maybe Adobe.Illustrator.File.File
folder (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "path" Adobe.Illustrator.File.decoder)
        |> Result.toMaybe



--


artboards : Document -> List Adobe.Illustrator.Artboard.Artboard
artboards (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "artboards" (Json.Decode.list Adobe.Illustrator.Artboard.decoder))
        |> Result.withDefault []



--


pageItems : Document -> List Adobe.Illustrator.PageItem.PageItem
pageItems (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "pageItems" (Json.Decode.list Adobe.Illustrator.PageItem.decoder))
        |> Result.withDefault []


pathItems : Document -> List Adobe.Illustrator.PageItem.PathItem.PathItem
pathItems (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "pathItems" (Json.Decode.list Adobe.Illustrator.PageItem.PathItem.decoder))
        |> Result.withDefault []


textFrames : Document -> List Adobe.Illustrator.PageItem.TextFrame.TextFrame
textFrames (Document a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "textFrames" (Json.Decode.list Adobe.Illustrator.PageItem.TextFrame.decoder))
        |> Result.withDefault []



--


decoder : Json.Decode.Decoder Document
decoder =
    Adobe.Illustrator.Utils.classDecoder "Document"
        (Json.Decode.value |> Json.Decode.map Document)
