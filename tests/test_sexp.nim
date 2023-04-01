when (compiles do: import nimbleutils/bridge):
  import nimbleutils/bridge
else:
  import unittest

import nuance/[nodeutils, fromsexp, tosexp], mtest_nodes

# complains nodeutils is not used even though it is
template moduleUsed(n: typed) = discard
moduleUsed(nodeutils)

test "round trip":
  let sexp = toSexp(testNodes)
  checkpoint sexp
  check parseSexp(sexp) == testNodes
