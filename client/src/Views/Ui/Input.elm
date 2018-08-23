module Views.Ui.Input exposing (fullWidth, medium, small)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Input." ++ string |> identify


default : Style
default =
    Css.batch
        [ identify_ "default"
        , borderRadius (px 2.2)
        , backgroundColor (hex "e5e9ed")
        , border3 (px 0.6) solid (rgba 208 208 208 0.5)
        , padding2 (px 14) zero
        , margin2 (px 10) auto
        , color (rgba 120 126 140 1)
        , fontSize (Css.rem 1.125)
        , textIndent (px 14)
        , outline none
        ]


small : Element msg
small =
    styled input
        [ default
        , identify_ "small"
        , width (pct 25)
        ]


medium : Element msg
medium =
    styled input
        [ default
        , identify_ "medium"
        , width (pct 50)
        ]


fullWidth : Element msg
fullWidth =
    styled input
        [ default
        , identify_ "fullWidth"
        , width (pct 100)
        ]
