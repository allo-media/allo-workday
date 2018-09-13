module Views.Ui.Panel exposing (content, default, foot, head, medium)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Panel." ++ string |> identify


panelStyle : Style
panelStyle =
    Css.batch
        [ identify_ "panelStyle"
        , backgroundColor (hex "FFF")
        , border3 (px 1) solid (rgba 227 231 238 1)
        , marginBottom (px 20)
        , borderRadius (px 3)

        -- , boxShadow5 zero zero (px 3) (px 2) (rgba 0 0 0 0.15)
        ]


default : Element msg
default =
    styled div
        [ identify_ "default"
        , panelStyle
        ]


medium : Element msg
medium =
    styled div
        [ identify_ "medium"
        , panelStyle
        , width (px 462)
        , minHeight (px 414)
        ]


head : Element msg
head =
    styled div
        [ identify_ "head"
        , backgroundColor (rgba 242 244 247 1)
        , padding2 (px 10) (px 15)
        , borderBottom3 (px 1) solid (rgba 227 231 238 1)
        , borderRadius (px 3)
        , fontSize (Css.rem 1.2)
        ]


foot : Element msg
foot =
    styled div
        [ identify_ "foot"
        , padding2 (px 10) (px 15)
        , borderTop3 (px 1) solid (rgba 227 231 238 0.4)
        ]


content : Element msg
content =
    styled div
        [ identify_ "content"
        , backgroundColor (hex "FFF")
        , padding2 (px 10) (px 15)
        ]
