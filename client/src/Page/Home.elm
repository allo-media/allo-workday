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
    , afternoon : Kind
    , morning : Kind
    }


type DaySlice
    = Afternoon
    | Morning


type Kind
    = PaidVacation
    | PublicHoliday String
    | Rtt
    | SickLeave
    | Worked
    | Other String


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
    = DateReceived CoreDate.Date
    | LoadSig
    | PickMonth Int
    | PickYear Int
    | ResetSig
    | SetKind DaySlice Day String
    | UpdateSig String


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
        , today = ""
        , signature = Drafted ""
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
                    , today =
                        [ CoreDate.day date, month, CoreDate.year date ]
                            |> List.map toString
                            |> String.join "/"
                }
                    ! []

        LoadSig ->
            { model
                | signature =
                    case model.signature of
                        Drafted signature ->
                            Loaded signature

                        Loaded _ ->
                            model.signature
            }
                ! []

        PickMonth month ->
            { model | month = month, days = calendar model.year |> refineMonth month } ! []

        PickYear year ->
            { model | year = year, month = 1, days = calendar year |> refineMonth 1 } ! []

        ResetSig ->
            { model | signature = Drafted "" } ! []

        SetKind daySlice day kindString ->
            { model | days = days |> setKind daySlice kindString day } ! []

        UpdateSig sigUrl ->
            { model | signature = Drafted sigUrl } ! []



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


kindSelector : DaySlice -> Day -> Html Msg
kindSelector daySlice day =
    let
        sliceKind =
            case daySlice of
                Afternoon ->
                    day.afternoon

                Morning ->
                    day.morning
    in
        div [ class "select" ]
            [ select
                [ disabled <| kindToString sliceKind == "jf"
                , onInput (SetKind daySlice day)
                ]
                [ option
                    [ value "cp"
                    , selected <| kindToString sliceKind == "cp"
                    ]
                    [ text "Congé payé" ]
                , case sliceKind of
                    PublicHoliday _ ->
                        option
                            [ value "jf"
                            , selected <| kindToString sliceKind == "jf"
                            ]
                            [ text "Jour férié" ]

                    _ ->
                        text ""
                , option
                    [ value "jt"
                    , selected <| kindToString sliceKind == "jt"
                    ]
                    [ text "Jour travaillé" ]
                , option
                    [ value "ml"
                    , selected <| kindToString sliceKind == "ml"
                    ]
                    [ text "Maladie" ]
                , option
                    [ value "rtt"
                    , selected <| kindToString sliceKind == "rtt"
                    ]
                    [ text "RTT" ]
                , option
                    [ value "ot"
                    , selected <| kindToString sliceKind == "ot"
                    ]
                    [ text "Autre" ]
                ]
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
                            [ em [] [ text <| "Semaine " ++ toString week ] ]
                        ]

                _ ->
                    text ""
            , tr []
                [ td [ class "text-cell" ] [ dayOfWeek |> dayName |> text ]
                , td [ class "text-cell" ] [ date |> Date.day |> toString |> text ]
                , td [] [ kindSelector Morning day ]
                , td [] [ kindSelector Afternoon day ]
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
            computeOther days

        totalPaidVacation =
            computeTotalPaidVacation days

        totalRtt =
            computeTotalRtt days

        totalSickLeave =
            computeTotalSickLeave days

        totalWorked =
            computeTotalWorkedDays days
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
                [ td [] [ text <| toString totalWorked ++ "j" ]
                , td [] [ text <| toString totalRtt ++ "j" ]
                , td [] [ text <| toString totalPaidVacation ++ "j" ]
                , td [] [ text <| toString totalSickLeave ++ "j" ]
                , td [] [ text <| toString totalOther ++ "j" ]
                ]
            ]


sigForm : String -> Html Msg
sigForm sigUrl =
    Html.form
        [ class "field is-horizontal sig-field"
        , onSubmit LoadSig
        ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label" ] [ text "Signature URL" ] ]
        , div [ class "field-body" ]
            [ div [ class "field has-addons" ]
                [ div [ class "control" ]
                    [ input
                        [ type_ "text"
                        , class "input sig"
                        , placeholder "http://"
                        , onInput UpdateSig
                        , required True
                        ]
                        []
                    ]
                , div [ class "control" ]
                    [ button [ type_ "submit", class "button" ] [ text "Load" ]
                    ]
                ]
            ]
        ]


