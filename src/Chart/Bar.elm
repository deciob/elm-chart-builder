module Chart.Bar exposing (..)

import Chart.Types exposing (..)


render : DerivedConfig -> Html msg
render derivedConfig =
    Html.text <| derivedConfig.height
