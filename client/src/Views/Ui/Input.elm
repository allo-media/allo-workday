module Views.Ui.Input exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


baseIdentifyKey : String -> String
baseIdentifyKey string =
    "Views.UI.Input." ++ string


default : Element msg
default =
    styled input
        [ identify <| baseIdentifyKey "default"
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
        [ identify <| baseIdentifyKey "medium"
        , width (pct 50)
        , textAlign center
        ]


fullWidth : Element msg
fullWidth =
    styled default
        [ identify <| baseIdentifyKey "fullWidth"
        , width (pct 100)
        ]
