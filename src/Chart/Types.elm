module Chart.Types
    exposing
        ( BandDomain
        , Config
        , Data
        , DataStructure
        , InternalConfig
        , Layout(..)
        , LinearDomain
        , Orientation(..)
        , Point(..)
        , Range
        , Rectangle
        , Scale(..)
        , TimeDomain
        , fromConfig
        , fromPointBand
        , fromPointLinear
        , fromPointTime
        , getDataPointStructure
        , setBandAxisOptions
        , setBandScaleConfig
        , setHeight
        , setLinearAxisOptions
        , setMargin
        , setWidth
        , toConfig
        , toPointBand
        , toPointLinear
        , toPointTime
        )

import Date exposing (Date)
import Html exposing (..)
import Visualization.Axis
import Visualization.Scale as Scale
    exposing
        ( BandConfig
        , BandScale
        , ContinuousScale
        , ContinuousTimeScale
        )


type Scale
    = Band
    | Linear
    | Time


type Orientation
    = Vertical
    | Horizontal


type Layout
    = Stacked
    | Grouped


getDataPointStructure : List (List DataStructure) -> Maybe Point
getDataPointStructure data =
    data
        |> List.head
        |> Maybe.andThen List.head
        |> Maybe.map .point


type Point
    = PointLinear ( Float, Float )
    | PointBand ( String, Float )
    | PointTime ( Date, Float )


type alias DataStructure =
    { cssClass : Maybe String
    , group : Maybe String
    , point : Point
    , tooltip : Maybe String
    }


type alias Data =
    List (List DataStructure)


type alias LinearDomain =
    ( Float, Float )


type alias BandDomain =
    List String


type alias TimeDomain =
    ( Date, Date )


type alias Range =
    ( Float, Float )


toPointTime : ( Date, Float ) -> Point
toPointTime point =
    PointTime point


fromPointTime : Point -> Maybe ( Date, Float )
fromPointTime point =
    case point of
        PointTime data ->
            Just data

        _ ->
            Nothing


toPointBand : ( String, Float ) -> Point
toPointBand point =
    PointBand point


fromPointBand : Point -> Maybe ( String, Float )
fromPointBand point =
    case point of
        PointBand data ->
            Just data

        _ ->
            Nothing


toPointLinear : ( Float, Float ) -> Point
toPointLinear point =
    PointLinear point


fromPointLinear : Point -> Maybe ( Float, Float )
fromPointLinear point =
    case point of
        PointLinear data ->
            Just data

        _ ->
            Nothing


type alias Rectangle =
    { x : Float, y : Float, width : Float, height : Float }


type BandScale
    = BandScale (BandScale String)


type LinearScale
    = LinearScale ContinuousScale


type TimeScale
    = TimeScale ContinuousTimeScale


type alias Height =
    Maybe Float


type alias Width =
    Maybe Float


type alias Margin =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type alias ConfigStructure =
    { bandAxisOptions : Maybe (Visualization.Axis.Options String)
    , bandScaleConfig : Maybe BandConfig
    , height : Maybe Float
    , layout : Maybe Layout
    , linearDomain : Maybe LinearDomain
    , linearAxisOptions : Maybe (Visualization.Axis.Options Float)
    , orientation : Maybe Orientation
    , margin : Maybe Margin
    , width : Maybe Float
    }


type alias InternalConfig =
    { bandAxisOptions : Visualization.Axis.Options String
    , bandScaleConfig : BandConfig
    , height : Float
    , layout : Layout
    , linearDomain : Maybe LinearDomain
    , linearAxisOptions : Visualization.Axis.Options Float
    , orientation : Orientation
    , margin : Margin
    , width : Float
    }


type Config
    = Config ConfigStructure


toConfig : ConfigStructure -> Config
toConfig config =
    Config config


fromConfig : Config -> ConfigStructure
fromConfig (Config config) =
    config


setBandScaleConfig : BandConfig -> Config -> Config
setBandScaleConfig bandConfig config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | bandScaleConfig = Just bandConfig }


setHeight : Float -> Config -> Config
setHeight height config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | height = Just height }


setLayout : Layout -> Config -> Config
setLayout layout config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | layout = Just layout }


setOrientation : Orientation -> Config -> Config
setOrientation orientation config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | orientation = Just orientation }


setWidth : Float -> Config -> Config
setWidth width config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | width = Just width }


setMargin : Margin -> Config -> Config
setMargin margin config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | margin = Just margin }


setLinearAxisOptions : Visualization.Axis.Options Float -> Config -> Config
setLinearAxisOptions options config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | linearAxisOptions = Just options }


setBandAxisOptions : Visualization.Axis.Options String -> Config -> Config
setBandAxisOptions options config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | bandAxisOptions = Just options }
