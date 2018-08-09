module Views.Ui.Button exposing (primary, primaryLarge, secondary)

import Css exposing (..)
import Html.Styled exposing (button, styled)
import Views.Theme exposing (Element, identify)


baseIdentifyKey : String -> String
baseIdentifyKey string =
    "Views.UI.Button." ++ string


default : Element msg
default =
    styled button
        [ identify <| baseIdentifyKey "default"
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
        [ identify <| baseIdentifyKey "primary"
        , backgroundColor (rgba 116 107 222 1)
        ]


primaryLarge : Element msg
primaryLarge =
    styled primary
        [ identify <| baseIdentifyKey "primaryLarge"
        , width (pct 75)
        ]


secondary : Element msg
secondary =
    styled default
        [ identify <| baseIdentifyKey "secondary" ]
