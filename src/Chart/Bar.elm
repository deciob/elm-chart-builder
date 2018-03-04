module Chart.Bar exposing (..)

import Chart.Types exposing (..)
import Html exposing (Html)


render : Config -> Html msg
render config =
    Html.text <| config.height


scaleTest : Config -> Config
scaleTest config =
    config
