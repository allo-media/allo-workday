module Page.Home exposing (Model, Msg(..), init, update, view)

import Data.Session exposing (Session)
import Date exposing (Month)
import Html.Styled as Html exposing (..)
import Views.Calendar.Grid as GridCalendar


-- import Views.Calendar.Table as TableCalendar


type alias Model =
    {}


type Msg
    = NoOp


init : Session -> ( Model, Cmd Msg )
init session =
    {} ! []


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        NoOp ->
            {} ! []


view : Session -> Model -> Html msg
view _ model =
    div [] [ GridCalendar.view 2018 Date.Aug ]
