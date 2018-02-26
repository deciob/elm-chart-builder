module Chart.Types
    exposing
        ( Data
        , DerivedConfig
        , PointLinear
        , PointOrdinal
        , PointTime
        , fromData
        , fromPointLinear
        , fromPointOrdinal
        , fromPointTime
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
        , defaultBandConfig
        )


type PointTime
    = PointTime ( Date, Float )


toPointTime : ( Date, Float ) -> PointTime
toPointTime point =
    PointTime point


fromPointTime : PointTime -> ( Date, Float )
fromPointTime (PointTime point) =
    point


type PointOrdinal
    = PointOrdinal ( String, Float )


toPointOrdinal : ( String, Float ) -> PointOrdinal
toPointOrdinal point =
    PointOrdinal point


fromPointOrdinal : PointOrdinal -> ( String, Float )
fromPointOrdinal (PointOrdinal point) =
    point


type PointLinear
    = PointLinear ( Float, Float )


toPointLinear : ( Float, Float ) -> PointLinear
toPointLinear point =
    PointLinear point


fromPointLinear : PointLinear -> ( Float, Float )
fromPointLinear (PointLinear point) =
    point


type alias InternalData point =
    { cssClass : Maybe String
    , point : point
    , title : Maybe String
    }


type Data point
    = Data (InternalData point)


toData : InternalData point -> Data point
toData data =
    Data data


fromData : Data point -> InternalData point
fromData (Data point) =
    point


type XScale
    = Ordinal (BandScale String)


type YScale
    = Linear ContinuousScale


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


type alias DerivedConfig =
    { height : Float
    , padding : Padding
    , width : Float
    , xScale : XScale
    , yScale : YScale
    }


deriveHeight : Height -> DerivedConfig -> DerivedConfig
deriveHeight height config =
    { config | width = Maybe.withDefault config.height height }


deriveWidth : Width -> DerivedConfig -> DerivedConfig
deriveWidth width config =
    { config | height = Maybe.withDefault config.width width }
