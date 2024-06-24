app [main] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.10.0/KbIfTNbxShRX1A1FgXei1SpO5Jn8sgP6HP6PXbi-xyA.tar.br",
}

import cli.Stdout
import cli.Task
import Score exposing [scoreSession]
import Storage exposing [loadSessionFromFile, decodeSessionFile]

main =
    session =
        loadSessionFromFile!
            |> decodeSessionFile

    calculateScore =
        session
        |> Result.map scoreSession

    when calculateScore is
        Ok (score, _) -> Stdout.line! "score : $(Num.toStr score)"
        Err e -> Stdout.line! "woops $(Inspect.toStr e)"
