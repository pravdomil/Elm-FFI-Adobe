module Adobe.Illustrator.Color.None exposing (..)

import JavaScript
import Json.Decode
import Json.Encode
import Task


type None
    = None


eq : None -> None -> Bool
eq _ _ =
    True


decoder : Json.Decode.Decoder None
decoder =
    Json.Decode.field "typename" Json.Decode.string
        |> Json.Decode.andThen
            (\v ->
                if v == "NoColor" then
                    Json.Decode.succeed None

                else
                    Json.Decode.fail "Not a NoColor."
            )


encode : None -> Task.Task JavaScript.Error Json.Decode.Value
encode _ =
    JavaScript.run "new NoColor()"
        Json.Encode.null
        Json.Decode.value
