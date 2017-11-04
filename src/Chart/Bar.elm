module Chart.Bar exposing (..)

import Date exposing (Date)


type Point
    = Time ( Date, Float )
    | Ordinal ( String, Float )


type alias Config =
    { height : Maybe Float
    , padding : Maybe { top : Float, right : Float, bottom : Float, left : Float }
    , width : Maybe Float
    }


type alias InternalConfig =
    { height : Float
    , padding : { top : Float, right : Float, bottom : Float, left : Float }
    , width : Float
    }


defaultConfig : Config
defaultConfig =
    { height = Nothing
    , padding = Nothing
    , width = Nothing
    }


defaultInternalConfig : InternalConfig
defaultInternalConfig =
    { height = 400
    , padding = { top = 2, right = 2, bottom = 2, left = 2 }
    , width = 600
    }



-- xScale : List ( Date, Float ) -> BandScale Date
-- xScale model =
--     Scale.band { defaultBandConfig | paddingInner = 0.1, paddingOuter = 0.2 } (List.map Tuple.first model) ( 0, w - 2 * padding )
--
--
-- yScale : ContinuousScale
-- yScale =
--     Scale.linear ( 0, 5 ) ( h - 2 * padding, 0 )
