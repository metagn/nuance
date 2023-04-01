import node, std/[parseutils, strutils]

type SexpParser* = object
  pos: int
  files: seq[string]

template skip(c: char) =
  assert s[parser.pos] == c
  inc parser.pos

template skip(str: string) =
  assert parser.pos + str.len <= s.len and s[parser.pos ..< parser.pos + str.len] == str
  inc parser.pos, str.len

template skipWhitespace() =
  while parser.pos < s.len and s[parser.pos] in Whitespace:
    inc parser.pos
  assert not (parser.pos < s.len) or s[parser.pos] notin Whitespace

proc parseEscapedString*(s: string, parser: var SexpParser): string =
  skip '"'
  result.add('"')
  var escaped = false
  while parser.pos < s.len:
    let c = s[parser.pos]
    if escaped:
      result.add(c)
      escaped = false
    elif c == '\\':
      escaped = true
    else:
      result.add(c)
      if c == '"':
        return
    inc parser.pos

proc parseString*(s: string, parser: var SexpParser): string =
  result = unescape(parseEscapedString(s, parser))

proc parseInt*(s: string, parser: var SexpParser): int =
  parser.pos += parseInt(s, result, parser.pos)

proc parseBiggestInt*(s: string, parser: var SexpParser): BiggestInt =
  parser.pos += parseBiggestInt(s, result, parser.pos)

proc parseBiggestUint*(s: string, parser: var SexpParser): BiggestUint =
  parser.pos += parseBiggestUint(s, result, parser.pos)

proc parseBiggestFloat*(s: string, parser: var SexpParser): BiggestFloat =
  parser.pos += parseBiggestFloat(s, result, parser.pos)

proc parseLineInfo*(s: string, parser: var SexpParser): LineInfo =
  skip '('
  let fileIndex = parseInt(s, parser)
  result.filename = parser.files[fileIndex]
  skipWhitespace()
  result.line = parseInt(s, parser)
  skipWhitespace()
  result.column = parseInt(s, parser)
  skip ')'

proc parseUntypedNode*(s: string, parser: var SexpParser): UntypedNode =
  skip '('
  var kindStr = "nnk"
  while parser.pos < s.len:
    let c = s[parser.pos]
    if c in {'a'..'z', 'A'..'Z', '0'..'9', '_'}:
      kindStr.add(c)
      inc parser.pos
    else:
      break
  result = UntypedNode(kind: parseEnum[UntypedNodeKind](kindStr))
  skipWhitespace()
  result.info = parseLineInfo(s, parser)
  skipWhitespace()
  case result.kind
  of intValNodeKinds:
    result.intVal = parseBiggestInt(s, parser)
  of uintValNodeKinds:
    result.uintVal = parseBiggestUint(s, parser)
  of floatValNodeKinds:
    result.floatval = parseBiggestFloat(s, parser)
  of strValNodeKinds:
    result.strVal = parseString(s, parser)
    skip '"'
  else:
    while parser.pos < s.len and s[parser.pos] != ')':
      result.children.add(parseUntypedNode(s, parser))
      skipWhitespace()
  skip ')'

proc parseFiles*(s: string, parser: var SexpParser) =
  skip "(files"
  skipWhitespace()
  while parser.pos < s.len and s[parser.pos] != ')':
    parser.files.add(parseString(s, parser))
    skip '"'
    skipWhitespace()
  skip ')'

proc parseSexp*(s: string): seq[UntypedNode] =
  var parser = SexpParser(pos: 0)
  parseFiles(s, parser)
  skipWhitespace()
  while parser.pos < s.len:
    result.add(parseUntypedNode(s, parser))
    skipWhitespace() 
