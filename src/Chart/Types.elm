module Chart.Types
    exposing
        ( BandDomain
        , Config
        , Data
        , InternalConfig
        , InternalData
        , LinearDomain
        , Orientation
        , PointBand
        , PointLinear
        , PointTime
        , Range
        , Scale(..)
        , TimeDomain
        , fromConfig
        , fromData
        , fromPointBand
        , fromPointLinear
        , fromPointTime
        , setHeight
        , setHorizontalScaleToBand
        , setHorizontalScaleToLinear
        , setHorizontalScaleToTime
        , setPadding
        , setVerticalScaleToBand
        , setVerticalScaleToLinear
        , setVerticalScaleToTime
        , setWidth
        , toConfig
        , toData
        , toPointBand
        , toPointLinear
        , toPointTime
        )

import Date exposing (Date)
import Html exposing (..)
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


type PointLinear
    = PointLinear ( Float, Float )


type PointBand
    = PointBand ( String, Float )


type PointTime
    = PointTime ( Date, Float )


type alias InternalData point =
    { cssClass : Maybe String
    , point : point
    , title : Maybe String
    }


type Data point
    = Data (InternalData point)


type alias LinearDomain =
    ( Float, Float )


type alias BandDomain =
    List String


type alias TimeDomain =
    ( Date, Date )


type alias Range =
    ( Float, Float )


toPointTime : ( Date, Float ) -> PointTime
toPointTime point =
    PointTime point


fromPointTime : PointTime -> ( Date, Float )
fromPointTime (PointTime point) =
    point


toPointBand : ( String, Float ) -> PointBand
toPointBand point =
    PointBand point


fromPointBand : PointBand -> ( String, Float )
fromPointBand (PointBand point) =
    point


toPointLinear : ( Float, Float ) -> PointLinear
toPointLinear point =
    PointLinear point


fromPointLinear : PointLinear -> ( Float, Float )
fromPointLinear (PointLinear point) =
    point


toData : InternalData point -> Data point
toData data =
    Data data


fromData : Data point -> InternalData point
fromData (Data point) =
    point


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


type alias Padding =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type alias ConfigStructure =
    { height : Maybe Float
    , horizontalScaleType : Maybe Scale
    , linearDomain : Maybe LinearDomain
    , bandScaleConfig : Maybe BandConfig
    , padding : Maybe Padding
    , verticalScaleType : Maybe Scale
    , width : Maybe Float
    }


type alias InternalConfig =
    { height : Float
    , horizontalScaleType : Scale
    , linearDomain : LinearDomain
    , bandScaleConfig : BandConfig
    , padding : Padding
    , verticalScaleType : Scale
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


setWidth : Float -> Config -> Config
setWidth width config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | width = Just width }


setPadding : Padding -> Config -> Config
setPadding padding config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | padding = Just padding }


setHorizontalScaleToLinear : Config -> Config
setHorizontalScaleToLinear config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | horizontalScaleType = Just Linear }


setHorizontalScaleToBand : Config -> Config
setHorizontalScaleToBand config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | horizontalScaleType = Just Band }


setHorizontalScaleToTime : Config -> Config
setHorizontalScaleToTime config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | horizontalScaleType = Just Time }


setVerticalScaleToLinear : Config -> Config
setVerticalScaleToLinear config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | verticalScaleType = Just Linear }


setVerticalScaleToBand : Config -> Config
setVerticalScaleToBand config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | verticalScaleType = Just Band }


setVerticalScaleToTime : Config -> Config
setVerticalScaleToTime config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | verticalScaleType = Just Time }
