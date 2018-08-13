module Views.Ui.Button exposing (primary, primaryLarge, secondary)

import Css exposing (..)
import Html.Styled exposing (button, styled)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Button." ++ string |> identify


default : Element msg
default =
    styled button
        [ identify_ "default"
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
        [ identify_ "primary"
        , backgroundColor (rgba 116 107 222 1)
        ]


primaryLarge : Element msg
primaryLarge =
    styled primary
        [ identify_ "primaryLarge"
        , width (pct 75)
        ]


secondary : Element msg
secondary =
    styled default
        [ identify_ "secondary" ]
