# Writing a Julia Package

In Julia, packages are the natural medium for code that doesn't fit in a simple script or notebook.
While this might sound excessive at first, it provides many conveniences.
This page serves as a guide for creating your first Julia package. 

!!! warning
    This page assumes you followed the [*"Setting up a Julia package"*](/setup) page.

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents


## Julia VSCode extension

In combination with the [Julia extension](https://www.julia-vscode.org/), 
VSCode is the most commonly recommended editor for development in Julia. 
It provides several features and shortcuts that make package development convenient:

* [keyboard shortcuts](https://www.julia-vscode.org/docs/stable/userguide/keybindings/)
* [debugging](/debugging) with breakpoints
* code completion
* code formatting
* run code (or only sections of the code)
* view *"workspace"* of global variables
* view documentation
* view plots

This guide will assume that you are using VSCode with the Julia extension.
Julia plugins for [Vim](https://github.com/JuliaEditorSupport/julia-vim) and [Emacs](https://github.com/JuliaEditorSupport/julia-emacs) exist as well but will not be covered.

!!! tip
    [VSCodium](https://vscodium.com) is a free/libre fork of VSCode.

## Interactive development

### Starting a REPL session with VSCode

Julia developers usually have an interactive REPL session open while writing their source code.
To be able to interact with the code that you are writing, you first have to activate the environment of your project.

You could manually open a terminal, start a Julia REPL, activate Pkg mode and type `activate .`, but the Julia VSCode extension provides a keyboard shortcut for this!

Typing `Alt+j Alt+o` (`option+j option+o` on macOS) opens a Julia REPL and directly activates your local environment:

```julia-repl
julia> # type ] to see which environment is active...

(MyPackage) pkg> # ... it's your project environment!
```

If this doesn't work on the first try, you might have to manually select your *"Julia env"* in the bottom bar of VSCode once.

### Starting a REPL without VSCode

To start a REPL and activate your local environment,
launch Julia with the flag `--project`. The Julia banner can be hidden via `--banner=no`.

```bash
$ cd ~/.julia/dev/MyProject  # make sure you're in the right folder

$ julia --project --banner=no
```

!!! tip
    If you are using an editor other than VSCode, set a shell alias for `julia --project --banner=no`.

## Package environments

!!! tip
    Make sure to read the [page on environments](/environments) first!

### Adding package dependencies

Now that our package environment is activated, let's add a dependency to it, e.g. CSV.jl:

```julia-repl
(MyPackage) pkg> add CSV
   Resolving package versions...
    Updating `~/.julia/dev/MyTest1234/Project.toml`
  [336ed68f] + CSV v0.10.14
    Updating `~/.julia/dev/MyTest1234/Manifest.toml`
  [336ed68f] + CSV v0.10.14
  [944b1d66] + CodecZlib v0.7.4
  [34da2185] + Compat v4.15.0
  [9a962f9c] + DataAPI v1.16.0
  [e2d170a0] + DataValueInterfaces v1.0.0
  [48062228] + FilePathsBase v0.9.21
  [842dd82b] + InlineStrings v1.4.0
  [82899510] + IteratorInterfaceExtensions v1.0.0
  [bac558e1] + OrderedCollections v1.6.3
  [69de0a69] + Parsers v2.8.1
  ...
```

When adding a package, the `Project.toml` of our package will automatically be updated.
It is always located in the root folder of the package
(in our example at `~/.julia/dev/MyPackage/Project.toml`).
After adding CSV.jl, the `Project.toml` contains:

```toml
name = "MyPackage"
uuid = "c97c58cb-c2b5-45a4-93b4-32bd8ab523c1"
authors = ["Adrian Hill <git@adrianhill.de> and contributors"]
version = "1.0.0-DEV"

[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"

[compat]
julia = "1.11"
```

* our package has a name, a unique identifier called a UUID, a version number and information
  about the package author
* adding CSV.jl created an entry in the dependency section `[deps]`
* there is a new `[compat]` section to specify package compatibility bounds
   * our package is compatible with Julia versions $\ge$ `1.11` (and smaller than `2.0`) 
   * compat entries for external packages like CSV.jl have to be added manually

!!! tip
    When looking at a new package, checking out its dependencies in the `Project.toml` is a good starting point.

### Semantic Versioning
It is good practice (and required for package registration) 
to enter `[compat]` entries for all dependencies.
This allows us to update dependencies without having to worry about our code breaking.

By convention, Julia packages are expected to follow
[Semantic Versioning](https://semver.org/lang/de/) to specify version numbers:

> Given a version number MAJOR.MINOR.PATCH, increment the:
> 1. MAJOR version when you make incompatible API changes
> 1. MINOR version when you add functionality in a backward compatible manner
> 1. PATCH version when you make backward compatible bug fixes
> 1. Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

> Major version zero (0.y.z) is for initial development.
> Anything MAY change at any time. The public API SHOULD NOT be considered stable.

Let's add a compat entry for CSV.jl. Using `status` in Pkg-mode, we can inspect the current version:
```julia-repl
(MyPackage) pkg> status
Project MyPackage v1.0.0-DEV
Status `~/.julia/dev/MyPackage/Project.toml`
  [336ed68f] CSV v0.10.14
``` 

Since CSV.jl is still in major version zero, a `0.11` release could contain breaking changes.
Let's declare in the `Project.toml` that only versions `0.10.X` of CSV.jl are permitted.
This will allow us to get updates that patch bugs, but not updates that are potentially breaking.

```toml
[compat]
CSV = "0.10"  # <-- manually added to Project.toml
julia = "1.11"
```

## The source folder
By convention, the "main" file of your source code has the same name as the project, in our case `src/MyPackage.jl`.
PkgTemplates already created this file for us, which defines an empty module of the same name: 

```julia
module MyPackage

# Write your package code here.

end # end module
```

!!! tip
    When looking at the source code of a package, this file should be the first one you read.

Let's add a simple function `timestwo` to our package:

```julia
# New contents of src/MyPackage.jl
module MyPackage

timestwo(x) = 2 * x

export timestwo  # only exported functions from a module are available without namespacing

end # end module
```

In an open REPL, you can directly use all **exported** functions:


```julia-repl
julia> using MyPackage

julia> timestwo(3.0)
6.0
```

When we modify our source code, our REPL will automatically reload it, allowing us to develop our package interactively!  



### Organizing dependencies, source files and exports

Once your project grows, you will want to use functions from dependencies 
and organize your code by splitting it into smaller source files.

It is recommended to explicitly import the functions you need from your dependencies.
If you only need the `cholesky` function from LinearAlgebra.jl, don't just write `using LinearAlgebra` as it will import all functions exported by LinearAlgebra. Instead, specify `using LinearAlgebra: cholesky`.

To add separate source files, call `include` with the relative path to a source file, e.g. `include("timestwo.jl")` for `src/timestwo.jl`:

```julia
module MyPackage

# 1.) Explicitly import the functions you need from your dependencies
using LinearAlgebra: cholesky 

# 2.) Include source files
include("timestwo.jl")
include("timesthree.jl")

# 3.) Export functions you defined
export timestwo, timesthree

end # end module
```

## Further reading
- [*Modern Julia Workflows* on writing code](https://modernjuliaworkflows.github.io/writing/)
