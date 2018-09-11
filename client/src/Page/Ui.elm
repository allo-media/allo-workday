module Page.Ui exposing (default, identify_, view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Views.Theme exposing (identify)
import Views.Ui.Button as Button
import Views.Ui.Input as Input
import Views.Ui.Textarea as Textarea


identify_ : String -> Style
identify_ string =
    "Views.UI." ++ string |> identify


default : Style
default =
    Css.batch
        [ identify_ "default"
        , padding (px 50)
        , backgroundColor (hex "fff")
        ]


view : Html msg
view =
    div [ css [ default ] ]
        [ h1 [] [ text "Styles" ]
        , div []
            [ h2 [] [ text "Inputs" ]
            , Input.default [ placeholder "Default" ] []
            , br [] []
            , Input.valid [ placeholder "Valid" ] []
            , br [] []
            , Input.invalid [ placeholder "Invalid" ] []
            , br [] []
            , Input.invalid [ Html.Styled.Attributes.disabled True, placeholder "Disabled" ] []
            , br [] []
            , Input.small [ placeholder "Small" ] []
            , br [] []
            , Input.medium [ placeholder "Medium" ] []
            , br [] []
            , Input.fullWidth [ placeholder "Full Width" ] []
            ]
        , div []
            [ h2 [] [ text "Textareas" ]
            , Textarea.default [ placeholder "Default" ] []
            , br [] []
            , Textarea.fullWidth [ placeholder "Full width" ] []
            , br [] []
            ]
        , div []
            [ h2 [] [ text "Buttons" ]
            , Button.default [] [ text "Default" ]
            , Button.primary [] [ text "Sign in" ]
            , Button.danger [] [ text "Alert ! This button delete internet !" ]
            , Button.warning [] [ text "Warning !" ]
            ]
        ]
