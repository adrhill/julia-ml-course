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
<div class="admonition note">
  <p class="admonition-title">Note</p>
  <p>These notes are designed to accompany a live demonstration in the 
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

These two files define environments.

### Environments
Let's first take a look at contents of the `Project.toml`.
We can either open it in an editor or look at the file contents in our terminal using the command `cat Project.toml`:
```toml
[deps]
OhMyREPL = "5fb14364-9ced-5910-84b2-373655c76a03"
Revise = "295af30f-e4ad-537b-8983-00126c2a3abe"
```

In the case of our environment, it just  contains a list of installed packages 
with *"universally unique identifiers"* (UUIDs).
As we will see in the following sections, 
the `Project.toml` contains more information when used in packages.

The `Manifest.toml` is a much longer file. It lists all packages in the dependency tree.
For packages that are not part of Julia Base, Git tree hashes and versions are specified.
**This makes our environment fully reproducible!**

Let's look at ours:

```toml
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "e9cf4d3c4e1f72eba6aa88164f23d06c005b9b9b"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "d730914ef30a06732bdd9f763f6cc32e92ffbff1"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"
...
```
Each environment we create adds a folder to `~/.julia/environments`
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
the package manager offers a simple way to start a temporary environment.

In your Julia REPL, enter package mode and type `activate --temp`.
This will create an environment with a randomized name in a temporary folder.

```julia-repl
(@v1.8) pkg> activate --temp
  Activating new project at `/var/folders/74/wcz8c9qs5dzc8wgkk7839k5c0000gn/T/jl_9AGcg1`

(jl_9AGcg1) pkg>
``` 

### Environments in Pluto
Pluto notebooks also contain reproducible environments.
Let's take a look at the source code of a notebook called `empty_pluto.jl`
that just contains a single cell declaring `using LinearAlgebra`.

```julia
### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# ╔═╡ 9842a4f5-69d1-4566-b605-49d5c6679b4a
using LinearAlgebra # 💡 the only cell we added! 💡

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""
 
# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "ac1187e548c6ab173ac57d4e72da1620216bce54"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╠═9842a4f5-69d1-4566-b605-49d5c6679b4a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
```

We can see that
- A variable called `PLUTO_PROJECT_TOML_CONTENTS` holds the `Project.toml` information.
- A variable called `PLUTO_MANIFEST_TOML_CONTENTS` holds the `Manifest.toml` information.
- Cells are annotated by a comment `# ╔═╡ some-uuid`.
- The ordering of cells is given in a comment `# ╔═╡ Cell order:` at the end of the file.

Pluto notebooks are therefore fully reproducible and also regular Julia files!

## REPL-based workflows
The most basic workflow uses the Julia REPL in combination with your favorite editor.

### Loading Julia source code
To load a source file, use the command `include`.
To test this, I have created two almost identical files: 
- a file `foo.jl`, which contains a function `foo`
- a file `bar.jl`, which contains a function `bar` inside a module `Bar`

```julia
# Contents of foo.jl
foo(x) = x
```

```julia
# Contents of bar.jl
module Bar

  bar(x) = x

  export bar # export function

end # end module
```

Let's compare the two approaches.
The first one loads all contents of the file into the global namespace

```julia-repl
julia> include("foo.jl")
foo (generic function with 1 method)

julia> foo(2)
2
```

whereas the second approach encapsulates everything inside the module `Bar`.
Via `using .Bar`, we make all functions that are exported in `Bar` available:

```julia-repl
julia> include("bar.jl") # load module Bar
Main.Bar

julia> Bar.bar(2)  # we can access the function in the module...
2

julia> bar(2)      # ...but not directly
ERROR: UndefVarError: bar not defined
Stacktrace:
 [1] top-level scope
   @ REPL[4]:1

julia> using .Bar  # import everything that is exported in module Bar...

julia> bar(2)      # ...so we can use exports without name-spacing Bar
2
```

### Enhancing the REPL experience
#### Loading packages on startup
If you have code that you want to be run every time you start Julia, 
add it to your [startup file](https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file)
that is located at `~/.julia/config/startup.jl`.
Note that you might have to first create this config folder.

