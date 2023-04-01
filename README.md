# nuance

A way to generate untyped Nim AST with custom line info at either runtime or
compile time and use it as regular Nim code later, without having to interface with the Nim compiler.

Note that the custom line/file info support is only possible because of the [macros.setLineInfo proc](https://github.com/nim-lang/Nim/pull/21153) which exists in Nim version 1.6.12 or higher, meaning custom line information will not persist on older versions.

An example pipeline is:

1. Nim program (templating engine, alternative parser etc) generates untyped Nim AST in the form of a runtime-accessible type (currently `nuance/node.UntypedNode`) potentially with custom line/file information
2. A Nim file is generated along with this AST in its serialized form (currently an S-expression format) either inside the Nim file or in an external file that is later read by this Nim file
3. The generated Nim file has code that deserializes this AST and converts it into Nim AST at compile time and immediately loads it using a macro
4. This file is compiled by Nim with compiler messages and stack traces all referring to the given custom line/file info

The reasons this library is needed in these steps are:

- The `NimNode` type provided by Nim used to represent AST nodes is only available at compile time, this library provides a version that is available at runtime for runtime AST generation
  - You could do this with the `PNode` type in the compiler, but invoking the compiler would be very expensive among many other concerns
  - You could also generate all AST at compile time but the compile time VM is limited and there can be a massive performance difference compared to runtime based on what you are doing (although the deserialization step still runs at compile time)
    - For the record you can still generate AST at compile time with this library, you just don't have to
- Code to serialize and then deserialize the AST nodes is provided
  - Again you could interface with the compiler, either in a way where the compiler directly deserializes the AST (rather than it being deserialized in the compile time macro code of the generated file) or the compiler directly calls your library and uses the AST it gives, but this is not feasible without changes to the compiler and complicates the installation process whereas this is designed to work with Nimble packages

This library is tested on the C, JavaScript and NimScript (compile-time VM) backends to ensure everything related to the generation, serialization and deserialization of AST is consistent as well as the generated code for each combination of backends.

The name of the library fits in a lot of ways but for the sake of being memorable a mnemonic might be "Nim untyped AST no compiler edit/compiletime execution". This is slightly misleading but you can just read above for what it actually does.

This is a very early version of this library and there are many things to even get started on:

- [ ] Docs
- [ ] Good names and more thought out modularization
- [ ] Real use case example
- [ ] Binary serialization option
- [ ] See if Nim errors/stack traces are actually informative

For now see the tests for example uses (running them generates some files which might give more of an idea).
