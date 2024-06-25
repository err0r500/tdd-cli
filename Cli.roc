module [readCliArg]

import cli.Arg
import cli.Task

readCliArg =
    args = Arg.list!

    parsed =
        if List.len args <= 1 then
            Ok RunTests
        else
            args
            |> List.get 1
            |> Result.mapErr (\_ -> CliArgParsingFailed)
            |> Result.try
                (\arg ->
                    when arg is
                        "--run" -> Ok RunTests
                        "--score" | "-s" -> Ok ShowScore
                        e -> Err (UnknownArg "unknown argument \"$(e)\", try --run or --score")
                )

    parsed
    |> Task.fromResult
