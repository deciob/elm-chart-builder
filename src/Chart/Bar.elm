module Chart.Bar exposing (..)

import Chart.Helpers exposing (..)
import Chart.Types exposing (..)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Visualization.Axis as Axis
import Visualization.Scale as Scale exposing (BandConfig, BandScale, ContinuousScale, defaultBandConfig)


linearScale : LinearDomain -> Range -> ContinuousScale
linearScale domain range =
    Scale.linear domain range


bandScale : BandConfig -> BandDomain -> Range -> BandScale String
bandScale bandConfig domain range =
    Scale.band bandConfig
        domain
        range


defaultConfig : InternalConfigStructure
defaultConfig =
    { bandAxisOptions = Axis.defaultOptions
    , bandGroupAxisOptions = Axis.defaultOptions
    , bandScaleConfig = defaultBandConfig
    , height = 400
    , layout = Grouped
    , linearDomain = Nothing
    , linearAxisOptions = Axis.defaultOptions
    , orientation = Vertical
    , margin = { top = 5, right = 5, bottom = 5, left = 5 }
    , width = 600
    }


initConfig : Config
initConfig =
    toConfig
        { bandAxisOptions = Nothing
        , bandGroupAxisOptions = Nothing
        , bandScaleConfig = Nothing
        , height = Nothing
        , layout = Nothing
        , linearDomain = Nothing
        , linearAxisOptions = Nothing
        , orientation = Nothing
        , margin = Nothing
        , width = Nothing
        }


internalConfig : Data -> Config -> InternalConfigStructure
internalConfig data config =
    fromConfig config
        |> (\config ->
                let
                    margin =
                        Maybe.withDefault defaultConfig.margin
                            config.margin

                    height =
                        Maybe.withDefault (defaultConfig.height - margin.top - margin.bottom)
                            config.height
                            - margin.top
                            - margin.bottom

                    width =
                        Maybe.withDefault (defaultConfig.width - margin.top - margin.bottom)
                            config.width
                            - margin.left
                            - margin.right

                    orientation =
                        Maybe.withDefault defaultConfig.orientation config.orientation

                    firstDataPoint =
                        data |> List.head |> Maybe.andThen List.head

                    ( bandAxisOptions, bandGroupAxisOptions ) =
                        axisBandDefaultOptions (toAxisBandConfig config) data
                in
                { bandAxisOptions = bandAxisOptions
                , bandGroupAxisOptions = bandGroupAxisOptions
                , bandScaleConfig =
                    Maybe.withDefault defaultConfig.bandScaleConfig
                        config.bandScaleConfig
                , height = height
                , layout = Maybe.withDefault defaultConfig.layout config.layout
                , linearDomain = config.linearDomain
                , linearAxisOptions = Maybe.withDefault Axis.defaultOptions config.linearAxisOptions
                , orientation = orientation
                , margin = margin
                , width = width
                }
           )


render : Data -> Config -> Html msg
render data config_ =
    let
        config : InternalConfigStructure
        config =
            internalConfig data config_

        pointStructure =
            getDataPointStructure data
    in
    case pointStructure of
        PointBand point ->
            renderBand data config

        NoPoint ->
            Html.text "no point struncture"

        _ ->
            Html.text "not yet implemented"


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
    InternalConfigStructure
    -> BandScale String
    -> ContinuousScale
    -> Datum
    -> Svg msg
bandColumn config bandScale linearScale dataPoint =
    let
        ( category, value ) =
            fromPointBand dataPoint.point |> Maybe.withDefault ( "", 0 )

        rectangle =
            { x = Scale.convert bandScale category
            , y = Scale.convert linearScale value
            , width = Scale.bandwidth bandScale
            , height = config.height - Scale.convert linearScale value
            }

        cssClass =
            Maybe.withDefault "" dataPoint.cssClass
    in
    column value cssClass rectangle


gBlock : List (Svg msg) -> Svg msg
gBlock children =
    g [] children


renderBandGroup :
    InternalConfigStructure
    -> BandScale String
    -> ContinuousScale
    -> Int
    -> List Datum
    -> Svg msg
renderBandGroup config bandScaleGroup appliedLinearScale idx dataGroup =
    let
        appliedBandScale =
            getBandGroupScale config bandScaleGroup idx dataGroup
    in
    dataGroup
        |> List.map
            (\d ->
                bandColumn
                    config
                    appliedBandScale
                    appliedLinearScale
                    d
            )
        |> gBlock


