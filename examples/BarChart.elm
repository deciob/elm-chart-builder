module BarChart exposing (main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Bar as Bar
import Chart.Types exposing (..)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


main : Html msg
main =
    let
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
            ]
    in
    Bar.initConfig
        |> setHeight 500
        |> setWidth 600
        |> setBandScaleConfig
            { paddingInner = 0.1
            , paddingOuter = 0.1
            , align = 0.5
            }
        |> Bar.render data
