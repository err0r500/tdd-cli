module [loadSessionFromFile, decodeSessionFile]

import cli.Task
import cli.Path
import cli.Utc
import json.Json
import cli.File
import Score exposing [TddStep]

TddStepDTO : {
    passed : Bool,
    controlResult : {
        passingTestsCount : U8,
        totalTestCount : U8,
    },
    performedAt : I128,
}

tddStepFromJSON : TddStepDTO -> TddStep
tddStepFromJSON = \tddStepDTO -> {
    result: if tddStepDTO.passed then Green else Red,
    controlResult: tddStepDTO.controlResult,
    performedAt: Utc.fromNanosSinceEpoch tddStepDTO.performedAt,
}

loadSessionFromFile =
    handleReadWithDefault = \ct ->
        when ct is
            Err (FileReadErr _ NotFound) -> Task.ok "[]"
            otherwise -> Task.fromResult otherwise

    File.readUtf8 (Path.fromStr "./session.json")
    |> Task.attempt handleReadWithDefault

decodeSessionFile = \sessionFile ->
    decode : Str -> Decode.DecodeResult (List TddStepDTO)
    decode = \req -> Decode.fromBytesPartial (req |> Str.toUtf8) Json.utf8

    decode sessionFile
    |> .result
    |> Result.mapErr (\e -> "err when decoding the session from JSON : $(Inspect.toStr e)")
    |> Result.map (\tddStepDtos -> List.map tddStepDtos tddStepFromJSON)
