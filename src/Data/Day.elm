module Data.Day exposing
    ( Day
    , Kind(..)
    , Slice(..)
    , calendar
    , computeOther
    , computeTotalPaidVacation
    , computeTotalRtt
    , computeTotalSickLeave
    , computeTotalWorkedDays
    , dayName
    , kindFromString
    , kindToString
    , monthName
    , offDays
    , refineMonth
    , setKind
    )

import Dict exposing (Dict)
import Time.Date as Date exposing (Date)
import Time.Iso8601 as Iso8601


type alias Day =
    { date : Date
    , week : Int
    , obs : String
    , afternoon : Kind
    , morning : Kind
    }


type Kind
    = PaidVacation
    | PublicHoliday String
    | Rtt
    | SickLeave
    | Worked
    | NotWorked
    | Other String


type Slice
    = Afternoon
    | Morning


calendar : Int -> List Day
calendar year =
    let
        firstDay =
            Date.date year 1 1

        weekOffset =
            if Date.weekday firstDay == Date.Mon then
                3

            else
                2

        yearOffdays =
            Dict.get year offDays |> Maybe.withDefault (Dict.fromList [])

        createDay d =
            let
                date =
                    firstDay |> Date.addDays d

                ( obs, morning, afternoon ) =
                    case Dict.get (Iso8601.fromDate date) yearOffdays of
                        Just offdayName ->
                            ( offdayName, PublicHoliday offdayName, PublicHoliday offdayName )

                        Nothing ->
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
        |> List.map
            (\day ->
                if Date.weekday day.date == Date.Sat then
                    { day | morning = NotWorked, afternoon = NotWorked }

                else
                    day
            )


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


kindFromString : String -> Kind
kindFromString kindString =
    case kindString of
        "Congé payé" ->
            PaidVacation

        "Jour férié" ->
            PublicHoliday ""

        "RTT" ->
            Rtt

        "Maladie" ->
            SickLeave

        "Jour travaillé" ->
            Worked

        "Non travaillé" ->
            NotWorked

        _ ->
            Other ""


kindToString : Kind -> String
kindToString kind =
    case kind of
        Other _ ->
            "Autre"

        PaidVacation ->
            "Congé payé"

        PublicHoliday _ ->
            "Jour férié"

        Rtt ->
            "RTT"

        SickLeave ->
            "Maladie"

        Worked ->
            "Jour travaillé"

        NotWorked ->
            "Non travaillé"


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

        _ ->
            -- FIXME: this is bad.
            "Décembre"


