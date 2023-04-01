import macros
export LineInfo, NimNodeKind

const
  intValNodeKinds* = {nnkCharLit..nnkInt64Lit}
  uintValNodeKinds* = {nnkUIntLit..nnkUInt64Lit}
  floatValNodeKinds* = {nnkFloatLit..nnkFloat128Lit}
  strValNodeKinds* = {nnkStrLit..nnkTripleStrLit, nnkIdent, nnkSym} # nnkSym actually not usable 

type
  UntypedNodeKind* = NimNodeKind
  UntypedNode* = object
    info*: LineInfo
    case kind*: UntypedNodeKind
    of intValNodeKinds:
      intVal*: BiggestInt
    of uintValNodeKinds:
      uintVal*: BiggestUint
    of floatValNodeKinds:
      floatVal*: BiggestFloat
    of strValNodeKinds:
      strVal*: string
    else:
      children*: seq[UntypedNode]
