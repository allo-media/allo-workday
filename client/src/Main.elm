module Main exposing (main)

import Data.Page exposing (ActivePage(..), Config)
import Data.Session exposing (Session)
import Html.Styled as Html exposing (..)
import Navigation exposing (Location)
import Page.Calendar as Calendar
import Page.Home as Home
import Page.Login as Login
import Page.Ui as Ui
import Route exposing (Route)
import Views.Page as Page


type alias Flags =
    {}


type Page
    = Blank
    | HomePage Home.Model
    | LoginPage Login.Model
    | CalendarPage Calendar.Model
    | NotFound
    | Ui


type alias Model =
    { page : Page
    , session : Session
    }


type Msg
    = HomeMsg Home.Msg
    | CalendarMsg Calendar.Msg
    | LoginMsg Login.Msg
    | SetRoute (Maybe Route)


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            { model | page = NotFound } ! []

        Just Route.Ui ->
            { model | page = Ui } ! []

        Just Route.Home ->
            let
                ( homeModel, homeCmds ) =
                    Home.init model.session
            in
            { model | page = HomePage homeModel }
                ! [ Cmd.map HomeMsg homeCmds ]

        Just (Route.Calendar year month) ->
            let
                ( calendarModel, calendarCmds ) =
                    Calendar.init year month model.session
            in
            { model | page = CalendarPage calendarModel } ! [ Cmd.map CalendarMsg calendarCmds ]

        Just Route.Login ->
            let
                ( loginModel, loginCmds ) =
                    Login.init model.session
            in
            { model | page = LoginPage loginModel }
                ! [ Cmd.map LoginMsg loginCmds ]


init : Flags -> Location -> ( Model, Cmd Msg )
init _ location =
    let
        -- you'll usually want to retrieve and decode serialized session
        -- information from flags here
        session =
            {}
    in
    setRoute (Route.fromLocation location)
        { page = Blank
        , session = session
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ page, session } as model) =
    let
        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
            { model | page = toModel newModel }
                ! [ Cmd.map toMsg newCmd ]
    in
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            setRoute route model

        ( CalendarMsg calendarMsg, CalendarPage calendarModel ) ->
            toPage CalendarPage CalendarMsg (Calendar.update session) calendarMsg calendarModel

        ( HomeMsg homeMsg, HomePage homeModel ) ->
            toPage HomePage HomeMsg (Home.update session) homeMsg homeModel

        ( LoginMsg loginMsg, LoginPage loginModel ) ->
            toPage LoginPage LoginMsg (Login.update session) loginMsg loginModel

        ( _, NotFound ) ->
            { model | page = NotFound } ! []

        ( _, _ ) ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        HomePage _ ->
            Sub.none

        CalendarPage _ ->
            Sub.none

        LoginPage _ ->
            Sub.none

        NotFound ->
            Sub.none

        Ui ->
            Sub.none

        Blank ->
            Sub.none


view : Model -> Html Msg
view model =
    let
        pageConfig =
            Config model.session
    in
    case model.page of
        HomePage homeModel ->
            Home.view model.session homeModel
                |> Html.map HomeMsg
                |> Page.frame (pageConfig Home)

        CalendarPage calendarModel ->
            Calendar.view model.session calendarModel
                |> Html.map CalendarMsg
                |> Page.frame (pageConfig Calendar)

        LoginPage loginModel ->
            Login.view model.session loginModel
                |> Html.map LoginMsg
                |> Page.frame (pageConfig Other)

        Ui ->
            Ui.view
                |> Page.frame (pageConfig Other)

        NotFound ->
            Html.div [] [ Html.text "Not found" ]
                |> Page.frame (pageConfig Other)

        Blank ->
            Html.text ""
                |> Page.frame (pageConfig Other)


main : Program Flags Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view >> Html.toUnstyled
        , update = update
        , subscriptions = subscriptions
        }
