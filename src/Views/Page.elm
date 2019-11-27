module Views.Page exposing (ActivePage(..), Config, frame)

import Browser exposing (Document)
import Css exposing (..)
import Data.Session exposing (Session)
import Html exposing (..)
import Html.Attributes exposing (..)
import Route


type ActivePage
    = Home
    | Settings
    | Other


type alias Config =
    { session : Session
    , activePage : ActivePage
    }


frame : Config -> ( String, List (Html msg) ) -> Document msg
frame config ( title, content ) =
    { title = title ++ " | Workday"
    , body =
        [ viewHeader config
        , div [ class "content" ] content
        ]
    }


viewHeader : Config -> Html msg
viewHeader { activePage } =
    let
        linkIf page route caption =
            if page == activePage then
                li [ class "is-active" ] [ a [] [ text caption ] ]

            else
                li [] [ a [ Route.href route ] [ text caption ] ]
    in
    div [ class "header" ]
        [ nav [ class "tabs is-medium app-menu" ]
            [ ul []
                [ h1 [ class "app-title" ] [ text "Workday" ]
                , linkIf Home Route.Home "Accueil"
                , linkIf Settings Route.Settings "Paramètres"
                ]
            ]
        , p [ class "instructions" ]
            [ strong [] [ text "Instructions: " ]
            , text "Sélectionnez le mois, remplissez le formulaire, lancez l'impression de la page et choisissez PDF."
            ]
        ]
