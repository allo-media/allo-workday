module Views.Theme exposing (Element, defaultCss, defaultFont, identify, theme)

import Css exposing (..)
import Css.Foreign exposing (body, everything, global, html, img)
import Html.Styled exposing (Attribute, Html)


type alias Theme =
    { primaryColor : Color
    , primaryBgColor : Color
    , primaryBgImageGradient : Style
    , fonts : List String
    }


type alias Element msg =
    List (Attribute msg) -> List (Html msg) -> Html msg


defaultFont : Style
defaultFont =
    Css.batch
        [ identify "Views.Theme.defaultFont"
        , color (hex "354052")
        , fontFamilies theme.fonts
        , fontWeight (int 600)
        , letterSpacing (px 0.3)
        ]


defaultCss : Html msg
defaultCss =
    global
        [ html
            [ identify "Views.Theme.defaultCss"
            , width (pct 100)
            , height (pct 100)
            ]
        , body
            [ identify "Views.Theme.defaultCss"
            , margin2 auto auto
            , width (pct 100)
            , height (pct 100)
            , fontFamilies theme.fonts
            , backgroundColor theme.primaryBgColor
            ]
        , everything
            [ boxSizing borderBox
            , defaultFont
            ]
        ]


identify : String -> Style
identify styleName =
    property "-style-name" styleName


theme : Theme
theme =
    { primaryColor = rgb 130 97 230
    , primaryBgColor = rgba 236 241 247 1
    , primaryBgImageGradient =
        backgroundImage
            (linearGradient2 (deg 131)
                (stop2 (hex "746BDE") (pct 23))
                (stop2 (hex "381CE2") (pct 100))
                []
            )
    , fonts = [ "Montserrat", .value sansSerif ]
    }
