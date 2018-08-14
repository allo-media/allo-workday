module Views.Theme exposing (Element, defaultCss, identify, theme)

import Css exposing (..)
import Css.Foreign exposing (body, global, html, img)
import Html.Styled exposing (Attribute, Html)


type alias Theme =
    { primaryColor : Color
    , primaryBgColor : Color
    , primaryBgImageGradient : Style
    , fonts : List String
    }


type alias Element msg =
    List (Attribute msg) -> List (Html msg) -> Html msg


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
            , color theme.primaryColor
            , fontSize (px 16)
            , backgroundColor theme.primaryBgColor
            ]
        ]


identify : String -> Style
identify styleName =
    property "-style-name" styleName


theme : Theme
theme =
    { primaryColor = rgba 132 132 132 1
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
