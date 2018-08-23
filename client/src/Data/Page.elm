module Data.Page exposing (ActivePage(..), Config)

import Data.Session exposing (Session)


type ActivePage
    = Home
    | Login
    | Calendar
    | Other


type alias Config =
    { session : Session
    , activePage : ActivePage
    }
