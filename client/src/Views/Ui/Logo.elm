module Views.Ui.Logo exposing (medium)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


baseIdentifyKey : String -> String
baseIdentifyKey string =
    "Views.UI.Logo." ++ string


default : Element msg
default =
    styled img
        [ identify <| baseIdentifyKey "default"
        ]


medium : Element msg
medium =
    styled default
        [ identify <| baseIdentifyKey "medium"
        , width (px 158)
        , height (px 158)
        ]
