module Views.Ui.Typography exposing (..)

import Css exposing (..)
import Html.Styled exposing (h1, styled)
import Views.Theme exposing (Element, identify)


baseIdentifyKey : String -> String
baseIdentifyKey string =
    "Views.Ui.Typography." ++ string


heading : Element msg
heading =
    styled h1
        [ identify <| baseIdentifyKey "heading"
        , color (hex "FFF")
        ]


headingLogin : Element msg
headingLogin =
    styled heading
        [ identify <| baseIdentifyKey "headingLogin"
        , textTransform uppercase
        , textAlign center
        , fontSize (Css.rem 4)
        ]
