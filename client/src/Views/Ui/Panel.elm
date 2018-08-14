module Views.Ui.Panel exposing (medium)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Panel." ++ string |> identify


default : Element msg
default =
    styled div
        [ identify_ "default"
        , backgroundColor (hex "FFF")
        , borderRadius (px 5.5)
        , boxShadow5 zero zero (px 3) (px 2) (rgba 0 0 0 0.15)
        , padding (px 10)
        ]


medium : Element msg
medium =
    styled default
        [ identify_ "medium"
        , width (px 462)
        , minHeight (px 414)
        ]
