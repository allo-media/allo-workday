module Views.Calendar.Grid exposing (..)

import Css exposing (..)
import Date exposing (..)
import Date.Extra exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Views.Theme exposing (Element, identify, theme)


dateRange : List Date
dateRange =
    range Day
        1
        (fromCalendarDate 2018 Feb 1)
        (fromCalendarDate 2018 Feb 31)


grid : Element msg
grid =
    styled div
        [ property "display" "grid"
        , property "grid-template-columns" "repeat(7, 220px)"
        , property "grid-template-rows" "70px 70px repeat(4, 149px)"
        , boxShadow5 (px 9) (px 7) (px 5) zero (rgba 0 0 0 0.06)
        ]


cell : Element msg
cell =
    styled div
        [ width (px 220)
        , height (px 149)
        , boxSizing borderBox
        , border3 (px 1) solid (hex "F1F1F1")
        , property "grid-columns-start" "3"
        ]


dayNumber : Element msg
dayNumber =
    styled div
        [ position absolute
        , top (px 14)
        , right (px 21)
        , fontSize (Css.rem 1.5)
        , fontWeight bold
        ]


day : Date -> Html msg
day date =
    let
        day =
            [ backgroundColor (rgb 255 255 255), position relative ]

        dayOff =
            [ backgroundColor (rgb 195 195 195), position relative ]

        dayLastMonth =
            [ backgroundColor (hex "fbfbfb"), position relative ]

        cellDay =
            case dayOfWeek date of
                Sun ->
                    [ backgroundColor (rgb 195 195 195), position relative ]

                _ ->
                    [ backgroundColor (rgb 255 255 255), position relative ]
    in
    cell
        [ css cellDay ]
        [ dayNumber
            [ css [ opacity (num 0.35) ]
            ]
            [ text (toString (Date.day date))
            , text "-"
            , text (toString (dayOfWeek date))
            ]
        ]


head : Html msg
head =
    div
        [ css
            [ property "grid-column" "1 / 8"
            , backgroundColor (hex "FFF")
            ]
        ]
        []


colHead : String -> Html msg
colHead dayLabel =
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


colHeads : List (Html msg)
colHeads =
    let
        weekDays =
            [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]
    in
    List.map colHead weekDays


view : Html msg
view =
    let
        first =
            List.head dateRange

        days =
            List.map day dateRange

        _ =
            Debug.log "range" dateRange
    in
    grid []
        ([ head ] ++ colHeads ++ days)
