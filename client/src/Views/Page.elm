module Views.Page exposing (ActivePage(..), Config, frame)

-- import Html.Styled.Attributes exposing (class, css, href, src)

import Css exposing (..)
import Data.Session exposing (Session)
import Html.Styled exposing (..)
import Views.App as App
import Views.Theme exposing (Element, defaultCss)


type ActivePage
    = Home
    | Other


type alias Config =
    { session : Session
    , activePage : ActivePage
    }


frame : Config -> Html msg -> Html msg
frame config content =
    div []
        [ viewHeader config
        , div [] [ content ]
        ]
        |> App.view


title : Element msg
title =
    styled h1
        [ textAlign center
        , margin2 (Css.em 1) zero
        , color (hex "000")
        , fontSize (px 60)
        , lineHeight (px 1)
        ]


viewHeader : Config -> Html msg
viewHeader _ =
    div []
        []
