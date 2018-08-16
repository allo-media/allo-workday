module Views.Ui.Tags exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify, theme)


default : Element msg
default =
    styled span
        [ height (px 29)
        , width (pct 100)
        , color (rgba 255 255 255 0.5)
        , lineHeight (px 29)
        , paddingLeft (px 5)
        , border3 (px 1) solid (rgb 241 241 241)
        , textTransform uppercase
        ]


rtt : Element msg
rtt =
    styled default
        [ backgroundColor (rgb 248 177 62)
        ]


worked : Element msg
worked =
    styled default
        [ backgroundColor (rgb 223 82 99)
        ]