offDays : Dict Int (Dict String String)
offDays =
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
        , ( 2019
          , Dict.fromList
                [ ( timestr 2019 1 1, "Jour de l’An" )
                , ( timestr 2019 4 22, "Pâques" )
                , ( timestr 2019 5 1, "fête du Travail" )
                , ( timestr 2019 5 8, "Victoire 1945" )
                , ( timestr 2019 5 30, "Ascension" )
                , ( timestr 2019 6 10, "Pentecôte" )
                , ( timestr 2019 7 14, "Fête nationale" )
                , ( timestr 2019 8 15, "Assomption" )
                , ( timestr 2019 11 1, "Toussaint" )
                , ( timestr 2019 11 11, "Armistice 1918" )
                , ( timestr 2019 12 25, "Noël" )
                ]
          )
        , ( 2020
          , Dict.fromList
                [ ( timestr 2020 1 1, "Jour de l’An" )
                , ( timestr 2020 4 13, "Pâques" )
                , ( timestr 2020 5 1, "Fête du Travail" )
                , ( timestr 2020 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2020 5 21, "Ascension" )
                , ( timestr 2020 6 1, "Pentecôte" )
                , ( timestr 2020 7 14, "Fête nationale" )
                , ( timestr 2020 8 15, "Assomption" )
                , ( timestr 2020 11 1, "Toussaint" )
                , ( timestr 2020 11 11, "Armistice 1918" )
                , ( timestr 2020 12 25, "Noël" )
                ]
          )
        , ( 2021
          , Dict.fromList
                [ ( timestr 2021 1 1, "Jour de l’An" )
                , ( timestr 2021 4 5, "Pâques" )
                , ( timestr 2021 5 1, "Fête du Travail" )
                , ( timestr 2021 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2021 5 13, "Ascension" )
                , ( timestr 2021 5 24, "Pentecôte" )
                , ( timestr 2021 7 14, "Fête nationale" )
                , ( timestr 2021 8 15, "Assomption" )
                , ( timestr 2021 11 1, "Toussaint" )
                , ( timestr 2021 11 11, "Armistice 1918" )
                , ( timestr 2021 12 25, "Noël" )
                ]
          )
        , ( 2022
          , Dict.fromList
                [ ( timestr 2022 1 1, "Jour de l’An" )
                , ( timestr 2022 4 18, "Pâques" )
                , ( timestr 2022 5 1, "Fête du Travail" )
                , ( timestr 2022 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2022 5 26, "Ascension" )
                , ( timestr 2022 6 6, "Pentecôte" )
                , ( timestr 2022 7 14, "Fête nationale" )
                , ( timestr 2022 8 15, "Assomption" )
                , ( timestr 2022 11 1, "Toussaint" )
                , ( timestr 2022 11 11, "Armistice 1918" )
                , ( timestr 2022 12 25, "Noël" )
                ]
          )
        , ( 2023
          , Dict.fromList
                [ ( timestr 2023 1 1, "Jour de l’An" )
                , ( timestr 2023 4 10, "Pâques" )
                , ( timestr 2023 5 1, "Fête du Travail" )
                , ( timestr 2023 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2023 5 18, "Ascension" )
                , ( timestr 2023 5 29, "Pentecôte" )
                , ( timestr 2023 7 14, "Fête nationale" )
                , ( timestr 2023 8 15, "Assomption" )
                , ( timestr 2023 11 1, "Toussaint" )
                , ( timestr 2023 11 11, "Armistice 1918" )
                , ( timestr 2023 12 25, "Noël" )
                ]
          )
        , ( 2024
          , Dict.fromList
                [ ( timestr 2024 1 1, "Jour de l’An" )
                , ( timestr 2024 4 1, "Pâques" )
                , ( timestr 2024 5 1, "Fête du Travail" )
                , ( timestr 2024 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2024 5 9, "Ascension" )
                , ( timestr 2024 5 20, "Pentecôte" )
                , ( timestr 2024 7 14, "Fête nationale" )
                , ( timestr 2024 8 15, "Assomption" )
                , ( timestr 2024 11 1, "Toussaint" )
                , ( timestr 2024 11 11, "Armistice 1918" )
                , ( timestr 2024 12 25, "Noël" )
                ]
          )
        , ( 2025
          , Dict.fromList
                [ ( timestr 2025 1 1, "Jour de l’An" )
                , ( timestr 2025 4 21, "Pâques" )
                , ( timestr 2025 5 1, "Fête du Travail" )
                , ( timestr 2025 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2025 5 29, "Ascension" )
                , ( timestr 2025 6 9, "Pentecôte" )
                , ( timestr 2025 7 14, "Fête nationale" )
                , ( timestr 2025 8 15, "Assomption" )
                , ( timestr 2025 11 1, "Toussaint" )
                , ( timestr 2025 11 11, "Armistice 1918" )
                , ( timestr 2025 12 25, "Noël" )
                ]
          )
        , ( 2026
          , Dict.fromList
                [ ( timestr 2026 1 1, "Jour de l’An" )
                , ( timestr 2026 4 6, "Pâques" )
                , ( timestr 2026 5 1, "Fête du Travail" )
                , ( timestr 2026 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2026 5 14, "Ascension" )
                , ( timestr 2026 5 25, "Pentecôte" )
                , ( timestr 2026 7 14, "Fête nationale" )
                , ( timestr 2026 8 15, "Assomption" )
                , ( timestr 2026 11 1, "Toussaint" )
                , ( timestr 2026 11 11, "Armistice 1918" )
                , ( timestr 2026 12 25, "Noël" )
                ]
          )
        , ( 2027
          , Dict.fromList
                [ ( timestr 2027 1 1, "Jour de l’An" )
                , ( timestr 2027 3 29, "Pâques" )
                , ( timestr 2027 5 1, "Fête du Travail" )
                , ( timestr 2027 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2027 5 6, "Ascension" )
                , ( timestr 2027 5 17, "Pentecôte" )
                , ( timestr 2027 7 14, "Fête nationale" )
                , ( timestr 2027 8 15, "Assomption" )
                , ( timestr 2027 11 1, "Toussaint" )
                , ( timestr 2027 11 11, "Armistice 1918" )
                , ( timestr 2027 12 25, "Noël" )
                ]
          )
        , ( 2028
          , Dict.fromList
                [ ( timestr 2028 1 1, "Jour de l’An" )
                , ( timestr 2028 4 17, "Pâques" )
                , ( timestr 2028 5 1, "Fête du Travail" )
                , ( timestr 2028 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2028 5 25, "Ascension" )
                , ( timestr 2028 6 5, "Pentecôte" )
                , ( timestr 2028 7 14, "Fête nationale" )
                , ( timestr 2028 8 15, "Assomption" )
                , ( timestr 2028 11 1, "Toussaint" )
                , ( timestr 2028 11 11, "Armistice 1918" )
                , ( timestr 2028 12 25, "Noël" )
                ]
          )
        , ( 2029
          , Dict.fromList
                [ ( timestr 2029 1 1, "Jour de l’An" )
                , ( timestr 2029 4 2, "Pâques" )
                , ( timestr 2029 5 1, "Fête du Travail" )
                , ( timestr 2029 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2029 5 10, "Ascension" )
                , ( timestr 2029 5 21, "Pentecôte" )
                , ( timestr 2029 7 14, "Fête nationale" )
                , ( timestr 2029 8 15, "Assomption" )
                , ( timestr 2029 11 1, "Toussaint" )
                , ( timestr 2029 11 11, "Armistice 1918" )
                , ( timestr 2029 12 25, "Noël" )
                ]
          )
        , ( 2030
          , Dict.fromList
                [ ( timestr 2030 1 1, "Jour de l’An" )
                , ( timestr 2030 4 22, "Pâques" )
                , ( timestr 2030 5 1, "Fête du Travail" )
                , ( timestr 2030 5 8, "Victoire des Alliés en 1945" )
                , ( timestr 2030 5 30, "Ascension" )
                , ( timestr 2030 6 10, "Pentecôte" )
                , ( timestr 2030 7 14, "Fête nationale" )
                , ( timestr 2030 8 15, "Assomption" )
                , ( timestr 2030 11 1, "Toussaint" )
                , ( timestr 2030 11 11, "Armistice 1918" )
                , ( timestr 2030 12 25, "Noël" )
                ]
          )
        ]


refineMonth : Int -> List Day -> List Day
refineMonth month =
    List.filter (\{ date } -> Date.month date == month)


setKind : Slice -> Kind -> Day -> List Day -> List Day
setKind daySlice kind day =
    List.map
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
    Date.date year month day |> Iso8601.fromDate
