module Page.Home exposing (Model, Msg(..), init, update, view)

import Data.Day as Day exposing (Day)
import Data.Session exposing (Session)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Task
import Time exposing (Posix)
import Time.Date as Date exposing (Date)
import Time.DateTime as DateTime
import Time.Iso8601 as Iso8601


type Signature
    = Drafted String
    | Loaded String


type alias Model =
    { days : List Day
    , year : Int
    , month : Int
    , today : String
    , signature : Signature
    }


type Msg
    = DateReceived Posix
    | LoadSig
    | PickMonth Int
    | PickYear Int
    | SetKind Day.Slice Day Day.Kind


init : Session -> ( Model, Session, Cmd Msg )
init session =
    let
        year =
            2019

        month =
            1
    in
    ( { days = Day.calendar year |> Day.refineMonth month
      , year = year
      , month = month
      , today = ""
      , signature =
            if session.store.signature == "" then
                Drafted ""

            else
                Loaded session.store.signature
      }
    , session
    , Time.now |> Task.perform DateReceived
    )


update : Session -> Msg -> Model -> ( Model, Session, Cmd Msg )
update session msg ({ days } as model) =
    case msg of
        DateReceived posix ->
            let
                date =
                    posix |> DateTime.fromPosix |> DateTime.date

                year =
                    Date.year date

                month =
                    date |> Date.month
            in
            ( { model
                | year = year
                , month = month
                , days = Day.calendar year |> Day.refineMonth month
                , today =
                    [ Date.day date, month, Date.year date ]
                        |> List.map String.fromInt
                        |> String.join "/"
              }
            , session
            , Cmd.none
            )

        LoadSig ->
            ( { model
                | signature =
                    case model.signature of
                        Drafted signature ->
                            Loaded signature

                        Loaded _ ->
                            model.signature
              }
            , session
            , Cmd.none
            )

        PickMonth month ->
            ( { model | month = month, days = Day.calendar model.year |> Day.refineMonth month }
            , session
            , Cmd.none
            )

        PickYear year ->
            ( { model | year = year, month = 1, days = Day.calendar year |> Day.refineMonth 1 }
            , session
            , Cmd.none
            )

        SetKind daySlice day kind ->
            ( { model | days = days |> Day.setKind daySlice kind day }
            , session
            , Cmd.none
            )



-- Views


monthSelector : Model -> Html Msg
monthSelector { year, month } =
    div [ class "month-selector field" ]
        [ div [ class "select" ]
            [ select [ onInput (\v -> String.toInt v |> Maybe.withDefault 2019 |> PickYear) ]
                ([ 2019, 2018, 2017 ]
                    |> List.map
                        (\y ->
                            option [ selected <| y == year ]
                                [ y |> String.fromInt |> text ]
                        )
                )
            ]
        , text " "
        , div
            [ class "select" ]
            [ select [ onInput (\v -> String.toInt v |> Maybe.withDefault 1 |> PickMonth) ]
                (List.range 1 12
                    |> List.map
                        (\m ->
                            option
                                [ value <| String.fromInt m
                                , selected <| m == month
                                ]
                                [ m |> Day.monthName |> text ]
                        )
                )
            ]
        ]


kindSelector : Day.Slice -> Day -> Html Msg
kindSelector daySlice day =
    let
        sliceKind =
            case daySlice of
                Day.Afternoon ->
                    day.afternoon

                Day.Morning ->
                    day.morning
    in
    div [ class "select" ]
        [ [ Day.Worked, Day.PaidVacation, Day.PublicHoliday "", Day.Rtt, Day.SickLeave, Day.NotWorked, Day.Other "" ]
            |> List.map Day.kindToString
            |> List.map (\v -> option [ selected (v == Day.kindToString sliceKind) ] [ text v ])
            |> select [ onInput (Day.kindFromString >> SetKind daySlice day) ]
        ]


viewDay : Int -> Day -> Html Msg
viewDay index ({ date, week, obs } as day) =
    let
        dayOfWeek =
            Date.weekday date
    in
    tbody []
        [ case ( Date.day date, dayOfWeek ) of
            ( 1, _ ) ->
                text ""

            ( _, Date.Mon ) ->
                tr []
                    [ td [ colspan 5, class "has-text-centered" ]
                        [ em [] [ text <| "Semaine " ++ String.fromInt week ] ]
                    ]

            _ ->
                text ""
        , tr []
            [ td [ class "text-cell" ] [ dayOfWeek |> Day.dayName |> text ]
            , td [ class "text-cell" ] [ date |> Date.day |> String.fromInt |> text ]
            , td [] [ kindSelector Day.Morning day ]
            , td [] [ kindSelector Day.Afternoon day ]
            , td []
                [ input
                    [ class "input"
                    , type_ "text"
                    , placeholder "Observations"
                    , value obs
                    ]
                    []
                ]
            ]
        ]


statsView : List Day -> Html Msg
statsView days =
    let
        totalOther =
            Day.computeOther days

        totalPaidVacation =
            Day.computeTotalPaidVacation days

        totalRtt =
            Day.computeTotalRtt days

        totalSickLeave =
            Day.computeTotalSickLeave days

        totalWorked =
            Day.computeTotalWorkedDays days
    in
    table []
        [ thead []
            [ th [] [ text "Travaillés" ]
            , th [] [ text "RTT" ]
            , th [] [ text "Congés payés" ]
            , th [] [ text "Maladie" ]
            , th [] [ text "Autre" ]
            ]
        , tbody []
            [ td [] [ text <| String.fromFloat totalWorked ++ "j" ]
            , td [] [ text <| String.fromFloat totalRtt ++ "j" ]
            , td [] [ text <| String.fromFloat totalPaidVacation ++ "j" ]
            , td [] [ text <| String.fromFloat totalSickLeave ++ "j" ]
            , td [] [ text <| String.fromFloat totalOther ++ "j" ]
            ]
        ]


view : Session -> Model -> ( String, List (Html Msg) )
view session model =
    ( "Feuille de temps"
    , [ monthSelector model
      , h1 []
            [ text "Relevé de jours travaillés, "
            , text <| Day.monthName model.month ++ " " ++ String.fromInt model.year
            ]
      , p []
            [ strong [] [ text "Salarié : " ]
            , if session.store.name == "" then
                a [ Route.href Route.Settings ] [ text "Set your employee name" ]

              else
                strong [] [ text session.store.name ]
            ]
      , statsView model.days
      , table []
            (thead []
                [ th [] [ text "Jour" ]
                , th [] [ text "Date" ]
                , th [] [ text "Matin" ]
                , th [] [ text "Après-midi" ]
                , th [] [ text "Observation" ]
                ]
                :: (model.days |> List.indexedMap viewDay)
            )
      , p [ class "warn" ]
            [ text """Nous vous rappelons la nécessité de respecter une amplitude
                         et une charge de travail raisonnable ainsi qu'une bonne répartition
                         dans le temps du travail. Nous vous remercions de nous faire part
                         de vos éventuelles observations relatives notamment à votre charge
                         de travail.""" ]
      , p [ class "has-text-right" ]
            [ text <| "Le " ++ model.today ++ ", signature du salarié" ]
      , case model.signature of
            Drafted sigUrl ->
                a [ Route.href Route.Settings ] [ text "Define a signature" ]

            Loaded sigUrl ->
                p [ class "has-text-right" ]
                    [ img [ class "sigImg", src sigUrl ] []
                    ]
      ]
    )
