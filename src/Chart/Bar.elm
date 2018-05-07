module Chart.Bar exposing (..)

import Chart.Helpers exposing (..)
import Chart.Types exposing (..)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Visualization.Axis as Axis exposing (defaultOptions)
import Visualization.Scale as Scale exposing (BandConfig, BandScale, ContinuousScale, defaultBandConfig)


linearScale : LinearDomain -> Range -> ContinuousScale
linearScale domain range =
    Scale.linear domain range


bandScale : BandConfig -> BandDomain -> Range -> BandScale String
bandScale bandConfig domain range =
    Scale.band bandConfig
        domain
        range


defaultConfig : InternalConfig
defaultConfig =
    { bandScaleConfig = defaultBandConfig
    , height = 400
    , layout = Grouped
    , linearDomain = Nothing
    , orientation = Horizontal
    , padding = { top = 5, right = 5, bottom = 5, left = 5 }
    , width = 600
    }


initConfig : Config
initConfig =
    toConfig
        { bandScaleConfig = Nothing
        , height = Nothing
        , layout = Nothing
        , linearDomain = Nothing
        , orientation = Nothing
        , padding = Nothing
        , width = Nothing
        }


internalConfig : Data -> Config -> InternalConfig
internalConfig data config =
    fromConfig config
        |> (\config ->
                { bandScaleConfig =
                    Maybe.withDefault defaultConfig.bandScaleConfig
                        config.bandScaleConfig
                , height = Maybe.withDefault defaultConfig.height config.height
                , layout = Maybe.withDefault defaultConfig.layout config.layout
                , linearDomain = config.linearDomain
                , orientation = Maybe.withDefault defaultConfig.orientation config.orientation
                , padding =
                    Maybe.withDefault defaultConfig.padding
                        config.padding
                , width = Maybe.withDefault defaultConfig.width config.width
                }
           )


render : Data -> Config -> Html msg
render data config_ =
    let
        config : InternalConfig
        config =
            internalConfig data config_

        pointStructure =
            getDataPointStructure data
    in
    case pointStructure of
        Nothing ->
            Html.text "no point struncture"

        Just point ->
            case point of
                PointBand point ->
                    renderBand data config

                _ ->
                    Html.text ""


column : Float -> String -> Rectangle -> Svg msg
column value cssClass { x, y, width, height } =
    g [ class ("column " ++ cssClass) ]
        [ Svg.title [] [ Svg.text <| toString value ]
        , rect
            [ Svg.Attributes.x <| toString x
            , Svg.Attributes.y <| toString y
            , Svg.Attributes.width <| toString width
            , Svg.Attributes.height <| toString height
            ]
            []
        ]


bandColumn :
    InternalConfig
    -> BandScale String
    -> ContinuousScale
    -> DataStructure
    -> Svg msg
bandColumn config ordinalScale linearScale dataPoint =
    let
        ( category, value ) =
            fromPointBand dataPoint.point |> Maybe.withDefault ( "", 0 )

        rectangle =
            { x = Scale.convert ordinalScale category
            , y = Scale.convert linearScale value
            , width = Scale.bandwidth ordinalScale
            , height = config.height - Scale.convert linearScale value - config.padding.bottom
            }

        cssClass =
            Maybe.withDefault "" dataPoint.cssClass
    in
    column value cssClass rectangle


gBlock : List (Svg msg) -> Svg msg
gBlock children =
    g [] children


renderBand : List (List DataStructure) -> InternalConfig -> Html msg
renderBand data config =
    let
        horizontalRange =
            ( 0, config.width - config.padding.left - config.padding.right )

        verticalRange =
            ( config.height - config.padding.top - config.padding.bottom, 0 )

        linearDomain =
            getLinearDomain
                data
                (.point >> fromPointBand >> Maybe.withDefault ( "", 0 ) >> Tuple.second)
                config.linearDomain
                |> (\d -> ( 0, Tuple.second d ))

        bandDomain =
            data
                |> flatList
                |> List.map (.point >> fromPointBand >> Maybe.withDefault ( "", 0 ) >> Tuple.first)

        d =
            case config.layout of
                Grouped ->
                    data
                        |> List.map
                            (\dataGroup ->
                                dataGroup
                                    |> List.map
                                        (\d ->
                                            bandColumn
                                                config
                                                (bandScale config.bandScaleConfig bandDomain horizontalRange)
                                                (linearScale linearDomain verticalRange)
                                                d
                                        )
                                    |> gBlock
                            )

                _ ->
                    []
    in
    svg [ width (toString config.width ++ "px"), height (toString config.height ++ "px") ]
        [ g
            [ transform
                ("translate("
                    ++ toString config.padding.left
                    ++ ", "
                    ++ toString config.padding.bottom
                    ++ ")"
                )
            , class "series"
            ]
          <|
            d
        ]


scaleTest : Config -> Config
scaleTest config =
    config