A common use-case for the `startup.jl` to load packages that are crucial for your workflow.
Don't add too many packages: 
they will increase the loading time of your REPL and might pollute the global namespace.
There are however two packages I personally consider essential additions: 
*Revise.jl* and *OhMyRepl.jl*.


#### Revise.jl
[Revise.jl](https://github.com/timholy/Revise.jl) will keep track of changes in loaded files 
and reload modified Julia code without having to start a new REPL session.

To load Revise automatically, add the following code to your `startup.jl`:

```julia
# First lines of ~/.julia/config/startup.jl
try
    using Revise
catch e
    @warn "Error initializing Revise in startup.jl" exception=(e, catch_backtrace())
end
```

It is enough to add `using Revise`, 
but the `try-catch` statement will return a helpful error message in case something goes wrong.

#### OhMyRepl.jl
[OhMyRepl](https://github.com/KristofferC/OhMyREPL.jl) adds many features to your REPL,
amongst other things:
- syntax highlighting
- (rainbow) bracket highlighting
- fuzzy history search
- stripping prompts when pasting code

```julia
# Add to ~/.julia/config/startup.jl
atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "Error initializing OhMyRepl in startup.jl" exception=(e, catch_backtrace())
    end
end
```

## VSCode
In combination with the [Julia extension](https://www.julia-vscode.org/), 
VSCode is the most commonly recommended editor for development in Julia. 
It provides several features and shortcuts that make package development convenient:
- debugging with breakpoints
- running code (or only sections of the code)
- code completion
- code formatting
- view *"workspace"* of global variables
- view documentation
- view plots
- [keyboard shortcuts](https://www.julia-vscode.org/docs/stable/userguide/keybindings/)

We will demonstrate the extension during the lecture.

## Writing packages
In Julia, packages are the natural medium for code that doesn't fit in a simple script.
While this might sound excessive at first, it provides many conveniences.

Thanks to templates, setting up the file structure for a Julia package takes seconds.  

### PkgTemplates.jl
[PkgTemplates.jl](https://github.com/JuliaCI/PkgTemplates.jl) 
is a highly configurable package for project templates.
In this example, we are going to stick to the defaults:

```julia-repl
julia> using PkgTemplates

julia> t = Template()

julia> t("MyPackage")
```

At the end of the package generation, 
Julia will inform us that our project has been created in the `~/.julia/dev` folder:

```julia-repl
[ Info: New package is at ~/.julia/dev/MyPackage
```

The output folder can be configured in the template.
Take a look at the [PkgTemplates user guide](https://juliaci.github.io/PkgTemplates.jl/stable/user/) 
to create a template customized to your needs.

### File structure
Let's take a look at the structure of the files generated by PkgTemplates.jl:
```bash
$ cd ~/.julia/dev/MyPackage

$ tree -a -I '.git/' # show folder structure, ignoring the .git folder 
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

~~~
<div class="admonition note">
  <p class="admonition-title">Note</p>
  <p>
    In the lecture we will be discussing all files in detail:
    <ul>
      <li>
        <code>Project.toml</code> for packages
        <ul>
          <li>compat entries</li>
          <li>semantic versioning</li>
        </ul>
      </li>
      <li>structure of Julia source code</li>
      <li>package testing</li>
      <li>continuous integration (CI)</li>
    </ul>
  </p>
</div>
~~~

### Activating the package environment
#### In VSCode
The Julia VSCode extension provides a keyboard shortcut to start a REPL: `Alt+j Alt+o` (`option+j option+o` on macOS).

#### In the REPL
To start a REPL session that directly activates your local project environment,
start julia with the flag `--project`:
```bash
$ cd ~/.julia/dev/MyProject

$ julia --project
```

```julia-repl
# Starts Julia REPL session
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

The environment is directly active, there is no need to type `activate MyPackage`.

~~~
<div class="admonition tip">
  <p class="admonition-title">Tip</p>
  <p>I recommend setting a shell alias set for 
  <code>julia --project --banner=no</code>.</p>
</div>
~~~

### `Project.toml` in packages
Let's add a dependency to our package, for example CSV.jl:

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

When adding a package, the `Project.toml` of our package will automatically be updated.
It is always located in the root folder of the package
(in our example at `~/.julia/dev/MyPackage/Project.toml`).

In our case, the `Project.toml` contains:

```toml
name = "MyPackage"
uuid = "c97c58cb-c2b5-45a4-93b4-32bd8ab523c1"
authors = ["Adrian Hill <git@adrianhill.de> and contributors"]
version = "1.0.0-DEV"

[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"

[compat]
julia = "1"

[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[targets]
test = ["Test"]
```

- our package has a name, a UUID, a version and information
  about the package author
- adding CSV.jl created an entry in the dependency section `[deps]`
- there is a new `[compat]` section to specify package compatibility bounds
   - compat entries for external packages like CSV.jl have to be added manually
- we have an "extra" dependency on the package Tests.jl (more on this later)

~~~
<div class="admonition tip">
  <p class="admonition-title">Tip</p>
  <p>When looking at a new package, 
  checking out its dependencies in the <code>Project.toml</code> is a good starting point.</p>
</div>
~~~

### Semantic versioning
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
  [336ed68f] CSV v0.10.10
``` 

Let's declare in the `Project.toml` that only versions `0.10.X` of CSV.jl are permitted. 
This will allow us to get updates that patch bugs, but not updates with breaking changes.
```toml
[compat]
CSV = "0.10"
julia = "1"
```

### Structure of the source folder
By convention, the *"main"* file of a project has the same name as the project.
PkgTemplates already created this file `src/MyPackage.jl` for us: 
```julia
# Contents of src/MyPackage.jl
module MyPackage

# Write your package code here.

end
```
The file defines a module with the same name as our package.
Inside this module, you will import dependencies, `include` other source files and export your functions. 
Let's look at a toy example:

```julia
# Updated contents of src/MyPackage.jl
module MyPackage

# 1.) Import functions you need
using LinearAlgebra: cholesky 

# 2.) Include source files
include("my_source_code_1.jl")
include("my_source_code_2.jl")
include("my_source_code_3.jl")

# 3.) Export functions you defined
export my_function_1, my_function_2

end # end module
```

~~~
<div class="admonition tip">
  <p class="admonition-title">Tip</p>
  <p>When looking at the source code of a package, 
  this should be the first file you read.</p>
</div>
~~~

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

~~~
<div class="admonition note">
  <p class="admonition-title">Note</p>
  <p>
    Package tests will be covered in the lecture. Take a look at the 
    <a href="https://docs.julialang.org/en/v1/stdlib/Test/">unit test documentation</a>.
  </p>
</div>
~~~

### Continuous integration
The `.github/workflows/` folder contains three files, which specify 
[*GitHub actions*](https://github.com/features/actions):
- `CI.yml`: run tests, optionally build docs and determine code coverage.
- `CompatHelper.yml`: Check whether `[compat]` entries are up to date.
- `TagBot.yml`: tag new releases of your package.

These files contain instructions that will be run on GitHub's computers.
The most basic use-case is running package tests. 
GitHub Actions either run on a timed schedule or at specific events, 
for example when pushing commits and opening pull requests.

~~~
<div class="admonition note">
  <p class="admonition-title">Note</p>
  <p>GitHub Actions and CI will be showcased in the lecture.</p>
</div>
~~~

### Package registration
If you wrote a high quality, well tested package 
and want to make it available to all Julia users through the package manager, 
follow the [Registrator.jl instructions](https://github.com/JuliaRegistries/Registrator.jl). 

People will then be able to install your package by writing

```julia-repl
(@v1.8) pkg> add MyPackage
```

## Experiments with DrWatson.jl
[DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) 
describes itself as *"scientific project assistant software"*. It serves two purposes:
1. It sets up a project structure that is specialized for scientific experiments, similar to PkgTemplates.
1. It introduces several useful helper functions. Among these are boiler-plate functions for file loading and saving.

The following two sections are directly taken from the [DrWatson documentation](https://juliadynamics.github.io/DrWatson.jl/stable/workflow/), which I recommend reading

### File structure
To initialize a DrWatson project, run:
```julia-repl
julia> using DrWatson

julia> initialize_project("MyScientificProject"; authors="Adrian Hill", force=true)
```
The default setup will initialize a file structure that looks as follows:
```plaintext
│projectdir          <- Project's main folder. It is initialized as a Git
│                       repository with a reasonable .gitignore file.
│
├── _research        <- WIP scripts, code, notes, comments,
│   |                   to-dos and anything in an alpha state.
│   └── tmp          <- Temporary data folder.
│
├── data             <- **Immutable and add-only!**
│   ├── sims         <- Data resulting directly from simulations.
│   ├── exp_pro      <- Data from processing experiments.
│   └── exp_raw      <- Raw experimental data.
│
├── plots            <- Self-explanatory.
├── notebooks        <- Jupyter, Weave or any other mixed media notebooks.
│
├── papers           <- Scientific papers resulting from the project.
│
├── scripts          <- Various scripts, e.g. simulations, plotting, analysis,
│   │                   The scripts use the `src` folder for their base code.
│   └── intro.jl     <- Simple file that uses DrWatson and uses its greeting.
│
├── src              <- Source code for use in this project. Contains functions,
│                       structures and modules that are used throughout
│                       the project and in multiple scripts.
│
├── test             <- Folder containing tests for `src`.
│   └── runtests.jl  <- Main test file, also run via continuous integration.
│
├── README.md        <- Optional top-level README for anyone using this project.
├── .gitignore       <- by default ignores _research, data, plots, videos,
│                       notebooks and latex-compilation related files.
│
├── Manifest.toml    <- Contains full list of exact package versions used currently.
└── Project.toml     <- Main project file, allows activation and installation.
                        Includes DrWatson by default.
```
### Workflow
The DrWatson workflow is best summarized in the following picture from the 
[documentation](https://juliadynamics.github.io/DrWatson.jl/stable/workflow/):

![DrWatson workflow](/assets/drwatson_workflow.png)


## Calling scripts from the command line
Working on compute-clusters often required scheduling "jobs" from the command-line.
To run a Julia script in the file `my_script.jl`, run the following command:

```bash
$ julia my_script.jl arg1 arg2...
```

Inside your script, the additional command-line arguments `arg1` and `arg2` can be used through the global constant `ARGS`. 
If `my_script.jl` contains the code

```julia
# Content of my_script.jl
for a in ARGS
  println(a)
end
```
Calling it with arguments `foo`, `bar` from the command-line will print:
```bash
$ julia my_script.jl foo bar
foo
bar
```

### Command-line switches
Julia provides several
[command-line switches](https://docs.julialang.org/en/v1/manual/command-line-interface/#command-line-interface).
For example, for parallel computing, `--threads` can be used to specify the number of CPU threads 
and `--procs` for the number of worker processes. 

The following command will run `my_script.jl` with 8 threads:

```bash
$ julia --threads 8 -- my_script.jl arg1 arg2
```

~~~
<div class="admonition tip">
  <p class="admonition-title">Parallel computing</p>
  <p>In this lecture, we only covered GPU parallelization (Lecture 7 on <i>Deep Learning</i>).<p>
  Refer to the 
  <a href="https://docs.julialang.org/en/v1/manual/parallel-computing/">Julia documentation on parallel computing</a>
  for more information on multi-threading and distributed computing.</p>
</div>
~~~

### External packages
Handling arguments in `ARGS` can be tedious.
[Comonicon.jl](https://github.com/comonicon/Comonicon.jl) is a package to build simple command-line interfaces for Julia programs by using a macro `@main`. Among other features, it supports
- positional arguments
- optional arguments with defaults
- boolean flags
- help pages generated from docstrings

Take a look at the [documentation](https://comonicon.org/stable/).
