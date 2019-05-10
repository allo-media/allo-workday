module Page.Settings exposing (Model, Msg, init, update, view)

import Data.Session as Session exposing (Session)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)
import Ports
import Route


type alias Model =
    { name : String
    , signature : String
    }


type Msg
    = UpdateName String
    | UpdateSignature String
    | Save


init : Session -> ( Model, Session, Cmd Msg )
init ({ store } as session) =
    ( { name = store.name, signature = store.signature }
    , session
    , Cmd.none
    )


update : Session -> Msg -> Model -> ( Model, Session, Cmd Msg )
update ({ store } as session) msg model =
    case msg of
        UpdateName name ->
            ( { model | name = name }, session, Cmd.none )

        UpdateSignature signature ->
            ( { model | signature = signature }, session, Cmd.none )

        Save ->
            ( model
            , { session | store = { store | name = model.name, signature = model.signature } }
            , Route.pushUrl session.navKey Route.Home
            )


view : Session -> Model -> ( String, List (Html Msg) )
view _ { name, signature } =
    ( "Settings"
    , [ h1 [] [ text "Settings" ]
      , Html.form [ onSubmit Save ]
            [ div [ class "field" ]
                [ label [ class "label" ] [ text "Name" ]
                , div [ class "control" ]
                    [ input [ type_ "text", class "input", onInput UpdateName, value name ] []
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Signature" ]
                , div [ class "control" ]
                    [ input [ type_ "url", class "input", onInput UpdateSignature, value signature ] []
                    ]
                ]
            , div [ class "field" ] [ button [] [ text "Save" ] ]
            ]
      ]
    )
