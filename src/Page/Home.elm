module Page.Home exposing (Model, Msg(..), init, update, view)

import Date as CoreDate
import Data.Session exposing (Session)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Time.Date as Date exposing (Date)


type alias Day =
    { date : Date
    , week : Int
    , obs : String
    , kind : DayKind
    }


type DayKind
    = PaidVacation
    | PublicHoliday String
    | Rtt
    | SickLeave
    | Workday Int


type alias Model =
    { days : List Day
    , year : Int
    , month : Int
    }


type Msg
    = DateReceived CoreDate.Date
    | HourDec Day
    | HourInc Day
    | PickMonth Int
    | PickYear Int
    | SetKind Day String


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

        HourDec day ->
            { model | days = days |> addWordayHours -1 day } ! []

        HourInc day ->
            { model | days = days |> addWordayHours 1 day } ! []

        PickMonth month ->
            { model | month = month, days = calendar model.year |> refineMonth month } ! []

        PickYear year ->
            { model | year = year, month = 1, days = calendar year |> refineMonth 1 } ! []

        SetKind day kindString ->
            { model | days = days |> setDayKind kindString day } ! []



-- Views


monthSelector : Model -> Html Msg
monthSelector { year, month } =
    div [ class "month-selector field" ]
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


kindSelector : Day -> Html Msg
kindSelector ({ kind } as day) =
    div [ class "select" ]
        [ select
            [ disabled <| kindToString kind == "jf"
            , onInput (SetKind day)
            ]
            [ option
                [ value "cp"
                , selected <| kindToString kind == "cp"
                ]
                [ text "Congé payé" ]
            , case kind of
                PublicHoliday _ ->
                    option
                        [ value "jf"
                        , selected <| kindToString kind == "jf"
                        ]
                        [ text "Jour férié" ]

                _ ->
                    text ""
            , option
                [ value "jt"
                , selected <| kindToString kind == "jt"
                ]
                [ text "Jour travaillé" ]
            , option
                [ value "ml"
                , selected <| kindToString kind == "ml"
                ]
                [ text "Maladie" ]
            , option
                [ value "rtt"
                , selected <| kindToString kind == "rtt"
                ]
                [ text "RTT" ]
            ]
        ]


viewDay : Int -> Day -> Html Msg
viewDay index ({ date, week, obs, kind } as day) =
    let
        dayOfWeek =
            Date.weekday date
    in
        tbody []
            [ case ( Date.day date, dayOfWeek ) of
                ( 1, _ ) ->
                    tr []
                        [ th [ colspan 5, class "has-text-centered" ]
                            [ h3 [] [ date |> Date.month |> monthName |> text ] ]
                        ]

                ( _, Date.Mon ) ->
                    tr []
                        [ td [ colspan 5, class "has-text-centered" ]
                            [ em [] [ text <| "Semaine " ++ toString week ] ]
                        ]

                _ ->
                    text ""
            , tr []
                [ td [ class "text-cell" ] [ dayOfWeek |> dayName |> text ]
                , td [ class "text-cell" ] [ date |> Date.day |> toString |> text ]
                , td [] [ kindSelector day ]
                , case kind of
                    Workday hours ->
                        td []
                            [ div [ class "field has-addons" ]
                                [ div [ class "control" ]
                                    [ input
                                        [ class "input has-text-centered"
                                        , style [ ( "width", "50px" ) ]
                                        , type_ "number"
                                        , value <| toString hours
                                        , readonly True
                                        ]
                                        []
                                    ]
                                , div [ class "control" ]
                                    [ button [ class "button", onClick (HourDec day) ] [ text "-" ]
                                    ]
                                , div [ class "control" ]
                                    [ button [ class "button", onClick (HourInc day) ] [ text "+" ]
                                    ]
                                ]
                            ]

                    _ ->
                        td [ class "text-cell" ] [ div [ class "zero-value" ] [ text "0" ] ]
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
        totalWorked =
            computeTotalDays days
    in
        div []
            [ h3 [] [ text <| toString totalWorked ++ " jours travaillés" ]
            ]


view : Session -> Model -> Html Msg
view session model =
    div [ class "content" ]
        [ monthSelector model
        , h1 [] [ text <| monthName model.month ++ " " ++ toString model.year ]
        , statsView model.days
        , table []
            ((thead []
                [ th [] [ text "Jour" ]
                , th [] [ text "Date" ]
                , th [] [ text "Type" ]
                , th [] [ text "Heures" ]
                , th [] [ text "Observation" ]
                ]
             )
                :: (model.days |> List.indexedMap viewDay)
            )
        ]



-- Utils


addWordayHours : Int -> Day -> List Day -> List Day
addWordayHours toAdd day days =
    case day.kind of
        Workday hours ->
            let
                testHours =
                    hours + toAdd

                newHours =
                    if testHours < 0 then
                        0
                    else if testHours > 8 then
                        8
                    else
                        testHours
            in
                days
                    |> List.map
                        (\d ->
                            if d == day then
                                { d | kind = Workday newHours }
                            else
                                d
                        )

        _ ->
            days


calendar : Int -> List Day
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

        createDay d =
            let
                date =
                    firstDay |> Date.addDays d

                ( obs, kind ) =
                    case Dict.get (Date.toISO8601 date) yearOffdays of
                        Just offdayName ->
                            ( offdayName, PublicHoliday offdayName )

                        Nothing ->
                            ( "", Workday 8 )
            in
                { date = date
                , week = (d // 7) + weekOffset
                , obs = obs
                , kind = kind
                }
    in
        List.range 0 364
            |> List.map createDay
            |> List.filter
                (\{ date } ->
                    Date.weekday date
                        /= Date.Sat
                        && Date.weekday date
                        /= Date.Sun
                )


computeTotalDays : List Day -> Float
computeTotalDays days =
    (days
        |> List.map
            (\{ kind } ->
                case kind of
                    Workday hours ->
                        hours

                    _ ->
                        0
            )
        |> List.sum
        |> toFloat
    )
        / 8


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


kindToString : DayKind -> String
kindToString kind =
    case kind of
        PaidVacation ->
            "cp"

        PublicHoliday _ ->
            "jf"

        Rtt ->
            "rtt"

        SickLeave ->
            "ml"

        Workday _ ->
            "jt"


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


refineMonth : Int -> List Day -> List Day
refineMonth month days =
    days
        |> List.filter (\({ date } as wd) -> Date.month date == month)


setDayKind : String -> Day -> List Day -> List Day
setDayKind kindString day days =
    days
        |> List.map
            (\d ->
                if d == day then
                    { d
                        | kind =
                            case kindString of
                                "cp" ->
                                    PaidVacation

                                "jf" ->
                                    PublicHoliday ""

                                "rtt" ->
                                    Rtt

                                "ml" ->
                                    SickLeave

                                "jt" ->
                                    Workday 8

                                _ ->
                                    Debug.crash <| "unsupported kind " ++ kindString
                    }
                else
                    d
            )


timestr : Int -> Int -> Int -> String
timestr year month day =
    Date.date year month day |> Date.toISO8601
