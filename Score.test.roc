module []

import Score
import cli.Utc

defaultControlResult = { passingTestsCount: 20, totalTestCount: 103 }
defaultControlResult2 = { passingTestsCount: 53, totalTestCount: 103 }
green = { result: Green, controlResult: defaultControlResult, triggeredAt: 123 |> Utc.fromMillisSinceEpoch }
green2 = { result: Green, controlResult: defaultControlResult2, triggeredAt: 123 |> Utc.fromMillisSinceEpoch }
red = { result: Red, controlResult: defaultControlResult, triggeredAt: 123 |> Utc.fromMillisSinceEpoch }

expect
    Score.updateScoreLogic
        green
        red
    == DoNothing

expect
    Score.updateScoreLogic
        green
        green
    == DoNothing

expect
    Score.updateScoreLogic
        green
        green2
    == DecreaseScore 20
