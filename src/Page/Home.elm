module Page.Home exposing (Model, Msg(..), init, update, view)

import Date as CoreDate
import Data.Session exposing (Session)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Time.Date as Date exposing (Date)


type alias Workday =
    { date : Date
    , hours : Int
    , week : Int
    , obs : String
    , enabled : Bool
    }


type alias Model =
    { days : List Workday
    , year : Int
    , month : Int
    }


type Msg
    = DateReceived CoreDate.Date
    | PickMonth Int
    | PickYear Int


init : Session -> ( Model, Cmd Msg )
init session =
    let
        year =
            2018

        month =
            1
    in
        { days = calendar year |> refineMonth month
        , year = year
        , month = month
        }
            ! [ CoreDate.now |> Task.perform DateReceived ]


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update session msg ({ days } as model) =
    case msg of
        DateReceived date ->
            let
                year =
                    CoreDate.year date

                month =
                    date |> CoreDate.month |> coreMonthToInt
            in
                { model
                    | year = year
                    , month = month
                    , days = calendar year |> refineMonth month
                }
                    ! []

        PickMonth month ->
            { model | month = month, days = calendar model.year |> refineMonth month } ! []

        PickYear year ->
            { model | year = year, month = 1, days = calendar year |> refineMonth 1 } ! []



-- Views


