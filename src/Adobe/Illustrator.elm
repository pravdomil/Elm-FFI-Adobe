module Adobe.Illustrator exposing (..)

import JavaScript
import Json.Decode
import Json.Encode
import Task


alert : String -> Task.Task JavaScript.Error ()
alert a =
    JavaScript.run "alert(a)"
        (Json.Encode.string a)
        (Json.Decode.succeed ())


alertDialog : String -> String -> Task.Task JavaScript.Error ()
alertDialog title text =
    JavaScript.run "(function(){ var b = new Window('dialog', a.a); b.add('statictext', { x: undefined, y: undefined, width: 320, height: 320 }, a.b, { multiline: true, scrolling: true }); b.add('button', undefined, 'OK'); return b.show(); })()"
        (Json.Encode.object
            [ ( "a", Json.Encode.string title )
            , ( "b", Json.Encode.string text )
            ]
        )
        (Json.Decode.succeed ())


prompt : String -> Task.Task JavaScript.Error (Maybe String)
prompt a =
    JavaScript.run "prompt(a, '')"
        (Json.Encode.string a)
        (Json.Decode.nullable Json.Decode.string)
