module Views.Ui.Panel exposing (medium)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


default : Element msg
default =
    styled div
        [ identify "panel"
        , backgroundColor (hex "FFF")
        , borderRadius (px 5.5)
        , boxShadow5 zero zero (px 3) (px 2) (rgba 0 0 0 0.15)
        , padding (px 10)
        ]


medium : Element msg
medium =
    styled default
        [ identify "panel-medium"
        , width (px 462)
        , minHeight (px 414)
        ]
