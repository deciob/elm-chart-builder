module Chart.Types
    exposing
        ( Config
        , Data
        , PointLinear
        , PointOrdinal
        , PointTime
        , fromConfig
        , fromData
        , fromPointLinear
        , fromPointOrdinal
        , fromPointTime
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


type alias InternalConfig =
    { height : Float
    , padding : Padding
    , width : Float
    , xScale : OrdinalScale
    , yScale : LinearScale
    }


type Config
    = Config InternalConfig


toConfig : InternalConfig -> Config
toConfig config =
    Config config


fromConfig : Config -> InternalConfig
fromConfig (Config config) =
    config
