module [jsonStrDecode]

import json.Json

jsonStrDecode : Str -> Decode.DecodeResult _
jsonStrDecode = \req -> req
    |> Str.toUtf8
    |> Decode.fromBytesPartial Json.utf8
