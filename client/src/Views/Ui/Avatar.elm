module Views.Ui.Avatar exposing (medium)

import Css exposing (..)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify, theme)


identify_ : String -> Style
identify_ string =
    "Value.Ui.Avatar." ++ string |> identify


medium : Element msg
medium =
    styled img
        [ identify_ "medium"
        , borderRadius (pct 50)
        , border3 (px 4) solid (rgb 255 255 255)
        , width (px 56)
        , height (px 56)
        , boxShadow5 zero (px 2) (px 4) zero (rgba 0 0 0 0.17)
        ]
