import { validateIBAN } from "./src/main";

test.each([
  ["", false],
  [" ", false],
  ["0000000000000", true],
  ["0000000-000000", true],
  ["000-0000-000000", true],
  ["000 0000000000", true],
  ["000 0000 000000", true],
  ["000-0000 000000", true],
  ["000-0000 000000  - -  ", true],
])(".validateIBAN(%s)", (a, expected) => {
  expect(validateIBAN(a)).toBe(expected);
});
