# Package

version       = "0.1.0"
author        = "metagn"
description   = "nim untyped AST node generation with custom line info at runtime"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.12"

when (compiles do: import nimbleutils):
  import nimbleutils

task docs, "build docs for all modules":
  when declared(buildDocs):
    buildDocs(gitUrl = "https://github.com/metagn/nuance")
  else:
    echo "docs task not implemented, need nimbleutils"

task tests, "run tests for multiple backends":
  when declared(runTests):
    runTests(backends = {c, js, nims})
    runTests("tests/generated", backends = {c, js, nims})
  else:
    echo "tests task not implemented, need nimbleutils"
