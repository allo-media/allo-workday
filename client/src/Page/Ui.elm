module Page.Ui exposing (..)

import Html.Styled exposing (..)
import Views.Ui.Input as Input


view : Html msg
view =
    div []
        [ Input.small [] []
        , Input.medium [] []
        , Input.fullWidth [] []
        ]
