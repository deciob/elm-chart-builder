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
        }
      , { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "b", 13 )
        }
      ]
    , [ { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "a", 20 )
        }
      , { cssClass = Nothing
        , tooltip = Nothing
        , point = toPointBand ( "b", 13 )
        }
      ]
    ]


main : Html msg
main =
    Html.div
        [ Html.Attributes.style
            [ ( "height", "600px" )
            , ( "width", "600px" )
            , ( "background-color", "red" )
            ]
        ]
        [ Bar.initConfig
            |> setHeight 600
            |> setWidth 600
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
            |> Bar.render data
        ]
