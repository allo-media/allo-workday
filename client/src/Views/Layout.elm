module Views.Layout exposing (..)

import Css exposing (..)
import Data.Page exposing (Config)
import Html.Styled exposing (..)
import Views.Header as Header
import Views.Theme exposing (Element, identify, theme)


identify_ : String -> Style
identify_ key =
    "Views.Layout." ++ key |> identify


appDefault : Element msg
appDefault =
    styled div
        [ identify_ "app"
        , property "display" "grid"
        , property "grid-template-rows" "8.3333333vh"
        ]


app : Config -> Html msg -> Html msg
app config content =
    appDefault [] [ Header.view config, content ]
