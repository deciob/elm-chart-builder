module Chart.BarTests exposing (..)

import Chart.Bar
import Chart.Types exposing (..)
import Examples.BarChart
import Expect exposing (Expectation)
import Html exposing (Html)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)
import Visualization.Axis as Axis


defaultAxisOptions : Axis.Options String
defaultAxisOptions =
    let
        default =
            Axis.defaultOptions
    in
    { default
        | tickFormat = Just identity
        , orientation = Axis.Bottom
    }


suite : Test
suite =
    describe "the bar module"
        [ test "axisBandDefaultOptions no Data" <|
            \() ->
                let
                    data : Data
                    data =
                        []

                    config =
                        toAxisBandConfig
                            { bandAxisOptions = Just Axis.defaultOptions
                            , bandGroupAxisOptions = Just Axis.defaultOptions
                            , orientation = Just Vertical
                            }

                    expected =
                        ( defaultAxisOptions, defaultAxisOptions )
                in
                Chart.Bar.axisBandDefaultOptions config data |> Expect.equal expected
        , test "axisBandDefaultOptions one Data point" <|
            \() ->
                let
                    data : Data
                    data =
                        [ [ { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 10 )
                            , group = Just "A"
                            }
                          ]
                        ]

                    config =
                        toAxisBandConfig
                            { bandAxisOptions = Nothing
                            , bandGroupAxisOptions = Nothing
                            , orientation = Just Vertical
                            }

                    options =
                        Axis.defaultOptions

                    expected =
                        ( defaultAxisOptions
                        , { defaultAxisOptions | ticks = Just [], tickCount = 0 }
                        )
                in
                Chart.Bar.axisBandDefaultOptions config data |> Expect.equal expected
        , test "axisBandDefaultOptions one Data group" <|
            \() ->
                let
                    data : Data
                    data =
                        [ [ { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 10 )
                            , group = Just "A"
                            }
                          , { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 20 )
                            , group = Just "A"
                            }
                          ]
                        ]

                    config =
                        toAxisBandConfig
                            { bandAxisOptions = Nothing
                            , bandGroupAxisOptions = Nothing
                            , orientation = Just Vertical
                            }

                    options =
                        Axis.defaultOptions

                    expected =
                        ( defaultAxisOptions
                        , { defaultAxisOptions | ticks = Just [], tickCount = 0 }
                        )
                in
                Chart.Bar.axisBandDefaultOptions config data |> Expect.equal expected
        , test "axisBandDefaultOptions many Data groups" <|
            \() ->
                let
                    data : Data
                    data =
                        [ [ { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 10 )
                            , group = Just "A"
                            }
                          , { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 20 )
                            , group = Just "A"
                            }
                          ]
                        , [ { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 1 )
                            , group = Just "B"
                            }
                          , { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 2 )
                            , group = Just "B"
                            }
                          ]
                        ]

                    config =
                        toAxisBandConfig
                            { bandAxisOptions = Nothing
                            , bandGroupAxisOptions = Nothing
                            , orientation = Just Vertical
                            }

                    options =
                        Axis.defaultOptions

                    expected =
                        ( { defaultAxisOptions | ticks = Just [], tickCount = 0 }
                        , defaultAxisOptions
                        )
                in
                Chart.Bar.axisBandDefaultOptions config data |> Expect.equal expected
        , test "axisBandDefaultOptions many Data groups - horizontal orientation" <|
            \() ->
                let
                    data : Data
                    data =
                        [ [ { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 10 )
                            , group = Just "A"
                            }
                          , { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 20 )
                            , group = Just "A"
                            }
                          ]
                        , [ { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 1 )
                            , group = Just "B"
                            }
                          , { cssClass = Nothing
                            , tooltip = Nothing
                            , point = toPointBand ( "a", 2 )
                            , group = Just "B"
                            }
                          ]
                        ]

                    config =
                        toAxisBandConfig
                            { bandAxisOptions = Nothing
                            , bandGroupAxisOptions = Nothing
                            , orientation = Just Horizontal
                            }

                    options =
                        Axis.defaultOptions

                    expected =
                        ( { defaultAxisOptions | ticks = Just [], tickCount = 0, orientation = Axis.Left }
                        , { defaultAxisOptions | orientation = Axis.Left }
                        )
                in
                Chart.Bar.axisBandDefaultOptions config data |> Expect.equal expected
        ]
