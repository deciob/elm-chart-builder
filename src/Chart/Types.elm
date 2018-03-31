module Chart.Types
    exposing
        ( BandDomain
        , Config
        , Data
        , DataStructure
        , InternalConfig
        , LinearDomain
        , Orientation
        , Point(..)
        , Range
        , Scale(..)
        , TimeDomain
        , fromConfig
        , fromData
        , fromPointBand
        , fromPointLinear
        , fromPointTime
        , getDataPointStructure
        , setHeight
        , setPadding
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


getDataPointStructure : List (List DataStructure) -> Maybe Point
getDataPointStructure data =
    data
        |> List.head
        |> Maybe.withDefault []
        |> List.head
        |> Maybe.map .point


type Point
    = PointLinear ( Float, Float )
    | PointBand ( String, Float )
    | PointTime ( Date, Float )


type alias DataStructure =
    { cssClass : Maybe String
    , point : Point
    , title : Maybe String
    }


type Data
    = Data (List (List DataStructure))


type alias LinearDomain =
    ( Float, Float )


type alias BandDomain =
    List String


type alias TimeDomain =
    ( Date, Date )


type alias Range =
    ( Float, Float )


toData : List (List DataStructure) -> Data
toData data =
    Data data


fromData : Data -> List (List DataStructure)
fromData (Data data) =
    data


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
    , linearDomain : Maybe LinearDomain
    , bandScaleConfig : Maybe BandConfig
    , padding : Maybe Padding
    , width : Maybe Float
    }


type alias InternalConfig =
    { height : Float
    , linearDomain : LinearDomain
    , bandScaleConfig : BandConfig
    , padding : Padding
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
