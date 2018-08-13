module Views.Header exposing (view)

import Css exposing (..)
import Data.Page exposing (Config)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css, src)
import Route as Route
import Views.Theme exposing (Element, identify, theme)
import Views.Ui.Avatar as Avatar
import Views.Ui.Logo as Logo
import Views.Ui.Typography as Typography


identify_ : String -> Style
identify_ key =
    "Views.Header." ++ key |> identify


default : Element msg
default =
    styled div
        [ identify_ "default"
        , backgroundImage
            (linearGradient2 (deg 273)
                (stop (rgb 116 107 222))
                (stop (rgb 56 28 226))
                []
            )
        , property "display" "grid"
        , property "grid-template-columns" "auto 1fr auto"
        ]


logout : Element msg
logout =
    styled a
        [ identify_ "logout"
        , position relative
        , margin4 zero zero zero (px 7)
        , textDecoration none
        , before
            [ property "content" "\"\\f52b\""
            , textAlign center
            , height (px 24)
            , fontFamilies [ "\"Font Awesome 5 Free\"" ]
            , fontWeight (int 900)
            , fontSize (px 24)
            , margin4 zero zero (px 3) zero
            , display block
            , cursor pointer
            ]
        , color (rgba 255 255 255 0.3)
        , hover [ color (rgba 255 255 255 1) ]
        ]


view : Config -> Html msg
view _ =
    default []
        [ span
            [ css
                [ displayFlex
                , alignItems center
                , marginLeft (px 31)
                ]
            ]
            [ Logo.small
            , Typography.heading [ css [ marginLeft (px 11) ] ] [ text "Workday" ]
            ]
        , span [] []
        , span
            [ css
                [ displayFlex
                , alignItems center
                , marginRight (px 10)
                ]
            ]
            [ Typography.primaryHeaderText [ css [ marginRight (px 17) ] ] [ text "Mickael Scott" ]
            , Avatar.medium [ src "https://randomuser.me/api/portraits/men/46.jpg" ] []
            , logout [ Route.href Route.Login ] [ text "Logout" ]
            ]
        ]
