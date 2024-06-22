module [updateScoreLogic]

import cli.Utc

ScoreUpdate : [
    DoNothing,
    DecreaseScore U8,
    IncreaseScore U8,
    EndOfGame,
]

TddCycleRun : {
    result : [Red, Green],
    controlResult : {
        passingTestsCount : U8,
        totalTestCount : U8,
    },
    triggeredAt : Utc.Utc,
}

updateScoreLogic : TddCycleRun, TddCycleRun -> ScoreUpdate
updateScoreLogic = \previousRun, currentRun ->
    when (previousRun.result, currentRun.result) is
        (Green, Green) ->
            if currentRun.controlResult.passingTestsCount != previousRun.controlResult.passingTestsCount then
                DecreaseScore 20 # behavior changed during refacto
            else
                DoNothing

        (Green, Red) -> DoNothing
        (Red, Red) -> DecreaseScore 10 # failed twice
        (Red, Green) ->
            if currentRun.controlResult.passingTestsCount > previousRun.controlResult.passingTestsCount then
                if currentRun.controlResult.passingTestsCount == currentRun.controlResult.totalTestCount then
                    EndOfGame
                else
                    IncreaseScore 20 # todo use timer to calculate a bonus if < 30''
            else
                DecreaseScore 10 # no progression in logic (or even regression)
