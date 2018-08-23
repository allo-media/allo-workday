module Page.Calendar exposing (..)

import Data.Session exposing (Session)
import Date exposing (Month)
import Date.Extra as DE
import Html.Styled as Html exposing (..)
import Views.Calendar.Grid as GridCalendar


type alias Model =
    { year : Int
    , month : Month
    }


type Msg
    = NoOp


init : Int -> String -> Session -> ( Model, Cmd Msg )
init year month session =
    let
        convertMonth =
            Date.fromString ("1" ++ month ++ toString year)
                |> Result.withDefault (DE.fromCalendarDate 0 Date.Jan 0)
    in
    ( { year = year, month = Date.month convertMonth }, Cmd.none )


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        NoOp ->
            model ! []


view : Session -> Model -> Html msg
view _ model =
    GridCalendar.view model.year model.month
