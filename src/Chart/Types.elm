module Chart.Types
    exposing
        ( Config
        , Data
        , InternalConfig
        , InternalData
        , LinearDomain
        , OrdinalDomain
        , Orientation
        , PointLinear
        , PointOrdinal
        , PointTime
        , Range
        , TimeDomain
        , defaultConfig
        , fromConfig
        , fromData
        , fromPointLinear
        , fromPointOrdinal
        , fromPointTime
        , setHeight
        , setHorizontalScaleToLinear
        , setHorizontalScaleToOrdinal
        , setHorizontalScaleToTime
        , setPadding
        , setVerticalScaleToLinear
        , setVerticalScaleToOrdinal
        , setVerticalScaleToTime
        , setWidth
        , toConfig
        , toData
        , toPointLinear
        , toPointOrdinal
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
        , defaultBandConfig
        )


type Scale
    = Ordinal
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


type PointOrdinal
    = PointOrdinal ( String, Float )


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


type alias OrdinalDomain =
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


toPointOrdinal : ( String, Float ) -> PointOrdinal
toPointOrdinal point =
    PointOrdinal point


fromPointOrdinal : PointOrdinal -> ( String, Float )
fromPointOrdinal (PointOrdinal point) =
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


type OrdinalScale
    = OrdinalScale (BandScale String)


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
    , ordinalScaleConfig : Maybe BandConfig
    , padding : Maybe Padding
    , verticalScaleType : Maybe Scale
    , width : Maybe Float
    }


type alias InternalConfig =
    { height : Float
    , horizontalScaleType : Scale
    , linearDomain : LinearDomain
    , ordinalScaleConfig : BandConfig
    , padding : Padding
    , verticalScaleType : Scale
    , width : Float
    }


defaultConfig : InternalConfig
defaultConfig =
    { height = 400
    , horizontalScaleType = Ordinal
    , linearDomain = ( 0, 0 )
    , ordinalScaleConfig = defaultBandConfig
    , padding = { top = 5, right = 5, bottom = 5, left = 5 }
    , verticalScaleType = Linear
    , width = 600
    }


type Config
    = Config InternalConfig


toConfig : InternalConfig -> Config
toConfig config =
    Config config


fromConfig : Config -> InternalConfig
fromConfig (Config config) =
    config


setOrdinalScaleConfig : BandConfig -> Config -> Config
setOrdinalScaleConfig bandConfig config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | ordinalScaleConfig = bandConfig }


setHeight : Float -> Config -> Config
setHeight height config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | height = height }


setWidth : Float -> Config -> Config
setWidth width config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | width = width }


setPadding : Padding -> Config -> Config
setPadding padding config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | padding = padding }


setHorizontalScaleToLinear : Config -> Config
setHorizontalScaleToLinear config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | horizontalScaleType = Linear }


setHorizontalScaleToOrdinal : Config -> Config
setHorizontalScaleToOrdinal config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | horizontalScaleType = Ordinal }


setHorizontalScaleToTime : Config -> Config
setHorizontalScaleToTime config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | horizontalScaleType = Time }


setVerticalScaleToLinear : Config -> Config
setVerticalScaleToLinear config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | verticalScaleType = Linear }


setVerticalScaleToOrdinal : Config -> Config
setVerticalScaleToOrdinal config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | verticalScaleType = Ordinal }


setVerticalScaleToTime : Config -> Config
setVerticalScaleToTime config =
    let
        internalConfig =
            fromConfig config
    in
    toConfig { internalConfig | verticalScaleType = Time }
