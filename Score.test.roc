module []

import Score exposing [scoreTddStep]
import cli.Utc

defaultControlResult = { passingTestsCount: 20, totalTestCount: 103 }
defaultControlResult2 = { passingTestsCount: 53, totalTestCount: 103 }
green = { result: Green, controlResult: defaultControlResult, performedAt: 123 |> Utc.fromMillisSinceEpoch }
green2 = { result: Green, controlResult: defaultControlResult2, performedAt: 123 |> Utc.fromMillisSinceEpoch }
red = { result: Red, controlResult: defaultControlResult, performedAt: 123 |> Utc.fromMillisSinceEpoch }

expect
    scoreTddStep
        green
        red
    == DoNothing

expect
    scoreTddStep
        green
        green
    == DoNothing

expect
    scoreTddStep
        green
        green2
    == DecreaseScore 20
