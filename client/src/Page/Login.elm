module Page.Login exposing (Model, Msg, init, update, view)

import Css exposing (..)
import Data.Session exposing (Session)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)
import Views.Theme exposing (theme)
import Views.Ui.Panel as Panel


type alias Model =
    {}


type Msg
    = NoOp


init : Session -> ( Model, Cmd Msg )
init session =
    ( {}, Cmd.none )


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update session msg model =
    ( {}, Cmd.none )


view : Session -> Model -> Html msg
view session model =
    div
        [ css
            [ theme.primaryBgImageGradient
            , width (vw 100)
            , height (vh 100)
            , property "display" "grid"
            , justifyContent center
            , property "align-content" "center"
            ]
        ]
        [ Panel.medium []
            [ text "des"
            ]
        ]
