module Views.Layout exposing (..)

import Css exposing (..)
import Data.Page exposing (Config)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Views.Header as Header
import Views.Sidebar as Sidebar
import Views.Theme exposing (Element, identify, theme)


identify_ : String -> Style
identify_ key =
    "Views.Layout." ++ key |> identify


home : Config -> Html msg -> Html msg
home config content =
    div
        [ css
            [ identify_ "home"
            , property "display" "grid"
            , property "grid-template-rows" "88px"
            ]
        ]
        [ Header.view config
        , div
            [ css
                [ paddingTop (px 60)
                , property "display" "grid"
                , property "grid-template-columns" "auto 1fr"
                ]
            ]
            [ Sidebar.view
            , content
            ]
        ]
