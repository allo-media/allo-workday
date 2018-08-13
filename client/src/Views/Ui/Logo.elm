module Views.Ui.Logo exposing (medium)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Logo." ++ string |> identify


default : Element msg
default =
    styled img
        [ identify_ "default"
        ]


medium : Element msg
medium =
    styled default
        [ identify_ "medium"
        , width (px 158)
        , height (px 158)
        ]
