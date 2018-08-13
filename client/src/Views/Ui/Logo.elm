module Views.Ui.Logo exposing (medium, small)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, src)
import Views.Theme exposing (Element, identify)


logoPath : String
logoPath =
    "assets/logoWorkday.svg"


identify_ : String -> Style
identify_ string =
    "Views.UI.Logo." ++ string |> identify


default : Element msg
default =
    styled img [ identify_ "default" ]


medium : Html msg
medium =
    default
        [ css
            [ identify_ "medium"
            , width (px 158)
            , height (px 158)
            , property "justify-self" "center"
            ]
        , src logoPath
        ]
        []


small : Html msg
small =
    default
        [ css
            [ identify_ "small"
            , width (px 60)
            , height (px 60)
            , property "justify-self" "center"
            ]
        , src logoPath
        ]
        []
