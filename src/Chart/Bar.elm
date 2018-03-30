module Chart.Bar exposing (..)

import Chart.Types exposing (..)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Visualization.Axis as Axis exposing (defaultOptions)
import Visualization.Scale as Scale exposing (BandConfig, BandScale, ContinuousScale, defaultBandConfig)


linearScale : LinearDomain -> Range -> ContinuousScale
linearScale domain range =
    Scale.linear domain range


ordinalScale : OrdinalDomain -> Range -> BandScale String
ordinalScale domain range =
    Scale.band { defaultBandConfig | paddingInner = 0.1, paddingOuter = 0.2 }
        domain
        range


render : List (InternalData a) -> InternalConfig -> Html msg
render data config_ =
    Html.text <| toString <| config.height


scaleTest : Config -> Config
scaleTest config =
    config
