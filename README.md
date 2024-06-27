# TDD cli

This project aims to gamify a TDD session by scoring it. Invoke the CLI to run your tests, it will score your move a store it locally until your kata is complete.

You can always see your current score using the `--score` flag.

Your TDD session is stored in the `./session.json` file, delete it to start a fresh session.

## Set up your project
The CLI looks for a `tdd.json` file in your current folder.

It must look like this :
```json
{
  "testCommand": "<the command to invoke to run your tests>",
  "controlCommand": "<the command to invoke to check your progresses>"
}
```
you can have a look at the [typescript example](./_examples/typescript)

### user tests command
- exit with 0 when all tests passed,
- exit with 1 when a test failed,

### control tests command
```
{
  "passingTestsCount": number,
  "totalTestsCount": number,
}
```

## Tips
### NPM & Jest
- run `npm` & `jest` with the `--silent` flag to minimize the chance of getting a messed up json output

### jq
- run `jq` with the `-c` flag to output on a single line

---

## dev notes
### run roc from example folder
```
roc dev ../../main.roc
```
