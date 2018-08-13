module Views.Ui.Typography exposing (..)

import Css exposing (..)
import Html.Styled exposing (h1, styled)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Panel." ++ string |> identify


heading : Element msg
heading =
    styled h1
        [ identify_ "heading"
        , color (hex "FFF")
        ]


headingLogin : Element msg
headingLogin =
    styled heading
        [ identify_ "headingLogin"
        , textTransform uppercase
        , textAlign center
        , fontSize (Css.rem 4)
        ]
