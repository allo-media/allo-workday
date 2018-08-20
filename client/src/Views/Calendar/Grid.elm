module Views.Calendar.Grid exposing (..)

import Css exposing (..)
import Date exposing (..)
import Date.Extra exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css)
import List.Extra as LE
import Views.Theme exposing (Element, identify, theme)


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
    Date.Extra.add Day (8 - Date.Extra.weekdayNumber (lastDateRange year month)) (lastDateRange year month)


dates : Int -> Month -> List Date
dates year month =
    range Day 1 (firstDateCalendar year month) (lastDateCalendar year month)



{- View element -}


grid : Element msg
grid =
    styled div
        [ property "display" "grid"
        , property "grid-template-columns" "repeat(7, 14.2%)"
        , property "grid-template-rows" "70px 70px repeat(4, 149px)"
        , justifyContent flexEnd
        , margin (px 20)
        , boxShadow5 (px 9) (px 7) (px 5) zero (rgba 0 0 0 0.06)
        ]



{- Default cell -}


cell : Element msg
cell =
    styled div
        [ height (px 149)
        , boxSizing borderBox
        , border3 (px 1) solid (hex "F1F1F1")
        ]



{- Day Number label in cell -}


dayNumber : Element msg
dayNumber =
    styled div
        [ position absolute
        , top (px 14)
        , right (px 21)
        , fontSize (Css.rem 1.5)
        , fontWeight bold
        ]



{- Day block -}


day : Month -> Date -> Html msg
day month date =
    let
        cellDay =
            case dayOfWeek date of
                Sun ->
                    if month == Date.month date then
                        backgroundColor (rgb 195 195 195)
                    else
                        backgroundColor (hex "FBFBFB")

                _ ->
                    if month == Date.month date then
                        backgroundColor (rgb 255 255 255)
                    else
                        backgroundColor (hex "FBFBFB")
    in
    cell
        [ css [ position relative, cellDay ] ]
        [ dayNumber [ css [ opacity (num 0.35) ] ] [ text (toString (Date.day date)) ]
        ]


head : Int -> Month -> Html msg
head year month =
    div
        [ css
            [ property "grid-column" "1 / 8"
            , backgroundColor (hex "FFF")
            , property "display" "grid"
            , property "grid-template-columns" "1fr auto 1fr"
            , property "justify-content" "center"
            , property "align-content" "center"
            , backgroundColor (rgb 255 255 255)
            , height (px 70)
            , color (rgb 223 82 99)
            , fontSize (Css.rem 1.25)
            ]
        ]
        [ span [ css [ textAlign right, color (rgb 195 195 195) ] ] [ i [ class "fas fa-chevron-left" ] [] ]
        , span [ css [ textTransform uppercase, margin2 zero (px 20) ] ] [ text <| toString month ++ " - " ++ toString year ]
        , span [ css [ textAlign left, color (rgb 195 195 195) ] ] [ i [ class "fas fa-chevron-right" ] [] ]
        ]


dayLabel : String -> Html msg
dayLabel dayLabel =
    div
        [ css
            [ backgroundColor (rgb 116 107 222)
            , border3 (px 1) solid (rgb 106 98 203)
            , color (rgb 255 255 255)
            , textTransform uppercase
            , fontWeight bold
            , displayFlex
            , justifyContent center
            , alignItems center
            ]
        ]
        [ text dayLabel ]


dayHeads : List (Html msg)
dayHeads =
    let
        weekDays =
            [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]
    in
    List.map dayLabel weekDays


view : Int -> Month -> Html msg
view year month =
    grid []
        ([ head year month ] ++ dayHeads ++ List.map (day month) (dates year month))
