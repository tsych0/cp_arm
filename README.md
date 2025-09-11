# Competitive Programming in ARM64 Assembly (macOS)

This repository contains solutions to competitive programming problems, primarily from AOJ (Aizu Online Judge), but also from other platforms such as Codeforces, AtCoder, and CSES. All solutions are written in ARM64 assembly language and are intended to run on macOS systems with ARM64 architecture (Apple Silicon).

## Why AOJ?
AOJ provides full public test cases for their problems, making it easier to verify and debug assembly solutions locally. However, problems from other sites may also be solved and included here.

## Repository Structure
- `src/` — Contains all assembly solutions, named according to the problem source and title (see `config.toml` for naming conventions).
- `main.s` — Template/main entry point for assembly programs.
- `fetch_test_cases.py` — Script to fetch AOJ test cases for local testing.
- `config.toml` — Configuration for naming, templates, and workflow toggles.

## Getting Started
1. **Requirements:**
   - macOS with ARM64 (Apple Silicon)
   - `clang` for assembling and linking
   - Python 3 (for test case scripts)
   - [Requests](https://pypi.org/project/requests/) and [tqdm](https://pypi.org/project/tqdm/) Python packages

2. **Building and Running:**
   - Assemble and link an assembly file:
     ```sh
     clang -o a.out src/<problem-file>.s main.s
     ./a.out
     ```
   - Use `fetch_test_cases.py` to download AOJ test cases for local validation.

3. **Workflow:**
   - Write your solution in ARM64 assembly in the `src/` folder.
   - Use the provided template in `main.s` for standard input/output handling.
   - Fetch and test against AOJ cases using the Python script.

## Contributing
Feel free to submit pull requests for new problems, improvements, or bug fixes. Solutions from any competitive programming site are welcome as long as they are in ARM64 assembly.

## License
This repository is open source under the MIT License.
