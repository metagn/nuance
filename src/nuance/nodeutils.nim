import node

proc `==`*(a, b: UntypedNode): bool =
  if a.kind != b.kind: return false
  if a.info != b.info: return false
  case a.kind
  of intValNodeKinds:
    a.intVal == b.intVal
  of uintValNodeKinds:
    a.uintVal == b.uintVal
  of floatValNodeKinds:
    a.floatVal == b.floatVal
  of strValNodeKinds:
    a.strVal == b.strVal
  else:
    a.children == b.children
