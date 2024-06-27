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
    allControlTestsArePassing = currentStep.controlResult.passingTestsCount == currentStep.controlResult.totalTestsCount

    when (previousStep.result, currentStep.result) is
        (Green, Green) ->
            if behaviorChanged then
                # behavior must not change during refactoring
                DecreaseScore 20
            else
                DoNothing

        (Green, Red) ->
            # starting a new TDD cycle
            DoNothing

        (Red, Red) ->
            # failed twice in a row
            DecreaseScore 10

        (Red, Green) ->
            onSuccessIncrease = 20 # todo add a bonus if < 30''
            if allControlTestsArePassing then
                EndOfGame onSuccessIncrease
            else if behaviorChanged then
                # we don't care if more tests are passing, just that things keep moving
                IncreaseScore onSuccessIncrease
            else
                # no progress made with a new test
                DecreaseScore 10

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
