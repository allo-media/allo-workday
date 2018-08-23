module Views.Calendar.Grid exposing (..)

import Css exposing (..)
import Data.Calendar exposing (dates, lastDateRange)
import Date exposing (..)
import Date.Extra exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css)
import Route exposing (Route)
import Views.Theme exposing (Element, identify, theme)


identify_ : String -> Style
identify_ string =
    "Views.Calendar.Grid."
        ++ string
        |> identify



{- View element -}


grid : Int -> Month -> Element msg
grid year month =
    let
        rows =
            case Date.Extra.weekdayNumber (lastDateRange year month) of
                7 ->
                    "70px 70px repeat(6, 149px)"

                _ ->
                    "70px 70px repeat(5, 149px)"
    in
    styled div
        [ identify_ "grid"
        , property "display" "grid"
        , property "grid-template-columns" "repeat(7, 14.2%)"
        , property "grid-template-rows" rows
        , justifyContent flexEnd
        , margin (px 20)
        , boxShadow5 (px 9) (px 7) (px 5) zero (rgba 0 0 0 0.06)
        ]



{- Default cell -}


cell : Element msg
cell =
    styled div
        [ identify_ "cell"
        , boxSizing borderBox
        , border3 (px 1) solid (hex "F1F1F1")
        ]



{- Day Number label in cell -}


dayHeads : List (Html msg)
dayHeads =
    let
        weekDays =
            [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]
    in
    List.map dayLabel weekDays


dayLabel : String -> Html msg
dayLabel dayLabel =
    div
        [ css
            [ identify_ "dayLabel"
            , backgroundColor (rgb 116 107 222)
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


dayNumber : Element msg
dayNumber =
    styled div
        [ identify_ "dayNumber"
        , position absolute
        , top (px 14)
        , right (px 21)
        , fontSize (Css.rem 1.5)
        , fontWeight bold
        ]



{- Day block -}


sunday : Style
sunday =
    Css.batch
        [ identify_ "sunday"
        , position relative
        , backgroundColor (rgb 195 195 195)
        ]


workingDay : Style
workingDay =
    Css.batch
        [ identify_ "workingDay"
        , position relative
        , backgroundColor (rgb 255 255 255)
        ]


lastMonthWorkingDay : Style
lastMonthWorkingDay =
    Css.batch
        [ identify_ "lastMonthDay"
        , position relative
        , backgroundColor (hex "FBFBFB")
        ]


day : Month -> Date -> Html msg
day month date =
    let
        cellDay =
            case dayOfWeek date of
                Sun ->
                    sunday

                _ ->
                    if month == Date.month date then
                        workingDay
                    else
                        lastMonthWorkingDay
    in
    cell
        [ css [ cellDay ] ]
        [ dayNumber [ css [ opacity (num 0.35) ] ] [ text (toString (Date.day date)) ]
        , weekNumberLabel date
        ]


weekNumberLabel : Date -> Html msg
weekNumberLabel date =
    case dayOfWeek date |> Debug.log "Day" of
        Mon ->
            span
                [ css
                    [ identify_ "weekNumberLabel"
                    , position absolute
                    , left (px (negate 31))
                    , bottom zero
                    , height (px 61)
                    , width (px 30)
                    , borderRadius4 (px 8) (px 0) (px 0) (px 8)
                    , backgroundColor (hex "FFF")
                    , fontSize (Css.rem 0.875)
                    , property "display" "grid"
                    , property "justify-content" "center"
                    , property "align-content" "center"
                    , color (rgb 195 195 195)
                    ]
                ]
                [ text ("S" ++ toString (Date.Extra.weekNumber date)) ]

        _ ->
            span [] []


nextCalendarMonth : Int -> Month -> ( Int, Month )
nextCalendarMonth year month =
    let
        newDate =
            Date.Extra.add Date.Extra.Month 1 (Date.Extra.fromCalendarDate year month 1)
    in
    ( Date.year newDate, Date.month newDate )


previousCalendarMonth : Int -> Month -> ( Int, Month )
previousCalendarMonth year month =
    let
        newDate =
            Date.Extra.add Date.Extra.Month (negate 1) (Date.Extra.fromCalendarDate year month 1)
    in
    ( Date.year newDate, Date.month newDate )


head : Int -> Month -> Html msg
head year month =
    let
        ( previousYear, previousMonth ) =
            previousCalendarMonth year month

        ( nextYear, nextMonth ) =
            nextCalendarMonth year month
    in
    div
        [ css
            [ identify_ "head"
            , property "grid-column" "1 / 8"
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
        [ a [ Route.href (Route.Calendar previousYear (toString previousMonth)), css [ textAlign right, color (rgb 195 195 195) ] ] [ i [ class "fas fa-chevron-left" ] [] ]
        , span [ css [ textTransform uppercase, margin2 zero (px 20) ] ] [ text <| toString month ++ " - " ++ toString year ]
        , a [ Route.href (Route.Calendar nextYear (toString nextMonth)), css [ textAlign left, color (rgb 195 195 195) ] ] [ i [ class "fas fa-chevron-right" ] [] ]
        ]


view : Int -> Month -> Html msg
view year month =
    List.map (day month) (dates year month)
        |> (++) dayHeads
        |> (++) [ head year month ]
        |> grid year month [ css [ identify_ "view" ] ]
