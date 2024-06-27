module [controlResultToStr, runUserTests, runControlTests]

import cli.Task
import cli.Cmd
import Score
import json.Json

controlResultToStr = \controlResult ->
    "progress made: "
    |> Str.concat (controlResult.passingTestsCount |> Num.toStr)
    |> Str.concat "/"
    |> Str.concat (controlResult.totalTestsCount |> Num.toStr)
    |> Str.concat " (passing/total)"

runControlTests : Str -> Task.Task Score.ControlResult _
runControlTests = \controlCommand ->
    parseOutput = \cmdOutput ->
        when cmdOutput is
            Ok { stdout } ->
                stdout
                |> Decode.fromBytesPartial Json.utf8
                |> .result
                |> Result.mapErr (\x -> JSONDecodeErr x (Str.fromUtf8 stdout))
                |> Task.fromResult

            Err e -> Task.err (CmdError e)

    when Str.split controlCommand " " is
        [cmd, .. as args] ->
            Cmd.new cmd
                |> Cmd.args args
                |> Cmd.output
                |> Task.attempt! parseOutput

        _ ->
            Task.err (FailedToParseControlTestsCommand controlCommand)

runUserTests = \testCommand ->
    exitCodeToGreenRed = \exitCode ->
        when exitCode is
            Ok _ ->
                Task.ok Green

            Err (CmdError _) ->
                Task.ok Red

    when Str.split testCommand " " is
        [cmd, .. as args] ->
            Cmd.new cmd
            |> Cmd.args args
            |> Cmd.status
            |> Task.attempt exitCodeToGreenRed

        _ ->
            Task.err (FailedToParseTestCommand testCommand)
