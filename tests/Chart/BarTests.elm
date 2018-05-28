module Chart.BarTests exposing (..)

import Chart.Bar
import Examples.BarChart
import Expect exposing (Expectation)
import Html exposing (Html)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)


suite : Test
suite =
    test "bar charts" <|
        \() ->
            --BarChart.main
            let
                _ =
                    Debug.log "zzzz" Examples.BarChart.main
            in
            --Html.div [] []
            Examples.BarChart.main
                |> Query.fromHtml
                |> Query.has [ tag "div" ]
