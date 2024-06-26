app [main] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.10.0/KbIfTNbxShRX1A1FgXei1SpO5Jn8sgP6HP6PXbi-xyA.tar.br",
}

import cli.Stdout
import cli.Task
import Score exposing [scoreSession]
import SessionStorage exposing [loadSessionFromFile, decodeSessionFile]
import Cli exposing [readCliArg]
import cli.Cmd
import Config

main =
    when readCliArg! is
        RunTests -> runTests
        ShowScore -> showScore
        UnknownArg e -> Task.err (StdoutErr (Other e))
        _ -> Task.err (StdoutErr (Other "failed parsing cli arg"))

# for now, must be run from the ./_examples/typescript folder
runTests =
    { testCommand } = Config.loadConfigFromFile!

    when Str.split testCommand " " is
        [cmd, .. as args] ->
            Cmd.new cmd
            |> Cmd.args args
            |> Cmd.status
            |> Task.attempt \result ->
                when result is
                    Ok _ -> Stdout.line "tests are GREEN"
                    Err (CmdError err) ->
                        when err is
                            ExitCode _ -> Stdout.line "tests are RED"
                            KilledBySignal -> Stdout.line "Child was killed by signal"
                            IOError str -> Stdout.line "IOError executing: $(str)"

        _ -> Stdout.line "couldn't parse the test command : $(testCommand)"

showScore =
    result =
        loadSessionFromFile!
            |> decodeSessionFile
            |> Result.map scoreSession

    when result is
        Ok (score, ongoing) -> Stdout.line! "score : $(Num.toStr score), $(if ongoing == Ongoing then "session still ongoing" else "session finished, delete session file to start again")"
        Err e -> Stdout.line! "woops $(Inspect.toStr e)"
