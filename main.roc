app [main] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.10.0/KbIfTNbxShRX1A1FgXei1SpO5Jn8sgP6HP6PXbi-xyA.tar.br",
}

import cli.Stdout
import cli.Task
import Score exposing [scoreSession]
import Storage exposing [loadSessionFromFile, decodeSessionFile]
import Cli exposing [readCliArg]

main =
    when readCliArg! is
        RunTests -> runTests
        ShowScore -> showScore
        UnknownArg e -> Task.err (StdoutErr (Other e))
        _ -> Task.err (StdoutErr (Other "failed parsing cli arg"))

runTests =
    Stdout.line! "running tests ..."

showScore =
    result =
        loadSessionFromFile!
            |> decodeSessionFile
            |> Result.map scoreSession

    when result is
        Ok (score, ongoing) -> Stdout.line! "score : $(Num.toStr score), $(if ongoing == Ongoing then "session still ongoing" else "session finished, delete session file to start again")"
        Err e -> Stdout.line! "woops $(Inspect.toStr e)"
