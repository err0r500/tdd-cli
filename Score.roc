module [scoreTddStep, scoreSession, TddStep, ControlResult]

import cli.Utc

ScoreUpdate : [
    DoNothing,
    DecreaseScore U8,
    IncreaseScore U8,
    EndOfGame U8,
]

ControlResult : {
    passingTestsCount : U8,
    totalTestsCount : U8,
}

TddStep : {
    result : [Red, Green],
    controlResult : ControlResult,
    performedAt : Utc.Utc,
}

scoreTddStep : TddStep, TddStep -> ScoreUpdate
scoreTddStep = \previousStep, currentStep ->
    behaviorChanged = currentStep.controlResult.passingTestsCount != previousStep.controlResult.passingTestsCount
    madeProgresses = currentStep.controlResult.passingTestsCount > previousStep.controlResult.passingTestsCount
    allControlTestsArePassing = currentStep.controlResult.passingTestsCount == currentStep.controlResult.totalTestsCount

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
            onSuccessIncrease = 20 # todo add a bonus if < 30''
            if allControlTestsArePassing then
                EndOfGame onSuccessIncrease
            else if madeProgresses then
                IncreaseScore onSuccessIncrease
            else
                DecreaseScore 10 # no progresses made (or even regression) with a new test

scoreSession : List TddStep -> (I16, [Ongoing, Finished])
scoreSession = \session ->
    List.map2 session (List.dropFirst session 1) scoreTddStep
    |> List.walk
        (0, Ongoing)
        \(currScore, currState), updateInstruction ->
            if currState == Finished then
                (currScore, currState)
            else
                when updateInstruction is
                    DoNothing -> (currScore, Ongoing)
                    EndOfGame x -> (currScore + (Num.toI16 x), Finished)
                    DecreaseScore x -> (currScore - (Num.toI16 x), Ongoing)
                    IncreaseScore x -> (currScore + (Num.toI16 x), Ongoing)
