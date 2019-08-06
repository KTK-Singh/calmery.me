module Pages.Top exposing (view)

import Html exposing (Html, div, text)
import Model exposing (Model)
import Pages.Top.Header as Header


view model =
    div []
        [ Header.view model
        ]
