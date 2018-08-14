module Views.Ui.Checkbox exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Views.Theme exposing (Element, identify, theme)


identify_ : String -> Style
identify_ string =
    "Views.UI.Checkbox." ++ string |> identify


default : Element msg
default =
    styled input
        []
