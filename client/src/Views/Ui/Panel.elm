module Views.Ui.Panel exposing (medium)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element)


panel : Element msg
panel =
    styled div
        [ backgroundColor (hex "FFF")
        , width (px 462)
        , minHeight (px 744)
        , borderRadius (px 5.5)
        , boxShadow5 zero zero (px 3) (px 2) (rgba 0 0 0 0.15)
        ]


medium : Element msg
medium =
    styled panel
        [ width (px 462)
        , minHeight (px 744)
        ]
