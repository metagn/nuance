when (compiles do: import nimbleutils):
  import nimbleutils

when not declared(runTests):
  {.fatal: "tests task not implemented, need nimbleutils".}

runTests(backends = {c, js, nims})
runTests("tests/generated", backends = {c, js, nims})
