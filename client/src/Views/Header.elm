module Views.Header exposing (view)

import Css exposing (..)
import Data.Page exposing (Config)
import Html.Styled exposing (..)
import Views.Theme exposing (Element, identify, theme)


identify_ : String -> Style
identify_ key =
    "Views.Header." ++ key |> identify


default : Element msg
default =
    styled div
        [ identify_ "default"
        , theme.primaryBgImageGradient
        ]


view : Config -> Html msg
view _ =
    default [] []
