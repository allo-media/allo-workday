module Views.Page exposing (view)

import Css exposing (..)
import Data.Page exposing (ActivePage(..), Config)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Views.Layout as Layout
import Views.Theme exposing (Element, defaultCss, identify)


identify_ : String -> Style
identify_ string =
    "Views.Ui.Page."
        ++ string
        |> identify


pageBox : Html msg -> Html msg
pageBox content =
    div [ css [ identify_ "pageBox" ] ] [ defaultCss, content ]


view : Config -> Html msg -> Html msg
view config content =
    case config.activePage of
        Home ->
            Layout.home config content
                |> pageBox

        Login ->
            pageBox content

        Other ->
            pageBox content
