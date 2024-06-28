module [loadConfigFromFile]

import cli.Task
import cli.File
import Helpers exposing [jsonStrDecode, configFilePath]

Config : {
    testCommand : Str,
    controlCommand : Str,
}

loadConfigFromFile : Task.Task Config _
loadConfigFromFile =
    decodeJson = \req ->
        req
        |> jsonStrDecode
        |> .result
        |> Task.fromResult

    File.readUtf8 configFilePath
    |> Task.attempt
        (\fileReading ->
            when fileReading is
                Ok content ->
                    content
                    |> decodeJson
                    |> Task.mapErr ConfigDecodeError

                Err e -> Task.err (FileReadError e)
        )
