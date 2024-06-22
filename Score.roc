module [scoreTddStep]

import cli.Utc

ScoreUpdate : [
    DoNothing,
    DecreaseScore U8,
    IncreaseScore U8,
    EndOfGame,
]

TddStep : {
    result : [Red, Green],
    controlResult : {
        passingTestsCount : U8,
        totalTestCount : U8,
    },
    performedAt : Utc.Utc,
}

scoreTddStep : TddStep, TddStep -> ScoreUpdate
scoreTddStep = \previousStep, currentStep ->
    behaviorChanged = currentStep.controlResult.passingTestsCount != previousStep.controlResult.passingTestsCount
    madeProgresses = currentStep.controlResult.passingTestsCount > previousStep.controlResult.passingTestsCount
    allControlTestsArePassing = currentStep.controlResult.passingTestsCount == currentStep.controlResult.totalTestCount

    when (previousStep.result, currentStep.result) is
        (Green, Green) ->
            if behaviorChanged then
                DecreaseScore 20 # behavior must not change in refacto
            else
                DoNothing # refactoring

        (Green, Red) ->
            DoNothing # starting a new TDD cycle

        (Red, Red) ->
            DecreaseScore 10 # failed twice in a row

        (Red, Green) ->
            if allControlTestsArePassing then
                EndOfGame
            else if madeProgresses then
                IncreaseScore 20 # todo use timer to calculate a bonus if < 30''
            else
                DecreaseScore 10 # no progresses made (or even regression) with a new test
