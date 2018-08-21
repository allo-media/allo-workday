module Views.Page exposing (frame)

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


wrap : Html msg -> Html msg
wrap content =
    div [ css [ identify_ "wrap" ] ] [ defaultCss, content ]


frame : Config -> Html msg -> Html msg
frame config content =
    case config.activePage of
        Home ->
            Layout.home config content
                |> wrap

        Calendar ->
            Layout.home config content
                |> wrap

        Login ->
            wrap content

        Other ->
            wrap content
