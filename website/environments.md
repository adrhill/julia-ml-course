@def title = "Julia Programming for Machine Learning"
@def tags = ["index", "environments"]

# Environments

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

## Why use environments?

## Creating a new virtal environment
To create a new environment, enter Pkg-mode in the Julia REPL and type `activate`
followed by the name of your new environment:

```julia-repl
(@v1.10) pkg> activate MyTest # create new environment called  "MyTest"
  Activating new project at `~/.julia/environments/v1.10/MyTest`

(@MyTest) pkg> # environment is active
```

This creates a new folder at `~/.julia/environments/v1.10/MyTest` 
containing a `Project.toml` and `Manifest.toml`.
Adding packages to this environment will update both of these files:

```julia-repl
(@MyTest) pkg> add LinearAlgebra
   Resolving package versions...
    Updating `~/.julia/environments/v1.10/MyTest/Project.toml`
  [37e2e46d] + LinearAlgebra
    Updating `~/.julia/environments/v1.10/MyTest/Manifest.toml`
  [56f22d72] + Artifacts
  [8f399da3] + Libdl
  [37e2e46d] + LinearAlgebra
  [e66e0078] + CompilerSupportLibraries_jll v1.0.1+0
  [4536629a] + OpenBLAS_jll v0.3.20+0
  [8e850b90] + libblastrampoline_jll v5.1.1+0

```

## Structure of a Julia environment
### `Project.toml`

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

### `Manifest.toml`

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