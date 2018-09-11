module Page.Ui exposing (default, identify_, view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Views.Theme exposing (identify)
import Views.Ui.Button as Button
import Views.Ui.Input as Input


identify_ : String -> Style
identify_ string =
    "Views.UI." ++ string |> identify


default : Style
default =
    Css.batch
        [ identify_ "default"
        , padding (px 50)
        ]


view : Html msg
view =
    div [ css [ default ] ]
        [ Input.small [ placeholder "Small" ] []
        , Input.medium [ placeholder "Medium" ] []
        , Input.fullWidth [ placeholder "Full Width" ] []
        , Input.valid [ placeholder "Valid" ] []
        , Input.invalid [ placeholder "Invalid" ] []
        , Button.primary [] [ text "Sign in" ]
        ]
