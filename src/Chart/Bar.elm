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


bandScale : BandDomain -> Range -> BandScale String
bandScale domain range =
    Scale.band { defaultBandConfig | paddingInner = 0.1, paddingOuter = 0.2 }
        domain
        range


defaultConfig : InternalConfig
defaultConfig =
    { height = 400
    , horizontalScaleType = Band
    , linearDomain = ( 0, 0 )
    , bandScaleConfig = defaultBandConfig
    , padding = { top = 5, right = 5, bottom = 5, left = 5 }
    , verticalScaleType = Linear
    , width = 600
    }


render : List (Data a) -> Config -> Html msg
render data_ config_ =
    let
        config : InternalConfig
        config =
            fromConfig config_
                |> (\config ->
                        { height = Maybe.withDefault defaultConfig.height config.height
                        , horizontalScaleType =
                            Maybe.withDefault defaultConfig.horizontalScaleType
                                config.horizontalScaleType
                        , linearDomain =
                            Maybe.withDefault defaultConfig.linearDomain
                                config.linearDomain
                        , bandScaleConfig =
                            Maybe.withDefault defaultConfig.bandScaleConfig
                                config.bandScaleConfig
                        , padding =
                            Maybe.withDefault defaultConfig.padding
                                config.padding
                        , verticalScaleType =
                            Maybe.withDefault defaultConfig.verticalScaleType
                                config.verticalScaleType
                        , width = Maybe.withDefault defaultConfig.width config.width
                        }
                   )
    in
    case config.horizontalScaleType of
        Band ->
            renderBand data_ config

        _ ->
            Html.text ""


renderBand : List (Data PointBand) -> InternalConfig -> Html msg
renderBand data_ config =
    Html.text ""


scaleTest : Config -> Config
scaleTest config =
    config
