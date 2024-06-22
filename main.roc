app [main] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br" }

import cli.Stdout
import cli.Task

main =
    Stdout.line! "I'm a Roc application!"
