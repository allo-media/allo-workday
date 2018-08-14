module Page.Login exposing (Model, Msg, init, update, view)

import Css exposing (..)
import Data.Session exposing (Session)
import Html.Styled exposing (Html, div, h1, text)
import Html.Styled.Attributes exposing (css, placeholder, src, type_)
import Views.Theme exposing (theme)
import Views.Ui.Button as Button
import Views.Ui.Input as Input
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
        [ Logo.medium
        , Typography.headingLogin [] [ text "Workday" ]
        , Panel.medium [ css [ padding2 (px 10) (px 40) ] ]
            [ h1
                [ css
                    [ textTransform uppercase
                    , color theme.primaryColor
                    , fontSize (Css.rem 1.25)
                    , textAlign center
                    , margin2 (px 40) zero
                    ]
                ]
                [ text "Sign in to your account" ]
            , Input.fullWidth [ type_ "email", placeholder "email" ] []
            , Input.fullWidth [ type_ "password", placeholder "password" ] []
            , Button.primaryFullWidth [] [ text "Sign in" ]
            ]
        ]
