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
                , title = Nothing
                , point = toPointBand ( "a", 10 )
                }
              ]
            ]
                |> toData
    in
    Bar.initConfig
        |> Bar.render data
