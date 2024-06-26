import { validateIBAN } from "./main";

describe("hello", () => {
  it("is not an empty string", () => {
    expect(validateIBAN("")).toBeFalsy();
  });
});