renderBand : List (List Datum) -> InternalConfigStructure -> Html msg
renderBand data config =
    let
        horizontalRange =
            ( 0, config.width )

        verticalRange =
            ( config.height, 0 )

        linearDomain =
            getLinearDomain
                data
                (.point >> fromPointBand >> Maybe.map Tuple.second >> Maybe.withDefault 0)
                config.linearDomain
                -- TODO: this step should be removed, all domains should be handled
                |> (\d -> ( 0, Tuple.second d ))

        bandDomain =
            -- TODO: extrapolate to helper function and test
            data
                |> List.indexedMap
                    (\idx g ->
                        g |> List.head |> Maybe.andThen .group |> Maybe.withDefault (toString idx)
                    )

        appliedLinearScale =
            linearScale linearDomain verticalRange

        appliedBandScale =
            bandScale config.bandScaleConfig bandDomain horizontalRange

        bandAxisOptions =
            config.bandAxisOptions

        bandGroupAxisOptions =
            config.bandGroupAxisOptions

        ( d, bandAxisGroup ) =
            case config.layout of
                Grouped ->
                    data
                        |> List.indexedMap
                            (\idx dataGroup ->
                                ( renderBandGroup config appliedBandScale appliedLinearScale idx dataGroup
                                , renderBandGroupAxis config appliedBandScale idx dataGroup
                                )
                            )
                        |> List.unzip
                        |> (\( a, b ) ->
                                if List.length b == 1 then
                                    ( a, b )
                                else
                                    ( a, bandAxis bandGroupAxisOptions appliedBandScale :: b )
                           )

                _ ->
                    ( [], [] )
    in
    svg
        [ width (toString (config.width + config.margin.left + config.margin.right) ++ "px")
        , height (toString (config.height + config.margin.top + config.margin.bottom) ++ "px")
        ]
        [ g
            [ transform
                ("translate("
                    ++ toString config.margin.left
                    ++ ", "
                    ++ toString config.margin.top
                    ++ ")"
                )
            , class "series"
            ]
            [ linearAxis config.linearAxisOptions appliedLinearScale ]
        , g
            [ transform
                ("translate("
                    ++ toString config.margin.left
                    ++ ", "
                    ++ toString (config.height + config.margin.top)
                    ++ ")"
                )
            , class "series"
            ]
            bandAxisGroup
        , g
            [ transform
                ("translate("
                    ++ toString config.margin.left
                    ++ ", "
                    ++ toString config.margin.top
                    ++ ")"
                )
            , class "series"
            ]
          <|
            d
        ]



-- AXIS


axisBandDefaultOptions : AxisBandConfig a -> Data -> ( Axis.Options String, Axis.Options String )
axisBandDefaultOptions config data =
    let
        config_ =
            fromAxisBandConfig config

        orientation =
            Maybe.withDefault Vertical config_.orientation

        default =
            Axis.defaultOptions
                |> (\d ->
                        { d
                            | tickFormat = Just identity
                            , orientation =
                                case orientation of
                                    Vertical ->
                                        Axis.Bottom

                                    Horizontal ->
                                        Axis.Left
                        }
                   )
    in
    case data |> List.head |> Maybe.andThen List.head |> Maybe.map .group of
        Just group ->
            if List.length data > 1 then
                ( Maybe.withDefault (default |> axisHideTicks) config_.bandAxisOptions
                , Maybe.withDefault default config_.bandGroupAxisOptions
                )
            else
                ( Maybe.withDefault default config_.bandAxisOptions
                , Maybe.withDefault (default |> axisHideTicks) config_.bandGroupAxisOptions
                )

        Nothing ->
            ( default, default )


axisHideTicks : Axis.Options String -> Axis.Options String
axisHideTicks options =
    { options | ticks = Just [], tickCount = 0 }


linearAxis : Axis.Options Float -> ContinuousScale -> Svg msg
linearAxis options scale =
    Axis.axis options scale


bandAxis : Axis.Options String -> BandScale String -> Svg msg
bandAxis options scale =
    Axis.axis options (Scale.toRenderable scale)


renderBandGroupAxis :
    InternalConfigStructure
    -> BandScale String
    -> Int
    -> List Datum
    -> Svg msg
renderBandGroupAxis config bandScaleGroup idx dataGroup =
    let
        appliedBandScale =
            getBandGroupScale config bandScaleGroup idx dataGroup
    in
    bandAxis config.bandAxisOptions appliedBandScale



-- HELPERS


getBandGroupScale :
    InternalConfigStructure
    -> BandScale String
    -> Int
    -> List Datum
    -> BandScale String
getBandGroupScale config bandScaleGroup idx dataGroup =
    let
        bandWidth =
            Scale.bandwidth bandScaleGroup

        initialPoint =
            dataGroup
                |> List.head
                |> Maybe.andThen .group
                |> Maybe.withDefault (toString idx)
                |> Scale.convert bandScaleGroup

        endPoint =
            initialPoint + bandWidth

        horizontalRange =
            ( initialPoint, endPoint )

        bandDomain =
            dataGroup
                |> List.map (.point >> fromPointBand >> Maybe.withDefault ( "", 0 ) >> Tuple.first)
    in
    bandScale config.bandScaleConfig bandDomain horizontalRange
