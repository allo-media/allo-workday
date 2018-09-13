module Views.Ui.Textarea exposing (default, fullWidth)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, formStyle, identify, placeHolder, theme)


identify_ : String -> Style
identify_ string =
    "Views.UI.Textarea." ++ string |> identify


textareaStyle : Style
textareaStyle =
    Css.batch
        [ resize vertical
        , verticalAlign top
        , minHeight (px 40)
        , lineHeight (pct 140)
        ]


default : Element msg
default =
    styled textarea
        [ formStyle
        , textareaStyle
        , identify_ "default"
        ]


fullWidth : Element msg
fullWidth =
    styled textarea
        [ formStyle
        , textareaStyle
        , width (pct 100)
        ]
