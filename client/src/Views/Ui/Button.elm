module Views.Ui.Button exposing (primary, secondary)

import Css exposing (..)
import Html.Styled exposing (button, styled)
import Views.Theme exposing (Element, identify)


default : Element msg
default =
    styled button
        [ identify "Views.UI.Button.default"
        , fontSize (Css.rem 1)
        , textAlign center
        , color (hex "FFF")
        , textTransform uppercase
        , height (px 54)
        , borderRadius (px 2.2)
        ]


primary : Element msg
primary =
    styled default
        [ identify "Views.UI.Button.primary"
        , backgroundColor (rgba 116 107 222 1)
        ]


secondary : Element msg
secondary =
    styled default
        [ identify "Views.UI.Button.secondary" ]