view : Session -> Model -> Html Msg
view session model =
    div [ class "content" ]
        [ monthSelector model
        , h1 []
            [ text "Relevé de jours travaillés, "
            , text <| monthName model.month ++ " " ++ toString model.year
            ]
        , div [ class "field is-horizontal name-field" ]
            [ div [ class "field-label is-normal" ]
                [ label [ class "label" ] [ text "Salarié" ] ]
            , div [ class "field-body" ]
                [ div [ class "field" ]
                    [ p [ class "control is-expanded" ]
                        [ input [ type_ "text", class "input name", placeholder "Jean Dupuis" ] [] ]
                    ]
                ]
            ]
        , statsView model.days
        , table []
            ((thead []
                [ th [] [ text "Jour" ]
                , th [] [ text "Date" ]
                , th [] [ text "Matin" ]
                , th [] [ text "Après-midi" ]
                , th [] [ text "Observation" ]
                ]
             )
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
                sigForm sigUrl

            Loaded sigUrl ->
                p [ class "has-text-right" ]
                    [ img [ class "sigImg", src sigUrl ] []
                    , br [] []
                    , button [ class "button", onClick ResetSig ] [ text "reset" ]
                    ]
        ]



-- Utils


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

                ( obs, morning, afternoon ) =
                    case Dict.get (Date.toISO8601 date) yearOffdays of
                        Just offdayName ->
                            ( offdayName, PublicHoliday offdayName, PublicHoliday offdayName )

                        Nothing ->
                            case Date.weekday date of
                                Date.Sat ->
                                    ( "Repos", Other "", Other "" )

                                _ ->
                                    ( "", Worked, Worked )
            in
                { date = date
                , week = (d // 7) + weekOffset
                , obs = obs
                , morning = morning
                , afternoon = afternoon
                }
    in
        List.range 0 364
            |> List.map createDay
            |> List.filter (\{ date } -> Date.weekday date /= Date.Sun)


computeTotalPaidVacation : List Day -> Float
computeTotalPaidVacation days =
    (days
        |> List.map
            (\{ morning, afternoon } ->
                case ( morning, afternoon ) of
                    ( PaidVacation, PaidVacation ) ->
                        2

                    ( _, PaidVacation ) ->
                        1

                    ( PaidVacation, _ ) ->
                        1

                    _ ->
                        0
            )
        |> List.sum
    )
        / 2


computeOther : List Day -> Float
computeOther days =
    (days
        |> List.map
            (\{ morning, afternoon } ->
                case ( morning, afternoon ) of
                    ( Other _, Other _ ) ->
                        2

                    ( _, Other _ ) ->
                        1

                    ( Other _, _ ) ->
                        1

                    _ ->
                        0
            )
        |> List.sum
    )
        / 2


computeTotalRtt : List Day -> Float
computeTotalRtt days =
    (days
        |> List.map
            (\{ morning, afternoon } ->
                case ( morning, afternoon ) of
                    ( Rtt, Rtt ) ->
                        2

                    ( _, Rtt ) ->
                        1

                    ( Rtt, _ ) ->
                        1

                    _ ->
                        0
            )
        |> List.sum
    )
        / 2


computeTotalSickLeave : List Day -> Float
computeTotalSickLeave days =
    (days
        |> List.map
            (\{ morning, afternoon } ->
                case ( morning, afternoon ) of
                    ( SickLeave, SickLeave ) ->
                        2

                    ( _, SickLeave ) ->
                        1

                    ( SickLeave, _ ) ->
                        1

                    _ ->
                        0
            )
        |> List.sum
    )
        / 2


computeTotalWorkedDays : List Day -> Float
computeTotalWorkedDays days =
    (days
        |> List.map
            (\{ morning, afternoon } ->
                case ( morning, afternoon ) of
                    ( Worked, Worked ) ->
                        2

                    ( _, Worked ) ->
                        1

                    ( Worked, _ ) ->
                        1

                    _ ->
                        0
            )
        |> List.sum
        |> toFloat
    )
        / 2


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


kindToString : Kind -> String
kindToString kind =
    case kind of
        Other _ ->
            "ot"

        PaidVacation ->
            "cp"

        PublicHoliday _ ->
            "jf"

        Rtt ->
            "rtt"

        SickLeave ->
            "ml"

        Worked ->
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


setKind : DaySlice -> String -> Day -> List Day -> List Day
setKind daySlice kindString day days =
    let
        kind =
            case kindString of
                "ot" ->
                    Other ""

                "cp" ->
                    PaidVacation

                "jf" ->
                    PublicHoliday ""

                "rtt" ->
                    Rtt

                "ml" ->
                    SickLeave

                "jt" ->
                    Worked

                _ ->
                    Debug.crash <| "unsupported kind " ++ kindString
    in
        days
            |> List.map
                (\d ->
                    if d == day then
                        case daySlice of
                            Afternoon ->
                                { d | afternoon = kind }

                            Morning ->
                                { d | morning = kind }
                    else
                        d
                )


timestr : Int -> Int -> Int -> String
timestr year month day =
    Date.date year month day |> Date.toISO8601
