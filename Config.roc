module [loadConfigFromFile]

import cli.Task
import cli.Path
import json.Json
import cli.File

Config : {
    testCommand : Str,
    controlCommand : Str,
}

loadConfigFromFile : Task.Task Config [ConfDecodeError DecodeError, FileReadError _]
loadConfigFromFile =
    decodeJson = \req ->
        req
        |> Str.toUtf8
        |> Decode.fromBytesPartial Json.utf8
        |> .result
        |> Task.fromResult

    File.readUtf8 (Path.fromStr "./tdd.json")
    |> Task.attempt
        (\fileReading ->
            when fileReading is
                Ok content -> content |> decodeJson |> Task.mapErr ConfDecodeError
                Err e -> Task.err (FileReadError e)
        )
