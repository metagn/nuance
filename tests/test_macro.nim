when (compiles do: import nimbleutils/bridge):
  import nimbleutils/bridge
else:
  import unittest

import nuance/comptime, mtest_nodes, macros

test "macro works":
  macro useTestNodes(): untyped =
    result = newStmtList()
    for n in testNodesConst:
      result.add(toNimNode(n))

  useTestNodes()
  check a == 1
  check b == 2'u
  check c == 3'i8
  check d == 'a'
  check e == 4.0
  check f == "abc"
  check g == 35
  check foo(2, 2) == 6
