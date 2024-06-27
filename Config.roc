module [loadConfigFromFile]

import cli.Task
import cli.Path
import cli.File
import Helpers exposing [jsonStrDecode]

Config : {
    testCommand : Str,
    controlCommand : Str,
}

loadConfigFromFile : Task.Task Config [ConfDecodeError DecodeError, FileReadError _]
loadConfigFromFile =
    decodeJson = \req ->
        req
        |> jsonStrDecode
        |> .result
        |> Task.fromResult

    File.readUtf8 (Path.fromStr "./tdd.json")
    |> Task.attempt
        (\fileReading ->
            when fileReading is
                Ok content -> content |> decodeJson |> Task.mapErr ConfDecodeError
                Err e -> Task.err (FileReadError e)
        )
