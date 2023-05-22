@def title = "Julia programming for Machine Learning"
@def tags = ["index", "workflows"]

# Lesson 8: Workflows
Learning a programming language doesn't only require learning new syntax, 
but also getting proficient with new tools, 
an aspect of programming education that is [often overlooked](https://missing.csail.mit.edu/).
After having only worked in Pluto notebooks so far, 
we will now take a look at alternative workflows. 

For this purpose, we will first cover the Julia package manager **Pkg**, 
which allows us to write reproducible code.
We will then move on to a REPL-based workflow that works with all editors.
Julia developers commonly have an interactive REPL session running while working on their code.

We will then introduce the structure of a Julia package by generating an empty package
with [PkgTemplates.jl](https://github.com/JuliaCI/PkgTemplates.jl)
and showcase the VSCode IDE with the [Julia extension](https://www.julia-vscode.org/).
Finally, we will demonstrate [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl),
a template and "assistant" for scientific experiments, 
and demonstrate how to run Julia programs from the command-line.

These workflows should empower you to write homework,  projects and even your thesis in Julia!

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

~~~
<div class="admonition warning">
  <p class="admonition-title">Warning</p>
  <p>Unlike previous lectures, these notes are currently not designed as stand-alone content,
  but to accompany a live demonstration in the 
  <i>Julia programming for Machine Learning</i> class at TU Berlin.</p>
</div>
~~~

## The Julia package manager
We have already encountered Julia's package manager **Pkg** during the installation of Pluto.
In the Julia REPL, Pkg can be opened by typing a closing square bracket `]`.

Depending on your installed version of Julia, the prompt should change from `julia>`
to `(@1.8) pkg>`:

```julia-repl
julia> # Default Julia-mode. Type ] to enter Pkg-mode.

(@v1.8) pkg> # Prompt changes to indicate Pkg-mode

```

To exit the package-manage mode, press backspace.
The name in parenthesis, here `@v1.8`, is the name of the currently activated environment.
`@v1.8` is the global environment of our Julia 1.8 installation.

By typing `status` in Pkg-mode, we can print a list of installed packages:

```julia-repl
(@v1.8) pkg> status
Status `~/.julia/environments/v1.8/Project.toml`
  [5fb14364] OhMyREPL v0.5.20
  [295af30f] Revise v3.5.2
```

In my case, two packages are installed in the `@v1.8` environment.

Let's take a look at the indicated folder `~/.julia/environments/v1.8`
in a new shell session.
It contains two files: a `Project.toml` and a `Manifest.toml`.

```bash
$ cd ~/.julia/environments/v1.8

$ ls
Manifest.toml Project.toml
```

These two files define virtual environments.

### Virtual environments
Let's first take a look at the `Project.toml`.
In the case of our environment, it just  contains a list of installed packages 
with *"universally unique identifiers"* (UUIDs).

```
$ cat Project.toml
───────┬───────────────────────────────────────────────────────────────────────────────
       │ File: Project.toml
───────┼───────────────────────────────────────────────────────────────────────────────
   1   │ [deps]
   2   │ OhMyREPL = "5fb14364-9ced-5910-84b2-373655c76a03"
   3   │ Revise = "295af30f-e4ad-537b-8983-00126c2a3abe"
───────┴───────────────────────────────────────────────────────────────────────────────
```

As we will see in the following sections, the `Project.toml` contains more information when used in packages.

The `Manifest.toml` is a much longer file. It lists all packages in the dependency tree.
For packages that are not part of Julia Base, Git tree hashes and versions are specified.

**This makes our environment fully reproducible!**

```
$ cat Manifest.toml
───────┬───────────────────────────────────────────────────────────────────────────────
       │ File: Manifest.toml
───────┼───────────────────────────────────────────────────────────────────────────────
   1   │ # This file is machine-generated - editing it directly is not advised
   2   │
   3   │ julia_version = "1.8.5"
   4   │ manifest_format = "2.0"
   5   │ project_hash = "e9cf4d3c4e1f72eba6aa88164f23d06c005b9b9b"
   6   │
   7   │ [[deps.ArgTools]]
   8   │ uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
   9   │ version = "1.1.1"
  10   │
  11   │ [[deps.Artifacts]]
  12   │ uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
  13   │
  14   │ [[deps.Base64]]
  15   │ uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
  16   │
  17   │ [[deps.CodeTracking]]
  18   │ deps = ["InteractiveUtils", "UUIDs"]
  19   │ git-tree-sha1 = "d730914ef30a06732bdd9f763f6cc32e92ffbff1"
  20   │ uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
  21   │ version = "1.3.1"
  22   │
  23   │ [[deps.Crayons]]
  24   │ git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
  25   │ uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
  26   │ version = "4.1.1"
  ...
```
Each virtual environment we create adds a folder to `~/.julia/environments`
that contains a `Project.toml` and a `Manifest.toml`.

~~~
<div class="admonition note">
  <p class="admonition-title">Reproducibility</p>
  <p>The pair of <code>Project.toml</code> and <code>Manifest.toml</code> 
  make our environment fully reproducible, which is important for scientific experiments.</p>
</div>
~~~

### Creating a new virtal environment
To create a new environment, enter Pkg-mode in the Julia REPL and type `activate`
followed by the name of your new environment:

```julia-repl
(@v1.8) pkg> activate MyTest # create new environment called  "MyTest"
  Activating new project at `~/.julia/environments/v1.8/MyTest`

(@MyTest) pkg> # environment is active
```

This creates a new folder at `~/.julia/environments/v1.8/MyTest` 
containing a `Project.toml` and `Manifest.toml`.
Adding packages to this environment will update both of these files:

```julia-repl
(@MyTest) pkg> add LinearAlgebra
   Resolving package versions...
    Updating `~/.julia/environments/v1.8/MyTest/Project.toml`
  [37e2e46d] + LinearAlgebra
    Updating `~/.julia/environments/v1.8/MyTest/Manifest.toml`
  [56f22d72] + Artifacts
  [8f399da3] + Libdl
  [37e2e46d] + LinearAlgebra
  [e66e0078] + CompilerSupportLibraries_jll v1.0.1+0
  [4536629a] + OpenBLAS_jll v0.3.20+0
  [8e850b90] + libblastrampoline_jll v5.1.1+0

```

### Temporary environments
If you want to try an interesting new package you've seen on GitHub,
the package manager offers a simple way to start a temporary virtual enviroment.

In your Julia REPL, enter package mode and type `activate --temp`.
This will create an environment with a randomized name in a temporary folder.

```julia-repl
(@v1.8) pkg> activate --temp
  Activating new project at `/var/folders/74/wcz8c9qs5dzc8wgkk7839k5c0000gn/T/jl_9AGcg1`

(jl_9AGcg1) pkg>
```

### Virtual environments in Pluto
Pluto notebooks also contain reproducible virtual environments.
Let's take a look at a notebook called `empty_pluto.jl`
that just contains a cell declaring `using LinearAlgebra`.

We can see that
- A variable called `PLUTO_PROJECT_TOML_CONTENTS` holds the `Project.toml` information.
- A variable called `PLUTO_MANIFEST_TOML_CONTENTS` holds the `Manifest.toml` information.
- Cells are annotated by a comment `# ╔═╡ some-uuid`.
- The ordering of cells is given in a comment `# ╔═╡ Cell order:` at the end of the file.

Pluto notebooks are therefore fully reproducible and also regular Julia files!

```
$ cat empty_pluto.jl
───────┬───────────────────────────────────────────────────────────────────────────────
       │ File: empty_pluto.jl
───────┼───────────────────────────────────────────────────────────────────────────────
   1   │ ### A Pluto.jl notebook ###
   2   │ # v0.19.25
   3   │
   4   │ using Markdown
   5   │ using InteractiveUtils
   6   │
   7   │ # ╔═╡ 9842a4f5-69d1-4566-b605-49d5c6679b4a
   8   │ using LinearAlgebra
   9   │
  10   │ # ╔═╡ 00000000-0000-0000-0000-000000000001
  11   │ PLUTO_PROJECT_TOML_CONTENTS = """
  12   │ [deps]
  13   │ LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
  14   │ """
  15   │
  16   │ # ╔═╡ 00000000-0000-0000-0000-000000000002
  17   │ PLUTO_MANIFEST_TOML_CONTENTS = """
  18   │ # This file is machine-generated - editing it directly is not advised
  19   │
  20   │ julia_version = "1.8.5"
  21   │ manifest_format = "2.0"
  22   │ project_hash = "ac1187e548c6ab173ac57d4e72da1620216bce54"
  23   │
  24   │ [[deps.Artifacts]]
  25   │ uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
  26   │
  27   │ [[deps.CompilerSupportLibraries_jll]]
  28   │ deps = ["Artifacts", "Libdl"]
  29   │ uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
  30   │ version = "1.0.1+0"
  31   │
  32   │ [[deps.Libdl]]
  33   │ uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
  34   │
  35   │ [[deps.LinearAlgebra]]
  36   │ deps = ["Libdl", "libblastrampoline_jll"]
  37   │ uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
  38   │
  39   │ [[deps.OpenBLAS_jll]]
  40   │ deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
  41   │ uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
  42   │ version = "0.3.20+0"
  43   │
  44   │ [[deps.libblastrampoline_jll]]
  45   │ deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
  46   │ uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
  47   │ version = "5.1.1+0"
  48   │ """
  49   │
  50   │ # ╔═╡ Cell order:
  51   │ # ╠═9842a4f5-69d1-4566-b605-49d5c6679b4a
  52   │ # ╟─00000000-0000-0000-0000-000000000001
  53   │ # ╟─00000000-0000-0000-0000-000000000002
───────┴───────────────────────────────────────────────────────────────────────────────
```


## REPL-based workflows
The most basic workflow uses the Julia REPL in combination with your favorite editor.

### Enhancing the REPL experience


#### `startup.jl`
If you have code that you want to be run every time you start Julia, 
add it to your [startup file](https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file)
that is located at `~/.julia/config/startup.jl`.
Note that you might have to first create this config folder.

A common use-case for the `startup.jl` to load packages that are crucial for your workflow. 

#### Revise.jl
[Revise.jl](https://github.com/timholy/Revise.jl) will reload modified Julia code
without having to restart Julia.
```julia
# First lines of ~/.julia/config/startup.jl
try
    using Revise
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end
```

#### OhMyRepl.jl
[OhMyRepl](https://github.com/KristofferC/OhMyREPL.jl) adds many features to your REPL,
amongst other things:
- syntax highlighting
- (rainbow) bracket highlighting
- fuzzy history search
- stripping prompts from pasted code

```julia
# Add to ~/.julia/config/startup.jl
atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "Error initializing OhMyRepl" exception=(e, catch_backtrace())
    end
end
```

## VSCode
In combination with the [Julia extension](https://www.julia-vscode.org/), 
VSCode is the recommended editor for development in Julia. 
It provides several shortcuts that make package development in Julia convenient.
We will demonstrate the extension during the lecture.

## Writing packages
### PkgTemplates.jl
[PkgTemplates.jl](https://github.com/JuliaCI/PkgTemplates.jl)

PkgTemplates can be heavily configured, however we are going to stick to the defaults:
```julia
using PkgTemplates

t = Template()
t("MyPackage")
```

At the end of the package generation, Julia will inform us that
`[ Info: New package is at ~/.julia/dev/MyPackage`.

### File structure
Let's take a look at the structure of the generated files:
```bash
$ cd ~/.julia/dev/MyPackage

$ tree -a -I '.git/' # show folder structure, ignoring .git folder 
.
├── .github
│   └── workflows
│       ├── CI.yml
│       ├── CompatHelper.yml
│       └── TagBot.yml
├── .gitignore
├── LICENSE
├── Manifest.toml
├── Project.toml
├── README.md
├── src
│   └── MyPackage.jl
└── test
    └── runtests.jl

5 directories, 10 files
```

In the lecture we will be discussing all files in detail:
- `Project.toml` for packages
  - semantic versioning
  - compat entries
- structure of a Julia package
- package testing
- continuous integration (CI)

### Activating the project
To start a REPL session that activates you  project environment,
start julia with the flag `--project`:
```bash
$ cd ~/.julia/dev/MyProject

$ julia --project
```

```julia-repl
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.8.5 (2023-01-08)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> # press ]

(MyPackage) pkg> # project environment is active!
```

As we can see, the environment is directly active and there is no need to type `activate MyPackage`.

~~~
<div class="admonition tip">
  <p class="admonition-title">Tip</p>
  <p>I like to set a shell alias set for 
  <code>julia --project --banner=no</code>.</p>
</div>
~~~

Let's add a dependency to our project, for example CSV.jl:
```julia-repl
(MyPackage) pkg> add CSV
    Updating registry at `~/.julia/registries/General.toml`
   Resolving package versions...
    Updating `~/.julia/dev/MyPackage/Project.toml`
  [336ed68f] + CSV v0.10.10
    Updating `~/.julia/dev/MyPackage/Manifest.toml`
  [336ed68f] + CSV v0.10.10
  [944b1d66] + CodecZlib v0.7.1
  [9a962f9c] + DataAPI v1.15.0
  [e2d170a0] + DataValueInterfaces v1.0.0
  [48062228] + FilePathsBase v0.9.20
  [842dd82b] + InlineStrings v1.4.0
  [82899510] + IteratorInterfaceExtensions v1.0.0
  [2dfb63ee] + PooledArrays v1.4.2
  [91c51154] + SentinelArrays v1.3.18
  [3783bdb8] + TableTraits v1.0.1
  [bd369af6] + Tables v1.10.1
  [3bb67fe8] + TranscodingStreams v0.9.13
  [ea10d353] + WeakRefStrings v1.4.2
  [76eceee3] + WorkerUtilities v1.6.1
  [9fa8497b] + Future
  [8dfed614] + Test
```

```
# In folder ~/.julia/dev/MyPackage
$ cat Project.toml
───────┬─────────────────────────────────────────────────────────────────────────
       │ File: Project.toml
───────┼─────────────────────────────────────────────────────────────────────────
   1   │ name = "MyPackage"
   2   │ uuid = "c97c58cb-c2b5-45a4-93b4-32bd8ab523c1"
   3   │ authors = ["Adrian Hill <git@adrianhill.de> and contributors"]
   4   │ version = "1.0.0-DEV"
   5   │
   6 + │ [deps]
   7 + │ CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
   8 + │
   9   │ [compat]
  10   │ julia = "1"
  11   │
  12   │ [extras]
  13   │ Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
  14   │
  15   │ [targets]
  16   │ test = ["Test"]
───────┴────────────────────────────────────────────────────────────────────────
```
This time, the `Project.toml` looks a bit more complicated:
- As expected, CSV.jl created an entry in the dependency section `[deps]`.
- Our package has a name, a UUID, a version and information
  about the package author.
- We have an "extra" dependency on the package Tests.jl. More on this later.
- There is a new `[compat]` section to specify package compatibility bounds.

### Semantic versioning
It is good practice (and required for package registration) 
to enter compat entries for all dependencies.
This allows us to update dependencies without having to worry about our code breaking.

By convention, Julia packages are expected to follow
[Semantic Versioning](https://semver.org/lang/de/) to specify verion numbers:

> Given a version number MAJOR.MINOR.PATCH, increment the:
> 1. MAJOR version when you make incompatible API changes
> 1. MINOR version when you add functionality in a backward compatible manner
> 1. PATCH version when you make backward compatible bug fixes
> 1. Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

> Major version zero (0.y.z) is for initial development.
> Anything MAY change at any time. The public API SHOULD NOT be considered stable.

### Package tests
By convention, package tests are in a folder called `test/`.
The main file that includes all other tests is called `runtest.jl`.
To run this file, enter Pkg-mode and write `test`: 
```julia-repl
(MyPackage) pkg> test
     Testing MyPackage
      Status `/private/var/folders/74/wcz8c9qs5dzc8wgkk7839k5c0000gn/T/jl_TcJkwR/Project.toml`

     ... # Julia resolves a temporary environment from scratch
    
     Testing Running tests...
Test Summary: |Time
MyPackage.jl  | None  0.0s
     Testing MyPackage tests passed
```

Our tests passed since we didn't have any!

Using the [Test.jl](https://docs.julialang.org/en/v1/stdlib/Test/) 
standard library package and its macros `@test` and `@testset`, 
we can add tests to our package, which will be demonstrated in the lecture.

### Continuous integration
The `.github/workflows/` folder contains three files, which specify so-called *"GitHub actions"*:
- `CI.yml`: run tests, optinally build docs and determine code coverage.
- `CompatHelper.yml`: Check whether `[compat]` entries are up to date.
- `TagBot.yml`: tag new releases of your package.

These file use GitHub's syntax to define what should be run / tested on their servers.
These are either run on a timed schedule or when pushing commits and opening pull requests.


## Experiments with DrWatson.jl

## Calling scripts from the command line

## Further references
- [Workflow tips in the Julia documentation](https://docs.julialang.org/en/v1/manual/workflow-tips/)