import node, macros

proc fromNimNode*(node: NimNode): UntypedNode {.compileTime.} =
  case node.kind
  of intValNodeKinds:
    result = UntypedNode(kind: node.kind)
    result.intVal = node.intVal
  of uintValNodeKinds:
    result = UntypedNode(kind: node.kind)
    result.uintVal = cast[BiggestUint](node.intVal)
  of floatValNodeKinds:
    result = UntypedNode(kind: node.kind)
    result.floatVal = node.floatVal
  of strValNodeKinds:
    if node.kind == nnkSym:
      warning("`nnkSym` nodes will not preserve their data when converted to untyped nodes", node)
    result = UntypedNode(kind: node.kind)
    result.strVal = node.strVal
  else:
    result = UntypedNode(kind: node.kind)
    for c in node.children:
      result.children.add(fromNimNode(c))
  result.info = node.lineInfoObj

proc toNimNode*(node: UntypedNode): NimNode {.compileTime.} =
  case node.kind
  of intValNodeKinds:
    result = newNimNode(node.kind)
    result.intVal = node.intVal
  of uintValNodeKinds:
    result = newNimNode(node.kind)
    result.intVal = cast[BiggestInt](node.uintVal)
  of floatValNodeKinds:
    result = newNimNode(node.kind)
    result.floatVal = node.floatVal
  of strValNodeKinds - {nnkIdent, nnkSym}:
    result = newNimNode(node.kind)
    result.strVal = node.strVal
  of nnkIdent:
    result = ident(node.strVal)
  of nnkSym:
    error("cannot create untyped symbol node")
  else:
    result = newNimNode(node.kind)
    for c in node.children:
      result.add(toNimNode(c))
  when declared(setLineInfo):
    result.setLineInfo(node.info)
  else:
    {.warning: "`macros.setLineInfo` is not declared, untyped nodes will not " &
      "persist their line info, use nim version 1.6.12 or above".}

macro load*(node: static UntypedNode): untyped =
  result = toNimNode(node)

macro load*(nodes: static seq[UntypedNode]): untyped =
  result = newStmtList()
  for n in nodes: result.add(toNimNode(n))
