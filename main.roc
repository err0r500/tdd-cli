app [main] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.10.0/KbIfTNbxShRX1A1FgXei1SpO5Jn8sgP6HP6PXbi-xyA.tar.br",
}

import cli.Stdout
import cli.Task
import Score exposing [scoreSession]
import SessionStorage exposing [loadSessionFromFile, storeResultsInSession]
import Cli exposing [readCliArg]
import Commands exposing [runUserTests, runControlTests]
import Config
import cli.Arg

main =
    cmd = readCliArg! Arg.list!
    when cmd is
        RunTests -> runTests
        ShowScore -> showScore
        UnknownArg e -> Task.err (StdoutErr (Other e))
        _ -> Task.err (StdoutErr (Other "failed parsing cli arg"))

runTests =
    { testCommand, controlCommand } = Config.loadConfigFromFile!
    userTestsResult = runUserTests! testCommand
    controlResult = runControlTests! controlCommand
    storeResultsInSession userTestsResult controlResult

showScore =
    formatResult = \score, ongoing ->
        "score : $(Num.toStr score), $(if ongoing == Ongoing then "session still ongoing" else "session finished, delete session.json file to start again")"

    result =
        loadSessionFromFile!
            |> Result.map scoreSession

    when result is
        Ok (score, ongoing) -> formatResult score ongoing |> Stdout.line!
        Err e -> Stdout.line! "woops $(Inspect.toStr e)"
