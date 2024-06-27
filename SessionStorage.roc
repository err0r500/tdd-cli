module [loadSessionFromFile, decodeSessionFile, sessionToJsonStr, storeResultsInSession]

import cli.Task
import cli.Path
import cli.Utc
import cli.File
import Score exposing [TddStep]
import Helpers exposing [jsonStrDecode]
import json.Json

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

tddStepToDTO : TddStep -> TddStepDTO
tddStepToDTO = \tddStep -> {
    passed: tddStep.result == Green,
    controlResult: tddStep.controlResult,
    performedAt: Utc.toNanosSinceEpoch tddStep.performedAt,
}

sessionToJsonStr : List TddStep -> List U8
sessionToJsonStr = \session ->
    session
    |> List.map tddStepToDTO
    |> Encode.toBytes Json.utf8

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

storeResultsInSession = \userTestsResult, controlResult ->
    now = Utc.now!
    currentSession =
        loadSessionFromFile!
            |> Result.map
                (\storedSession ->
                    List.append storedSession {
                        result: userTestsResult,
                        controlResult: controlResult,
                        performedAt: now,
                    }
                )

    when currentSession is
        Ok s ->
            File.writeBytes!
                (Path.fromStr "./session.json")
                (s |> sessionToJsonStr)

        Err _ -> Task.err Book
