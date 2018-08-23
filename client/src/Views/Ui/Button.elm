module Views.Ui.Button exposing (primary, primaryFullWidth, secondary)

import Css exposing (..)
import Html.Styled exposing (button, styled)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Button." ++ string |> identify


default : Style
default =
    Css.batch
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
    styled button
        [ default
        , identify_ "primary"
        , backgroundColor (rgba 116 107 222 1)
        ]


primaryFullWidth : Element msg
primaryFullWidth =
    styled primary
        [ identify_ "primaryFullWidth"
        , width (pct 100)
        ]


secondary : Element msg
secondary =
    styled button
        [ identify_ "secondary" ]
