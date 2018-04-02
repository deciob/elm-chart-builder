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
render data config_ =
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
            { x = 1, y = 1, width = 1, height = 1 }

        cssClass =
            Maybe.withDefault "" dataPoint.cssClass
    in
    column value cssClass rectangle


renderBand : List (List DataStructure) -> InternalConfig -> Html msg
renderBand data config =
    let
        d =
            data
                |> flatList
                |> List.map
                    (\d ->
                        bandColumn
                            config
                            (bandScale config.bandScaleConfig [ "a" ] ( 0, 1 ))
                            (linearScale ( 0, 1 ) ( 0, 1 ))
                            d
                    )
    in
    g
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


scaleTest : Config -> Config
scaleTest config =
    config
