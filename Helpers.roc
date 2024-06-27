module [jsonStrDecode, sessionFilePath, configFilePath]

import json.Json
import cli.Path

jsonStrDecode : Str -> Decode.DecodeResult _
jsonStrDecode = \req -> req
    |> Str.toUtf8
    |> Decode.fromBytesPartial Json.utf8

sessionFilePath = Path.fromStr "./session.json"
configFilePath = Path.fromStr "./tdd.json"
