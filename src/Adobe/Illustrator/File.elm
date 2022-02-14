module Adobe.Illustrator.File exposing (..)

import Adobe.Illustrator.Utils
import JavaScript
import Json.Decode
import Json.Encode
import Task


{-| <https://github.com/aenhancers/Types-for-Adobe/blob/5053d9a06b6f7f4759bea9ea1bdf4f20eee14106/shared/JavaScript.d.ts#L1519>
-}
type File
    = File Json.Decode.Value


open : String -> Task.Task JavaScript.Error (Maybe File)
open a =
    JavaScript.run "(function () { var b = new File(a); if (!b.exists) { b.close(); return null; }; return b; })()"
        (Json.Encode.string a)
        (Json.Decode.nullable (Json.Decode.map File Json.Decode.value))


path : File -> Maybe String
path (File a) =
    a
        |> Json.Decode.decodeValue (Json.Decode.field "fsName" Json.Decode.string)
        |> Result.toMaybe
        |> (\v ->
                case v of
                    Just "" ->
                        Nothing

                    _ ->
                        v
           )


decoder : Json.Decode.Decoder File
decoder =
    Json.Decode.value |> Json.Decode.map File
