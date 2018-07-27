module Views.Ui.Typography exposing (..)

import Css exposing (..)
import Html.Styled exposing (h1, styled)
import Views.Theme exposing (Element)


heading : Element msg
heading =
    styled h1
        [ color (hex "FFF") ]


headingLogin : Element msg
headingLogin =
    styled heading
        [ textTransform uppercase
        , textAlign center
        , fontSize (Css.rem 4)
        ]