viewDay : Int -> Workday -> Html Msg
viewDay index { date, week, hours, obs, enabled } =
    let
        day =
            Date.weekday date
    in
        tbody []
            [ case ( Date.day date, day ) of
                ( 1, _ ) ->
                    tr []
                        [ th [ colspan 4, class "has-text-centered" ]
                            [ h3 [] [ date |> Date.month |> monthName |> text ] ]
                        ]

                ( _, Date.Mon ) ->
                    tr []
                        [ td [ colspan 4, class "has-text-centered" ]
                            [ em [] [ text <| "Semaine " ++ toString week ] ]
                        ]

                _ ->
                    text ""
            , tr []
                [ td [] [ date |> Date.weekday |> dayName |> text ]
                , td [] [ date |> Date.day |> toString |> text ]
                , td []
                    [ input
                        [ class "input"
                        , type_ "number"
                        , value <| toString hours
                        , disabled <| not enabled
                        ]
                        []
                    ]
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


selectors : Model -> Html Msg
selectors { year, month } =
    div [ class "field" ]
        [ div [ class "select" ]
            [ select [ onInput (\v -> String.toInt v |> Result.withDefault 2018 |> PickYear) ]
                ([ 2018, 2017 ]
                    |> List.map
                        (\y ->
                            option [ selected <| y == year ]
                                [ y |> toString |> text ]
                        )
                )
            ]
        , div
            [ class "select" ]
            [ select [ onInput (\v -> String.toInt v |> Result.withDefault 1 |> PickMonth) ]
                (List.range 1 12
                    |> List.map
                        (\m ->
                            option
                                [ value <| toString m
                                , selected <| m == month
                                ]
                                [ m |> monthName |> text ]
                        )
                )
            ]
        ]


view : Session -> Model -> Html Msg
view session model =
    div [ class "content" ]
        [ selectors model
        , h1 [] [ text <| monthName model.month ++ " " ++ toString model.year ]
        , div [] [ h2 [] [ text <| toString (computeTotalDays model.days) ++ " jours travaillés" ] ]
        , table []
            ((thead []
                [ th [] [ text "Jour" ]
                , th [] [ text "Date" ]
                , th [] [ text "Heures" ]
                , th [] [ text "Observation" ]
                ]
             )
                :: (model.days |> List.indexedMap viewDay)
            )
        ]



-- Utils


calendar : Int -> List Workday
calendar year =
    let
        firstDay =
            Date.date year 1 1

        weekOffset =
            if Date.weekday firstDay == Date.Mon then
                1
            else
                0

        yearOffdays =
            Dict.get year offdays |> Maybe.withDefault (Dict.fromList [])

        createWorkday d =
            let
                date =
                    firstDay |> Date.addDays d

                ( obs, enabled, hours ) =
                    case Dict.get (Date.toISO8601 date) yearOffdays of
                        Just offdayName ->
                            ( offdayName, False, 0 )

                        Nothing ->
                            ( "", True, 8 )
            in
                { date = date
                , hours = hours
                , week = (d // 7) + weekOffset
                , obs = obs
                , enabled = enabled
                }
    in
        List.range 0 364
            |> List.map createWorkday
            |> List.filter
                (\{ date } ->
                    Date.weekday date
                        /= Date.Sat
                        && Date.weekday date
                        /= Date.Sun
                )


computeTotalDays : List Workday -> Int
computeTotalDays days =
    (days |> List.map .hours |> List.sum) // 8


coreMonthToInt : CoreDate.Month -> Int
coreMonthToInt month =
    case month of
        CoreDate.Jan ->
            1

        CoreDate.Feb ->
            2

        CoreDate.Mar ->
            3

        CoreDate.Apr ->
            4

        CoreDate.May ->
            5

        CoreDate.Jun ->
            6

        CoreDate.Jul ->
            7

        CoreDate.Aug ->
            8

        CoreDate.Sep ->
            9

        CoreDate.Oct ->
            10

        CoreDate.Nov ->
            11

        CoreDate.Dec ->
            12


dayName : Date.Weekday -> String
dayName day =
    case day of
        Date.Mon ->
            "Lun"

        Date.Tue ->
            "Mar"

        Date.Wed ->
            "Mer"

        Date.Thu ->
            "Jeu"

        Date.Fri ->
            "Ven"

        Date.Sat ->
            "Sam"

        Date.Sun ->
            "Dim"


monthName : Int -> String
monthName int =
    case int of
        1 ->
            "Janvier"

        2 ->
            "Février"

        3 ->
            "Mars"

        4 ->
            "Avril"

        5 ->
            "Mai"

        6 ->
            "Juin"

        7 ->
            "Juillet"

        8 ->
            "Août"

        9 ->
            "Septembre"

        10 ->
            "Octobre"

        11 ->
            "Novembre"

        12 ->
            "Décembre"

        _ ->
            Debug.crash "unknown month"


offdays : Dict Int (Dict String String)
offdays =
    Dict.fromList
        [ ( 2017
          , Dict.fromList
                [ ( timestr 2017 1 1, "Premier de l'An 2017" )
                , ( timestr 2017 4 17, "Lundi de Pâques 2017" )
                , ( timestr 2017 5 1, "Fête du travail 2017" )
                , ( timestr 2017 5 8, "Victoire 1945 2017" )
                , ( timestr 2017 5 25, "Ascension 2017" )
                , ( timestr 2017 6 5, "Lundi de Pentecôte 2017" )
                , ( timestr 2017 7 14, "Fête Nationale 2017" )
                , ( timestr 2017 8 15, "Assomption 2017" )
                , ( timestr 2017 11 1, "Toussaint 2017" )
                , ( timestr 2017 11 11, "Armistice de 1918 2017" )
                , ( timestr 2017 12 25, "Noël 2017" )
                ]
          )
        , ( 2018
          , Dict.fromList
                [ ( timestr 2018 1 1, "Premier de l'An 2018" )
                , ( timestr 2018 4 2, "Lundi de Pâques 2018" )
                , ( timestr 2018 5 1, "Fête du travail 2018" )
                , ( timestr 2018 5 8, "Victoire 1945 2018" )
                , ( timestr 2018 5 10, "Ascension 2018" )
                , ( timestr 2018 5 21, "Lundi de Pentecôte 2018" )
                , ( timestr 2018 7 14, "Fête Nationale 2018" )
                , ( timestr 2018 8 15, "Assomption 2018" )
                , ( timestr 2018 11 1, "Toussaint 2018" )
                , ( timestr 2018 11 11, "Armistice de 1918 2018" )
                , ( timestr 2018 12 25, "Noël 2018" )
                ]
          )
        ]


refineMonth : Int -> List Workday -> List Workday
refineMonth month days =
    days
        |> List.filter (\({ date } as wd) -> Date.month date == month)


timestr : Int -> Int -> Int -> String
timestr year month day =
    Date.date year month day |> Date.toISO8601
