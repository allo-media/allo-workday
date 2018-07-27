module Page.Login exposing (Model, Msg, init, update, view)

import Css exposing (..)
import Data.Session exposing (Session)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css, type_)
import Views.Theme exposing (theme)
import Views.Ui.Button as Button
import Views.Ui.Input as Input
import Views.Ui.Label as Label
import Views.Ui.Logo as Logo
import Views.Ui.Panel as Panel
import Views.Ui.Typography as Typography


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
        [ Logo.medium [] []
        , Typography.headingLogin [] [ text "Workday" ]
        , Panel.medium []
            [ Label.medium [] [ text "Email" ]
            , Input.fullWidth [ type_ "email" ] []
            , Label.medium [] [ text "Password" ]
            , Input.fullWidth [ type_ "password" ] []
            , Button.primary [] [ text "Sign in" ]
            , Button.secondary [] [ text "Sign in" ]
            ]
        ]
