module Views.Ui.Button exposing (danger, default, primary, primaryFullWidth, secondary, warning)

import Css as Css exposing (..)
import Css.Transitions exposing (easeInOut, transition)
import Html.Styled exposing (button, styled)
import Views.Theme as VT exposing (Element, darken, identify, theme)


identify_ : String -> Style
identify_ string =
    "Views.UI.Button." ++ string |> identify


styleDefault : Style
styleDefault =
    Css.batch
        [ identify_ "styleDefault"
        , textAlign center
        , color (hex "FFF")
        , border zero
        , padding2 (px 12) (px 18)
        , fontWeight (int 700)
        , borderRadius (px 3)
        , cursor pointer
        , outline none
        , transition
            [ Css.Transitions.background3 100 0 easeInOut
            ]
        ]


default : Element msg
default =
    styled button
        [ styleDefault
        , identify_ "default"
        , background (rgba 242 244 247 1) 0.1
        , color (VT.darken 0.6 (rgba 242 244 247 1))
        ]


background : Color -> Float -> Style
background color ratio =
    Css.batch
        [ backgroundImage <|
            linearGradient
                (stop <| color)
                (stop <| VT.darken ratio color)
                []
        , hover
            [ backgroundImage <|
                linearGradient
                    (stop <| VT.darken (ratio / 2) color)
                    (stop <| VT.darken (ratio * 1.1) color)
                    []
            ]
        , active
            [ backgroundImage <|
                linearGradient
                    (stop <| VT.darken (ratio / 2) color)
                    (stop <| VT.darken (ratio * 1.5) color)
                    []
            ]
        ]


danger : Element msg
danger =
    styled button
        [ styleDefault
        , identify_ "danger"
        , background theme.dangerColor 0.1
        ]


primary : Element msg
primary =
    styled button
        [ styleDefault
        , identify_ "primary"
        , background theme.primaryColor 0.1
        ]


primaryFullWidth : Element msg
primaryFullWidth =
    styled primary
        [ identify_ "primaryFullWidth"
        , width (pct 100)
        ]


secondary : Element msg
secondary =
    styled button
        [ identify_ "secondary" ]


warning : Element msg
warning =
    styled button
        [ styleDefault
        , identify_ "warning"
        , background theme.warningColor 0.05
        ]
