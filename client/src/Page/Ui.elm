module Page.Ui exposing (default, identify_, view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Views.Theme exposing (identify)
import Views.Ui.Button as Button
import Views.Ui.Input as Input
import Views.Ui.Panel as Panel
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
        , div []
            [ h2 [] [ text "Panel" ]
            , Panel.default []
                [ Panel.head [] [ text "Donec consequat diam" ]
                , Panel.content [] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at tortor nec leo vestibulum varius. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras elementum odio eu lectus iaculis pretium. Nulla vel velit venenatis, hendrerit nisl sit amet, placerat erat. Duis consectetur ante felis, ac auctor diam maximus vel. Phasellus scelerisque justo arcu, et dignissim ex laoreet non. Aenean sit amet sem sit amet eros aliquam placerat. Maecenas id viverra risus. Mauris tempor dui non commodo ornare. Mauris congue dignissim dolor quis auctor. Quisque eu erat orci. Mauris quis pretium justo, vitae gravida diam.\n\nDonec consequat diam mattis pellentesque tempus. Maecenas et interdum nisl, sit amet molestie felis. Donec euismod rhoncus enim, vel facilisis enim finibus vel. Sed sit amet diam leo. Fusce tincidunt eros quis imperdiet feugiat. Aliquam facilisis tellus fermentum tellus malesuada, ac sagittis metus volutpat. Cras eget interdum lorem. Praesent dignissim tellus eu venenatis sollicitudin. In sed volutpat mauris. Nulla venenatis sed augue sed iaculis.\n\n" ]
                ]
            , Panel.default []
                [ Panel.head [] [ text "In sed volutpat mauris" ]
                , Panel.content [] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at tortor nec leo vestibulum varius. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras elementum odio eu lectus iaculis pretium. Nulla vel velit venenatis, hendrerit nisl sit amet, placerat erat. Duis consectetur ante felis, ac auctor diam maximus vel. Phasellus scelerisque justo arcu, et dignissim ex laoreet non. Aenean sit amet sem sit amet eros aliquam placerat. Maecenas id viverra risus. Mauris tempor dui non commodo ornare. Mauris congue dignissim dolor quis auctor. Quisque eu erat orci. Mauris quis pretium justo, vitae gravida diam.\n\nDonec consequat diam mattis pellentesque tempus. Maecenas et interdum nisl, sit amet molestie felis. Donec euismod rhoncus enim, vel facilisis enim finibus vel. Sed sit amet diam leo. Fusce tincidunt eros quis imperdiet feugiat. Aliquam facilisis tellus fermentum tellus malesuada, ac sagittis metus volutpat. Cras eget interdum lorem. Praesent dignissim tellus eu venenatis sollicitudin. In sed volutpat mauris. Nulla venenatis sed augue sed iaculis.\n\n" ]
                , Panel.foot []
                    [ Button.default [] [ text "Cancel" ]
                    , Button.primary [] [ text "Confirm" ]
                    ]
                ]
            ]
        ]
