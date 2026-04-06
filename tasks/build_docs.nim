when (compiles do: import nimbleutils):
  import nimbleutils

when not declared(buildDocs):
  {.fatal: "docs task not implemented, need nimbleutils".}

buildDocs(gitUrl = "https://github.com/metagn/nuance")
