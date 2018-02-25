module Chart.Types exposing (DerivedConfig)

import Date exposing (Date)
import Html exposing (..)
import Visualization.Scale as Scale
    exposing
        ( BandConfig
        , BandScale
        , ContinuousScale
        , defaultBandConfig
        )


type Point
    = Time ( Date, Float )
    | Ordinal ( String, Float )


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
deriveHeight config height =
    { config | width = Maybe.withDefault config.height height }


deriveWidth : Width -> DerivedConfig -> DerivedConfig
deriveWidth config width =
    { config | height = Maybe.withDefault config.width width }
