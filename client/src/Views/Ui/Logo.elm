module Views.Ui.Logo exposing (medium)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify)


default : Element msg
default =
    styled div
        [ backgroundImage (url "/assets/sprite.svg#logo")
        , width (px 158)
        , height (px 158)
        ]


medium : Element msg
medium =
    styled default []
