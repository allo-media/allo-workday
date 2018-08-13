module Views.Ui.Label exposing (..)

import Css exposing (..)
import Html.Styled exposing (label, styled)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Button." ++ string |> identify


default : Element msg
default =
    styled label
        [ identify_ "default"
        , color (rgb 116 107 222)
        , fontSize (Css.rem 1.125)
        , fontWeight bold
        , margin2 (px 19) zero
        , display block
        ]


medium : Element msg
medium =
    styled default
        [ identify_ "default" ]
