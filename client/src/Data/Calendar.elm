module Data.Calendar exposing (..)

import Date exposing (..)
import Date.Extra exposing (..)
import List.Extra as LE


dateRange : Int -> Month -> List Date
dateRange year month =
    range Day 1 (fromCalendarDate year month 1) (fromCalendarDate year month 31)


firstDateRange : Int -> Month -> Date
firstDateRange year month =
    dateRange year month
        |> List.head
        |> Maybe.withDefault (fromCalendarDate 0 Jan 0)


lastDateRange : Int -> Month -> Date
lastDateRange year month =
    dateRange year month
        |> LE.last
        |> Maybe.withDefault (fromCalendarDate 0 Jan 0)


firstDateCalendar : Int -> Month -> Date
firstDateCalendar year month =
    Date.Extra.add Day (negate (Date.Extra.weekdayNumber (firstDateRange year month) - 1)) (firstDateRange year month)


lastDateCalendar : Int -> Month -> Date
lastDateCalendar year month =
    let
        offset =
            case Date.Extra.weekdayNumber (lastDateRange year month) of
                7 ->
                    15

                _ ->
                    8
    in
    Date.Extra.add Day (offset - Date.Extra.weekdayNumber (lastDateRange year month)) (lastDateRange year month)


dates : Int -> Month -> List Date
dates year month =
    range Day 1 (firstDateCalendar year month) (lastDateCalendar year month)
