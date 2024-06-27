import { validateIBAN } from "./main";

describe("hello", () => {
  it("is not an empty string", () => {
    expect(validateIBAN("")).toBeFalsy();
  });
  it("is not an empty string (2)", () => {
    expect(validateIBAN("")).toBeTruthy();
  });
});

describe("hello", () => {
  it("is not an empty string", () => {
    expect(validateIBAN("")).toBeFalsy();
  });
  it("is not an empty string (2)", () => {
    expect(validateIBAN("")).toBeTruthy();
  });
});
