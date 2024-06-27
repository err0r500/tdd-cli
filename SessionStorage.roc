module [loadSessionFromFile, decodeSessionFile]

import cli.Task
import cli.Path
import cli.Utc
import cli.File
import Score exposing [TddStep]
import Helpers exposing [jsonStrDecode]

TddStepDTO : {
    passed : Bool,
    controlResult : {
        passingTestsCount : U8,
        totalTestsCount : U8,
    },
    performedAt : I128,
}

tddStepFromJSON : TddStepDTO -> TddStep
tddStepFromJSON = \tddStepDTO -> {
    result: if tddStepDTO.passed then Green else Red,
    controlResult: tddStepDTO.controlResult,
    performedAt: Utc.fromNanosSinceEpoch tddStepDTO.performedAt,
}

defaultSession = "[]"

loadSessionFromFile : Task.Task (Result (List TddStep) _) _
loadSessionFromFile =
    provideDefaultSessionOnNotFound = \readResult ->
        when readResult is
            Err (FileReadErr _ NotFound) -> Task.ok defaultSession
            otherwise -> Task.fromResult otherwise

    File.readUtf8 (Path.fromStr "./session.json")
    |> Task.attempt provideDefaultSessionOnNotFound
    |> Task.map decodeSessionFile

decodeSessionFile = \sessionFileContent ->
    sessionFileContent
    |> jsonStrDecode
    |> .result
    |> Result.mapErr FailedToDecodeSessionJson
    |> Result.map (\tddStepDtos -> List.map tddStepDtos tddStepFromJSON)
