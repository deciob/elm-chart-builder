module Examples.BarChart exposing (data, main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Bar as Bar
import Chart.Types exposing (..)
import Html exposing (Html)
import Html.Attributes
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Visualization.Axis as Axis exposing (defaultOptions)


data : Data
data =
    [ [ { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "a", 10 )
        , group = Just "A"
        }
      , { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "b", 13 )
        , group = Just "A"
        }
      ]
    ]


data2 : Data
data2 =
    [ [ { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "a", 10 )
        , group = Just "A"
        }
      , { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "b", 13 )
        , group = Just "A"
        }
      ]
    , [ { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "a", 30 )
        , group = Just "B"
        }
      , { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "b", 13 )
        , group = Just "B"
        }
      ]
    ]


data3 : Data
data3 =
    data2 |> List.map (\d -> d |> List.map (\dd -> { dd | group = Nothing }))


defaultConfig =
    Bar.initConfig
        |> setHeight 300
        |> setWidth 400
        |> setMargin
            { top = 10
            , right = 10
            , bottom = 30
            , left = 30
            }
        |> setBandScaleConfig
            { paddingInner = 0.05
            , paddingOuter = 0.05
            , align = 0.5
            }
        |> setLinearAxisOptions
            { defaultOptions | tickCount = 5 }


main : Html msg
main =
    Html.div
        []
        [ Html.div
            [ Html.Attributes.style
                [ ( "height", "300px" )
                , ( "width", "400px" )
                , ( "background-color", "red" )
                ]
            ]
            [ defaultConfig
                |> Bar.render data
            ]
        , Html.div
            [ Html.Attributes.style
                [ ( "height", "300px" )
                , ( "width", "400px" )
                , ( "background-color", "red" )
                ]
            ]
            [ defaultConfig
                |> Bar.render data2
            ]
        , Html.div
            [ Html.Attributes.style
                [ ( "height", "300px" )
                , ( "width", "400px" )
                , ( "background-color", "red" )
                ]
            ]
            [ defaultConfig
                |> setBandGroupAxisOptions
                    { defaultOptions
                        | orientation = Axis.Bottom
                        , tickFormat = Just identity
                    }
                |> Bar.render data3
            ]
        ]
