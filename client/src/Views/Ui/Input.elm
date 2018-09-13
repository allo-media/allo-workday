module Views.Ui.Input exposing (default, fullWidth, invalid, medium, small, valid)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, formStyle, identify, placeHolder, theme)


identify_ : String -> Style
identify_ string =
    "Views.UI.Input." ++ string |> identify


default : Element msg
default =
    styled input
        [ formStyle
        , identify_ "default"
        ]


small : Element msg
small =
    styled input
        [ formStyle
        , identify_ "small"
        , width (pct 25)
        ]


medium : Element msg
medium =
    styled input
        [ formStyle
        , identify_ "medium"
        , width (pct 50)
        ]


fullWidth : Element msg
fullWidth =
    styled input
        [ formStyle
        , identify_ "fullWidth"
        , width (pct 100)
        ]


valid : Element msg
valid =
    styled input
        [ formStyle
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
        [ formStyle
        , identify_ "invalid"
        , borderColor theme.dangerColor
        , color theme.dangerColor
        , hover
            [ borderColor theme.dangerColor
            ]
        ]
