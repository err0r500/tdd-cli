# TDD cli

## dev notes
### run roc from example folder
```
roc dev ../../main.roc
```

## expected interfaces
### user tests
- exit with 0 when all tests passed,
- exit with 1 when a test failed,

### control tests
```
{
  "passingTestsCount": number,
  "totalTestsCount": number,
}
```


## remarks
### NPM & Jest
- run `npm` & `jest` with the `--silent` flag to minimize the chance of getting a messed up json output

### jq
- run `jq` with the `-c` flag to output on a single line
