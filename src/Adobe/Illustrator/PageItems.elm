module Adobe.Illustrator.PageItems exposing (..)

import Adobe.Illustrator.Document
import Adobe.Illustrator.File
import Adobe.Illustrator.PageItem.PathItem
import Adobe.Illustrator.PageItem.PlacedItem
import BoundingBox2d
import JavaScript
import Json.Encode
import Length
import Quantity
import Rectangle2d
import Task


createPath : Adobe.Illustrator.Document.Document -> Task.Task JavaScript.Error Adobe.Illustrator.PageItem.PathItem.PathItem
createPath (Adobe.Illustrator.Document.Document a) =
    JavaScript.run "a.pathItems.add()"
        a
        Adobe.Illustrator.PageItem.PathItem.decoder


createRectangle :
    Adobe.Illustrator.Document.Document
    -> Rectangle2d.Rectangle2d Length.Meters coordinates
    -> Task.Task JavaScript.Error Adobe.Illustrator.PageItem.PathItem.PathItem
createRectangle (Adobe.Illustrator.Document.Document doc) a =
    let
        ( width, height ) =
            Rectangle2d.dimensions a

        box : BoundingBox2d.BoundingBox2d Length.Meters coordinates
        box =
            Rectangle2d.boundingBox a

        left : Length.Length
        left =
            box |> BoundingBox2d.minX

        top : Length.Length
        top =
            box |> BoundingBox2d.minY |> Quantity.negate
    in
    JavaScript.run "a.doc.pathItems.rectangle(a.top, a.left, a.width, a.height)"
        (Json.Encode.object
            [ ( "doc", doc )
            , ( "top", top |> Length.inPoints |> Json.Encode.float )
            , ( "left", left |> Length.inPoints |> Json.Encode.float )
            , ( "width", width |> Length.inPoints |> Json.Encode.float )
            , ( "height", height |> Length.inPoints |> Json.Encode.float )
            ]
        )
        Adobe.Illustrator.PageItem.PathItem.decoder


placeFile :
    Adobe.Illustrator.Document.Document
    -> Adobe.Illustrator.File.File
    -> Task.Task JavaScript.Error Adobe.Illustrator.PageItem.PlacedItem.PlacedItem
placeFile (Adobe.Illustrator.Document.Document doc) (Adobe.Illustrator.File.File file) =
    JavaScript.run "(function () { var b = a.doc.placedItems.add(); b.file = a.file; return b; })()"
        (Json.Encode.object
            [ ( "doc", doc )
            , ( "file", file )
            ]
        )
        Adobe.Illustrator.PageItem.PlacedItem.decoder
