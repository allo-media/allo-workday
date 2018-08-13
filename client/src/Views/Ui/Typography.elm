module Views.Ui.Typography exposing (..)

import Css exposing (..)
import Html.Styled exposing (h1, p, styled)
import Views.Theme exposing (Element, identify)


identify_ : String -> Style
identify_ string =
    "Views.UI.Typograhy." ++ string |> identify


heading : Element msg
heading =
    styled h1
        [ identify_ "heading"
        , textTransform uppercase
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


primaryHeaderText : Element msg
primaryHeaderText =
    styled p
        [ fontSize (Css.rem 1.5)
        , color (rgb 255 255 255)
        ]
