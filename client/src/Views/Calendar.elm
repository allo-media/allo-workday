module Views.Calendar exposing (view)

import Css exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (class, css)
import Views.Theme exposing (Element, identify)
import Views.Ui.Tags as Tags


identify_ : String -> Style
identify_ string =
    "Views.Calendar." ++ string |> identify


cell : Element msg
cell =
    styled td
        [ identify_ "cell"
        , width (px 220)
        , backgroundColor (hex "fbfbfb")
        , border3 (px 1) solid (hex "F1F1F1")
        , height (px 149)
        , position relative
        ]


cellDayOff : Element msg
cellDayOff =
    styled cell
        [ identify_ "cellDayOff"
        , backgroundColor (rgb 194 194 194) |> important
        , opacity (num 0.35)
        ]


cellWorkDay : Element msg
cellWorkDay =
    styled cell
        [ identify_ "cellWorkDay"
        , backgroundColor (rgb 255 255 255) |> important
        ]


dayNumber : Element msg
dayNumber =
    styled span
        [ position absolute
        , top (px 14)
        , right (px 21)
        , fontSize (Css.rem 1.5)
        , fontWeight bold
        , opacity (num 0.35)
        ]


dayNumberStrong : Element msg
dayNumberStrong =
    styled span
        [ position absolute
        , top (px 14)
        , right (px 21)
        , fontSize (Css.rem 1.5)
        , fontWeight bold
        , opacity (num 1)
        ]


headCol : Element msg
headCol =
    styled th
        [ identify_ "headCol"
        , width (px 220)
        , height (px 70)
        , backgroundColor (rgb 116 107 222)
        , border3 (px 2) solid (rgb 106 98 203)
        , color (rgb 255 255 255)
        , textTransform uppercase
        , fontWeight bold
        ]


headTable : String -> Html msg
headTable month =
    caption
        [ css
            [ backgroundColor (rgb 255 255 255)
            , height (px 70)
            , color (rgb 223 82 99)
            , fontSize (Css.rem 1.25)
            ]
        ]
        [ span
            [ css
                [ property "display" "grid"
                , property "grid-template-columns" "1fr auto 1fr"
                , property "justify-content" "center"
                , property "align-content" "center"
                , height (px 70)
                ]
            ]
            [ span [ css [ textAlign right, color (rgb 195 195 195) ] ] [ i [ class "fas fa-chevron-left" ] [] ]
            , span [ css [ textTransform uppercase, margin2 zero (px 20) ] ] [ text month ]
            , span [ css [ textAlign left, color (rgb 195 195 195) ] ] [ i [ class "fas fa-chevron-right" ] [] ]
            ]
        ]


table : Element msg
table =
    styled Html.table
        [ identify_ "table"
        , backgroundColor (rgb 255 255 255)
        , borderSpacing zero
        ]


weakNumberLabel : Element msg
weakNumberLabel =
    styled span
        [ identify_ "weakNumberLabel"
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
        ]


view : Html msg
view =
    div
        [ css
            [ identify_ "view"
            , boxShadow5 (px 9) (px 7) (px 5) zero (rgba 0 0 0 0.06)
            , margin4 zero (px 47) (px 47) (px 47)
            ]
        ]
        [ table []
            [ headTable "november"
            , tr []
                [ headCol [] [ text "Monday" ]
                , headCol [] [ text "Tuesday" ]
                , headCol [] [ text "Wednesday" ]
                , headCol [] [ text "Thursday" ]
                , headCol [] [ text "Friday" ]
                , headCol [] [ text "Saturday" ]
                , headCol [] [ text "Sunday" ]
                ]
            , tr []
                [ cell []
                    [ weakNumberLabel [] [ text "S21" ]
                    , dayNumber [] [ text "1" ]
                    ]
                , cell [] [ dayNumber [] [ text "2" ] ]
                , cell []
                    [ dayNumber [] [ text "3" ]
                    , div
                        [ css
                            [ position absolute
                            , bottom zero
                            , displayFlex
                            , width (pct 100)

                            -- , property "display" "grid"
                            -- , property "grid-auto-flow" "column"
                            -- , width (pct 100)
                            -- , property "grid-template-columns" "50%"
                            ]
                        ]
                        [ Tags.rtt [] [ text "rtt" ]
                        , Tags.worked [] [ text "worked" ]
                        ]
                    ]
                , cellWorkDay [] [ dayNumber [] [ text "4" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "5" ] ]
                , cellWorkDay []
                    [ dayNumber [] [ text "6" ]
                    , div
                        [ css
                            [ position absolute
                            , bottom zero
                            , displayFlex
                            , width (pct 100)
                            ]
                        ]
                        [ Tags.worked [] [ text "worked" ]
                        ]
                    ]
                , cellDayOff [] [ dayNumberStrong [] [ text "7" ] ]
                ]
            , tr []
                [ cellWorkDay []
                    [ weakNumberLabel [] [ text "S21" ]
                    , dayNumber [] [ text "8" ]
                    ]
                , cellWorkDay [] [ dayNumber [] [ text "9" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "10" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "11" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "12" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "13" ] ]
                , cellDayOff [] [ dayNumberStrong [] [ text "14" ] ]
                ]
            , tr []
                [ cellWorkDay []
                    [ weakNumberLabel [] [ text "S21" ]
                    , dayNumber [] [ text "1" ]
                    ]
                , cellWorkDay [] [ dayNumber [] [ text "2" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "3" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "4" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "12" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "30" ] ]
                , cellDayOff [] []
                ]
            , tr []
                [ cellWorkDay []
                    [ weakNumberLabel [] [ text "S21" ]
                    , dayNumber [] [ text "1" ]
                    ]
                , cellWorkDay [] [ dayNumber [] [ text "2" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "3" ] ]
                , cellWorkDay [] [ dayNumber [] [ text "4" ] ]
                , cell [] [ dayNumber [] [ text "12" ] ]
                , cell [] [ dayNumber [] [ text "30" ] ]
                , cellDayOff [] []
                ]
            ]
        ]
