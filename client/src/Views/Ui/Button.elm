module Views.Ui.Button exposing (primary, primaryFullWidth, secondary)

import Css as Css exposing (..)
import Html.Styled exposing (button, styled)
import Views.Theme as VT exposing (Element, darken, identify, theme)


identify_ : String -> Style
identify_ string =
    "Views.UI.Button." ++ string |> identify


default : Style
default =
    Css.batch
        [ identify_ "default"
        , textAlign center
        , color (hex "FFF")
        , border (px 0)
        , padding2 (px 12) (px 18)
        , fontWeight (int 800)
        , borderRadius (px 5)
        , cursor pointer
        , outline none
        ]


primary : Element msg
primary =
    styled button
        [ default
        , identify_ "primary"
        , backgroundImage <|
            linearGradient
                (stop <| theme.primaryColor)
                (stop <| VT.darken 0.5 theme.primaryColor)
                []
        , hover
            [ backgroundColor (rgb 98 89 210)
            ]
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
