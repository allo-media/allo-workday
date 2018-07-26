module Views.App exposing (view)

import Html.Styled exposing (Html, div)
import Views.Theme exposing (defaultCss)


view : Html msg -> Html msg
view content =
    div [] [ defaultCss, content ]
