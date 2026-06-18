# Contributing

## Fork, Branch, and PR Workflow

1. Fork the repository.
2. Create a feature branch from `main`.
3. Commit your changes with a clear message.
4. Push your branch to your fork.
5. Open a Pull Request against `main`.
6. Add a description of your change and link any relevant tests.

## MATLAB Code Style

- Use `function` and `end` blocks consistently.
- Name public properties and methods with `camelCase`.
- Keep line length under 120 characters.
- Use `uint8` for UI image buffers and `double` only for intermediate math.
- Avoid storing large image arrays in local variables across callbacks.
- Document new methods with comments and follow existing patterns.

## Adding New Edge Operators

1. Add a new dropdown item in `SmartPixelProcessor.createComponents`.
2. Add a corresponding branch in `SmartPixelProcessor.detectEdges`.
3. Update `docs/ALGORITHMS.md` with the new operator description.
4. Add tests in `tests/test_SmartPixelProcessor.m` for the new method.

## Running Tests

Run the MATLAB unit tests from the command window:

```matlab
results = runtests('tests');
disp(results);
```

## Submitting Improvements

- Include screenshots for UI changes.
- Verify app behavior after parameter changes.
- Update documentation for any user-facing feature.
