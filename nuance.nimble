# Package

version       = "0.1.0"
author        = "metagn"
description   = "nim untyped AST node generation at runtime with custom line info"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.12"

task docs, "build docs for all modules":
  exec "nim r tasks/build_docs.nim"

task tests, "run tests for multiple backends":
  exec "nim r tasks/run_tests.nim"
