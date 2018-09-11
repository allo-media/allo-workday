module Views.Ui.Input exposing (fullWidth, invalid, medium, small, valid)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, defaultFont, identify, theme)


identify_ : String -> Style
identify_ string =
    "Views.UI.Input." ++ string |> identify


default : Style
default =
    Css.batch
        [ identify_ "default"
        , borderRadius (px 5)
        , backgroundColor (hex "fff")
        , border3 (px 2) solid (rgba 208 208 208 0.5)
        , padding2 (px 10) (px 13)
        , marginBottom (px 10)
        , outline none
        , hover
            [ borderColor (rgba 208 208 208 0.8)
            ]
        , focus
            [ borderColor (hex "2ea2f8")
            ]
        , disabled
            [ backgroundColor (hex "e9edf1")
            , borderColor (hex "dfe3e9")
            ]
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


valid : Element msg
valid =
    styled input
        [ default
        , identify_ "valid"
        , borderColor (hex "1bb934")
        , color (hex "1bb934")
        , hover
            [ borderColor (hex "1bb934")
            ]
        ]


invalid : Element msg
invalid =
    styled input
        [ default
        , identify_ "invalid"
        , borderColor (hex "ed1c24")
        , color (hex "ed1c24")
        , hover
            [ borderColor (hex "ed1c24")
            ]
        ]
