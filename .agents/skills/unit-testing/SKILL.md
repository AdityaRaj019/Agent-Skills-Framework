---
name: unit-testing
description: Guidelines for unit testing, test structures, mocking dependencies, test coverage, assertions, and eliminating flakiness
---
# Instructions

*   **Test Structure (AAA):** Structure test blocks according to the Arrange-Act-Assert pattern:
    *   *Arrange:* Set up mock inputs, mock objects, and environment.
    *   *Act:* Call the target function or method under test.
    *   *Assert:* Verify that the output, states, and mocks are as expected.
*   **Deterministic Isolation (Mocking):** Never perform actual HTTP requests, file system writes, or database queries inside unit tests. Mock all external dependencies (APIs, databases, services) using testing library mocks.
*   **Test Boundaries & Matrices:** Cover the full boundary matrix of inputs:
    *   *Happy Path:* Normal, expected values.
    *   *Error Path:* Invalid inputs, empty values, unexpected types, and handled errors.
    *   *Boundary Values:* Zero, maximum lengths, negative values, and system limits.
*   **Clean Test Lifecycle:** Reset all mocked components before and after each test suite execution using `clearAllMocks`, `resetModules`, or `restoreAllMocks` to keep tests isolated.
*   **Colocated Tests:** Keep test files colocated with the components under test using the `[name].test.ts` or `[name].spec.ts` naming convention.

# Gotchas

*   **Flaky Assertions:** Relying on dynamic states (current time, random IDs, execution order) without mocking them causes tests to fail unpredictably.
*   **Testing Implementation Details:** Writing assertions targeting internal variables or private helper functions makes code refactoring difficult. Test the public interfaces and outputs instead.
*   **Dangling Promises in Tests:** Not returning or awaiting asynchronous operations in test handlers will cause test blocks to pass before assertion checks are processed.

# Validation Loops

1.  **Test Execution:** Run the test suite using local commands (e.g., `npm run test` or `vitest run`).
2.  **Coverage Report Check:** Run a coverage check to ensure the tested components satisfy the minimum project statement, branch, and function coverage thresholds.
3.  **Failure Validation:** Manually modify the target function's business logic to be incorrect and verify that the corresponding tests fail.
