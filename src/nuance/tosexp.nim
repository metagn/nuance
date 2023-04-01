import node, std/[tables, strbasics]

type SexpGenerator* = object
  s: string
  files: Table[string, int]

proc addLineInfo*(gen: var SexpGenerator, info: LineInfo) =
  gen.s.add('(')
  gen.s.addInt(gen.files.mgetOrPut(info.filename, gen.files.len))
  gen.s.add(' ')
  gen.s.addInt(info.line)
  gen.s.add(' ')
  gen.s.addInt(info.column)
  gen.s.add(')')

proc addUntypedNode*(gen: var SexpGenerator, node: UntypedNode) =
  gen.s.add('(')
  let nodeStr = $node.kind
  gen.s.add(nodeStr.toOpenArray("nnk".len, nodeStr.len - 1))
  gen.s.add(' ')
  gen.addLineInfo(node.info)
  case node.kind
  of intValNodeKinds:
    gen.s.add(' ')
    gen.s.addInt(node.intVal)
  of uintValNodeKinds:
    gen.s.add(' ')
    gen.s.addInt(node.uintVal)
  of floatValNodeKinds:
    gen.s.add(' ')
    gen.s.addFloat(node.floatVal)
  of strValNodeKinds:
    gen.s.add(' ')
    gen.s.addQuoted(node.strVal)
  else:
    for c in node.children:
      gen.s.add(' ')
      gen.addUntypedNode(c)
  gen.s.add(')')

proc filesToSexp*(filesTable: Table[string, int]): string =
  var files = newSeq[string](filesTable.len)
  for name, id in filesTable:
    files[id] = name
  result = "(files"
  for f in files:
    result.add(' ')
    result.addQuoted(f)
  result.add(')')

proc toSexp*(nodes: seq[UntypedNode]): string =
  var gen: SexpGenerator
  for n in nodes: gen.addUntypedNode(n)
  gen.s.insert(filesToSexp(gen.files), 0)
  gen.s
