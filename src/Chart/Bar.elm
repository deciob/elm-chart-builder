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
    , linearDomain = ( 0, 0 )
    , bandScaleConfig = defaultBandConfig
    , padding = { top = 5, right = 5, bottom = 5, left = 5 }
    , width = 600
    }


initConfig : Config
initConfig =
    toConfig
        { height = Nothing
        , linearDomain = Nothing
        , bandScaleConfig = Nothing
        , padding = Nothing
        , width = Nothing
        }


render : Data -> Config -> Html msg
render data_ config_ =
    let
        config : InternalConfig
        config =
            fromConfig config_
                |> (\config ->
                        { height = Maybe.withDefault defaultConfig.height config.height
                        , linearDomain =
                            Maybe.withDefault defaultConfig.linearDomain
                                config.linearDomain
                        , bandScaleConfig =
                            Maybe.withDefault defaultConfig.bandScaleConfig
                                config.bandScaleConfig
                        , padding =
                            Maybe.withDefault defaultConfig.padding
                                config.padding
                        , width = Maybe.withDefault defaultConfig.width config.width
                        }
                   )

        data =
            fromData data_

        pointStructure =
            getDataPointStructure data
    in
    case pointStructure of
        Nothing ->
            Html.text ""

        Just point ->
            case point of
                PointBand point ->
                    renderBand data config

                _ ->
                    Html.text ""


renderBand : List (List DataStructure) -> InternalConfig -> Html msg
renderBand data config =
    Html.text ""


scaleTest : Config -> Config
scaleTest config =
    config
