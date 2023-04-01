import nuance/node

proc makeTestNodes*(): seq[UntypedNode] =
  const testFilename = "tests/fake.file"
  proc node(kind: UntypedNodeKind, lc: (int, int), val: int): UntypedNode =
    result = UntypedNode(kind: kind, info: LineInfo(filename: testFilename, line: lc[0], column: lc[1]))
    assert kind in intValNodeKinds
    result.intVal = val
  proc node(kind: UntypedNodeKind, lc: (int, int), val: BiggestUint): UntypedNode =
    result = UntypedNode(kind: kind, info: LineInfo(filename: testFilename, line: lc[0], column: lc[1]))
    assert kind in uintValNodeKinds
    result.uintVal = val
  proc node(kind: UntypedNodeKind, lc: (int, int), val: float): UntypedNode =
    result = UntypedNode(kind: kind, info: LineInfo(filename: testFilename, line: lc[0], column: lc[1]))
    assert kind in floatValNodeKinds
    result.floatVal = val
  proc node(kind: UntypedNodeKind, lc: (int, int), val: string): UntypedNode =
    result = UntypedNode(kind: kind, info: LineInfo(filename: testFilename, line: lc[0], column: lc[1]))
    assert kind in strValNodeKinds
    result.strVal = val
  proc node(kind: UntypedNodeKind, lc: (int, int), val: varargs[UntypedNode]): UntypedNode =
    result = UntypedNode(kind: kind, info: LineInfo(filename: testFilename, line: lc[0], column: lc[1]))
    assert kind notin intValNodeKinds + uintValNodeKinds + floatValNodeKinds + strValNodeKinds
    result.children = @val
  #[
  let a = 1
  let b = 2'u
  let c = 3'i8
  let d = 'a'
  let e = 4.0
  let f = "abc"
  proc foo*(x, y: int): int =
    result = x * (a + y)
    return result
  let g = foo(5, 6)
  when (compiles do: export foo):
    export foo
  ]#
  @[
    node(nnkLetSection, (1, 1),
      node(nnkIdentDefs, (1, 5),
        node(nnkIdent, (1, 5), "a"),
        node(nnkEmpty, (0, 0)),
        node(nnkIntLit, (1, 9), 1))),
    node(nnkLetSection, (2, 1),
      node(nnkIdentDefs, (2, 5),
        node(nnkIdent, (2, 5), "b"),
        node(nnkEmpty, (0, 0)),
        node(nnkUIntLit, (2, 9), 2.BiggestUint))),
    node(nnkLetSection, (3, 1),
      node(nnkIdentDefs, (3, 5),
        node(nnkIdent, (3, 5), "c"),
        node(nnkEmpty, (0, 0)),
        node(nnkInt8Lit, (3, 9), 3))),
    node(nnkLetSection, (4, 1),
      node(nnkIdentDefs, (4, 5),
        node(nnkIdent, (4, 5), "d"),
        node(nnkEmpty, (0, 0)),
        node(nnkCharLit, (4, 9), 'a'.int))),
    node(nnkLetSection, (5, 1),
      node(nnkIdentDefs, (5, 5),
        node(nnkIdent, (5, 5), "e"),
        node(nnkEmpty, (0, 0)),
        node(nnkFloatLit, (5, 9), 4.0))),
    node(nnkLetSection, (6, 1),
      node(nnkIdentDefs, (6, 5),
        node(nnkIdent, (6, 5), "f"),
        node(nnkEmpty, (0, 0)),
        node(nnkStrLit, (6, 9), "abc"))),
    node(nnkProcDef, (7, 1),
      node(nnkIdent, (7, 6), "foo"),
      node(nnkEmpty, (0, 0)),
      node(nnkEmpty, (0, 0)),
      node(nnkFormalParams, (7, 9),
        node(nnkIdent, (7, 22), "int"),
        node(nnkIdentDefs, (7, 10),
          node(nnkIdent, (7, 10), "x"),
          node(nnkIdent, (7, 13), "y"),
          node(nnkIdent, (7, 16), "int"),
          node(nnkEmpty, (0, 0)))),
      node(nnkEmpty, (0, 0)),
      node(nnkEmpty, (0, 0)),
      node(nnkStmtList, (7, 27),
        node(nnkAsgn, (8, 10),
          node(nnkIdent, (8, 3), "result"),
          node(nnkInfix, (8, 14),
            node(nnkIdent, (8, 14), "*"),
            node(nnkIdent, (8, 12), "x"),
            node(nnkPar, (8, 16),
              node(nnkInfix, (8, 19),
                node(nnkIdent, (8, 19), "+"),
                node(nnkIdent, (8, 17), "a"),
                node(nnkIdent, (8, 21), "y"))))),
        node(nnkReturnStmt, (9, 2),
          node(nnkIdent, (9, 10), "result")))),
    node(nnkLetSection, (10, 1),
      node(nnkIdentDefs, (10, 5),
        node(nnkIdent, (10, 5), "g"),
        node(nnkEmpty, (0, 0)),
        node(nnkCall, (10, 9),
          node(nnkIdent, (10, 9), "foo"),
          node(nnkIntLit, (10, 13), 5),
          node(nnkIntLit, (10, 16), 6)))),
    node(nnkWhenStmt, (11, 1),
      node(nnkElifBranch, (11, 1),
        node(nnkCall, (11, 7),
          node(nnkIdent, (11, 7), "compiles"),
          node(nnkStmtList, (11, 16),
            node(nnkExportStmt, (11, 20),
              node(nnkIdent, (11, 27), "foo")))),
        node(nnkStmtList, (11, 32),
          node(nnkExportStmt, (12, 3),
            node(nnkIdent, (12, 10), "foo")))))
  ]

const testNodesConst* = makeTestNodes()
when defined(nimscript):
  const testNodes* = testNodesConst
else:
  let testNodes* = makeTestNodes()
