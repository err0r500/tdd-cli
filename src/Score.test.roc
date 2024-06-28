module []

import Score exposing [scoreTddStep, scoreSession]
import cli.Utc

controlResultNoPassing = { passingTestsCount: 0, totalTestsCount: 103 }
controlResultMostPassing = { controlResultNoPassing & passingTestsCount: 83 }
controlResultAllPassing = { controlResultNoPassing & passingTestsCount: 103 }

greenBeginning = { result: Green, controlResult: controlResultNoPassing, performedAt: 123 |> Utc.fromMillisSinceEpoch }
greenMidSession = { greenBeginning & controlResult: controlResultMostPassing }
greenFinished = { greenBeginning & controlResult: controlResultAllPassing }

red = { result: Red, controlResult: controlResultNoPassing, performedAt: 123 |> Utc.fromMillisSinceEpoch }

# scoreTddStep
expect
    scoreTddStep
        greenBeginning
        red
    == DoNothing

expect
    scoreTddStep
        greenBeginning
        greenBeginning
    == DoNothing

expect
    scoreTddStep
        greenBeginning
        greenMidSession
    == DecreaseScore 20

## scoreSession
expect
    scoreSession
        []
    == (0, Ongoing)

expect
    scoreSession
        [greenBeginning]
    == (0, Ongoing)

expect
    scoreSession
        [red, greenMidSession]
    == (20, Ongoing)

expect
    scoreSession
        [red, greenBeginning] # no progress made
    == (-10, Ongoing)

expect
    scoreSession [
        red,
        greenMidSession, # +20
        greenBeginning, # -20 (behavior change on refacto)
    ]
    == (0, Ongoing)

expect
    scoreSession [
        red,
        greenMidSession, # + 20
        red,
        greenFinished, # +20, end
        red,
        red,
    ]
    == (40, Finished) # no update once finished
