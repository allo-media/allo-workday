module Route exposing (Route(..), fromLocation, href, modifyUrl)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, s)


type Route
    = Home
    | Login
    | Calendar Int String



-- | Calendar


route : Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map Login (s "login")
        , Url.map Calendar (s "calendar" </> Url.int </> Url.string)
        ]


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        Url.parseHash route location


routeToString : Route -> String
routeToString route =
    let
        pieces =
            case route of
                Home ->
                    []

                Login ->
                    [ "login" ]

                Calendar year month ->
                    [ "calendar", toString year, month ]
    in
    "#/" ++ String.join "/" pieces


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl
