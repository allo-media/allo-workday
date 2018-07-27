module Views.Ui.Input exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


default : Element msg
default =
    styled input
        [ identify "Views.Ui.Input"
        , borderRadius (px 2.2)
        , backgroundColor (hex "e5e9ed")
        , border3 (px 0.6) solid (rgba 208 208 208 0.5)
        , padding2 (px 14) zero
        , color (rgba 120 126 140 1)
        , fontSize (Css.rem 1.125)
        , textIndent (px 14)
        , outline none
        ]


medium : Element msg
medium =
    styled default
        [ identify "Views.Ui.Input.medium"
        , width (pct 50)
        , textAlign center
        ]


fullWidth : Element msg
fullWidth =
    styled default
        [ identify "Views.Ui.Input.fullWidth"
        , width (pct 100)
        ]
