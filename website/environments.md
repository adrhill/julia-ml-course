@def title = "Julia Programming for Machine Learning"
@def tags = ["index", "environments"]

# Environments

Environments play an important role in managing dependencies within programming projects.
I this lecture, we will talk about why they are needed, how they are created and how they are defined.

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

## What are environments?
An environment is an isolated workspace containing dependencies (external packages you are using):

* For a small ML project, 
  you might want to define an environment that includes *MLDatasets.jl* and *Flux.jl*.
* For an image processing project, 
  you might want to define an environment containing *Images.jl* and *LinearAlgebra.jl*.

Environments are managed by Julia's package manager **Pkg** and defined in two files called `Project.toml` and `Manifest.toml`.


## Creating a new virtal environment
To create a new environment, enter Pkg-mode in the Julia REPL by typing `]`, then type `activate`
followed by the name of the environment you want to create.

Let's create an new environment called `MyDeepLearningEnv` that includes *MLDatasets.jl* and *Flux.jl*:

```julia-repl
(@v1.10) pkg> activate MyDeepLearningEnv            # create environment
  Activating new project at `~/MyDeepLearningEnv`

(@MyDeepLearningEnv) pkg>                           # environment is active
```

The printout informs us that this created a new project folder at `~/MyDeepLearningEnv`.
The exact path depends on the folder in which you launched Julia, in this case my home directory, which is called `~` on Linux and macOS.

The project folder `MyDeepLearningEnv` contains a `Project.toml` and `Manifest.toml`.
Adding packages to this environment will update both of these files:

```julia-repl
(MyDeepLearningEnv) pkg> add Flux, MLDatasets
   Resolving package versions...
   Installed ProgressLogging ─ v0.1.4
   Installed Functors ──────── v0.4.10
   Installed Optimisers ────── v0.3.3
   Installed OneHotArrays ──── v0.2.5
   Installed Flux ──────────── v0.14.15
    Updating `~/MyDeepLearningEnv/Project.toml`   # <---
  [587475ba] + Flux v0.14.15
  [eb30cadb] + MLDatasets v0.7.14
    Updating `~/MyDeepLearningEnv/Manifest.toml`  # <---
  [621f4979] + AbstractFFTs v1.5.0
  [79e6a3ab] + Adapt v4.0.4
  [dce04be8] + ArgCheck v2.3.0
  [a9b6321e] + Atomix v0.1.0
  [a963bdd2] + AtomsBase v0.3.5
  ...
```

We can check the packages in our environment by typing `status` or `st` in Pkg-mode:

```julia-repl
(MyDeepLearningEnv) pkg> status
Status `~/MyDeepLearningEnv/Project.toml`
  [587475ba] Flux v0.14.15
  [eb30cadb] MLDatasets v0.7.14
```

## Structure of a Julia environment
### `Project.toml`

Let's first take a look at contents of the `Project.toml`. 
In a second terminal, move to your project folder using `cd` (**c**hange **d**irectory),
then look at the file contents in your terminal using the command `cat Project.toml` (con**cat**enate),
or open the file in your favorite editor:

```toml
[deps]
Flux = "587475ba-b771-5e3f-ad9e-33799f191a9c"
MLDatasets = "eb30cadb-4394-5ae3-aed4-317e484a6458"
```

In the case of our environment, the `Project.toml` just contains a list of the installed packages we would expect: Flux and MLDatasets. 
They are followed by a string called a *"universally unique identifiers"* (UUIDs), which we can ignore for now.

As we will see in the lesson on [writing a package](/write), 
the `Project.toml` contains more information when used in packages.

### `Manifest.toml`



Let's look at ours using `cat Manifest.toml`:

```toml
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "9aea089894f46207e0e51b9ad88b65d90b4230ac"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"
...
```

The `Manifest.toml` is a much longer file than the `Project.toml`. 
Mine contains 1267 lines of code, even though we just added two dependencies: Flux and MLDatasets!
How is this possible?

This is due to the fact that the Manifest lists all packages in the dependency tree.
Not only Flux and MLDatasets, but also their dependencies, the dependencies of their dependencies, and so on.
For packages that are not part of Julia Base, Git tree hashes and versions are specified.
The Manifest even includes external binaries (e.g. compiled C, C++ and Fortran programms) that might be required. 
These binary packages usually end with a `_jll` suffix.

**This makes our environment fully reproducible!**

## Why should I use environments?
### Reason 1: Reproducibility
In the sciences, reproducibility is of utmost importance to validate research findings and improve reliability.
The environment of a project can be shared with others by providing a `Project.toml` and `Manifest.toml` . 
This ensures that people will use the exact same dependencies as you did. 
Changes in future releases of a package won't affect your results.  

### Reason 2: Avoiding dependency conflicts
As we will see in our lecture on [writing packages](/write), packages can set lower and upper version bounds,
since developers don't know whether future releases of their dependencies will be compatible with their code.

Let's image a scenario where Flux and MLDataset both have a common dependency on a third package Foo.jl.
When creating an environment, Pkg will look at the acceptable versions of Foo for both Flux and MLDataset and compute the intersection of acceptable versions.

```julia-repl
(MyDeepLearningEnv) pkg> status --outdated -m
Status `~/MyDeepLearningEnv/Manifest.toml`
⌅ [ab4f0b2a] BFloat16s v0.4.2 (<v0.5.0): Pickle
⌅ [198e06fe] BangBang v0.3.40 (<v0.4.1): FLoops, MicroCollections, Transducers
⌅ [128add7d] MicroCollections v0.1.4 (<v0.2.0): Transducers
⌅ [5e0ebb24] Strided v1.2.3 (<v2.0.4): Pickle
⌃ [28d57a85] Transducers v0.4.80 (<v0.4.81)
⌅ [fe0851c0] OpenMPI_jll v4.1.6+0 (<v5.0.2+0): HDF5_jll
```



### Reason 3: Avoid pollution of your global environment


### Reason 4: Simplify trouble-shooting

### Reason 5: Environments include binaries

## Temporary environments
If you want to try an interesting new package you've seen on GitHub,
the package manager offers a simple way to start a temporary environment.

In your Julia REPL, enter package mode and type `activate --temp`.
This will create an environment with a randomized name in a temporary folder.

```julia-repl
(@v1.10) pkg> activate --temp
  Activating new project at `/var/folders/74/wcz8c9qs5dzc8wgkk7839k5c0000gn/T/jl_9AGcg1`

(jl_9AGcg1) pkg>
``` 

## Environments in Pluto
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

## Further reading
* [Julia documentation on Working with Environments](https://pkgdocs.julialang.org/v1/environments/)
* [Julia documentation on Code Loading ](https://docs.julialang.org/en/v1/manual/code-loading/#Environments) for advanced users