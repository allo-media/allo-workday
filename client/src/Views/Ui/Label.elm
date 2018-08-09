module Views.Ui.Label exposing (..)

import Css exposing (..)
import Html.Styled exposing (label, styled)
import Views.Theme exposing (Element, identify)


baseIdentifyKey : String -> String
baseIdentifyKey string =
    "Views.Ui.Label." ++ string


default : Element msg
default =
    styled label
        [ baseIdentifyKey "default" |> identify
        , color (rgb 116 107 222)
        , fontSize (Css.rem 1.125)
        , fontWeight bold
        , margin2 (px 19) zero
        , display block
        ]


medium : Element msg
medium =
    styled default
        [ baseIdentifyKey "default" |> identify ]
