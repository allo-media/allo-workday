port module Ports exposing (print, saveStore, storeChanged)

import Json.Encode as Encode


port print : () -> Cmd msg


port saveStore : String -> Cmd msg


port storeChanged : (String -> msg) -> Sub msg
