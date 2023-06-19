### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try
            Base.loaded_modules[Base.PkgId(
                Base.UUID("6e696c72-6542-2067-7265-42206c756150"),
                "AbstractPlutoDingetjes",
            )].Bonds.initial_value
        catch
            b -> missing
        end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ c2ba8ec1-744b-4428-a5b3-5ad50752b396
begin
    using PlutoUI
    using PlutoTeachingTools
end

# ╔═╡ c5e6183d-8fc9-47f4-aff4-6a0fa75b3e4b
ChooseDisplayMode()

# ╔═╡ c854cbe0-5e36-4569-9e1f-d17b2c3540d5
TableOfContents()

# ╔═╡ 676ec5af-e006-4870-b49c-08f180612113
PlutoTeachingTools.default_language[] = PlutoTeachingTools.PTTEnglish.EnglishUS();

# ╔═╡ 04376141-9c94-4197-804a-932c35a53777
html"""
	<h1 style="text-align:center">
		Julia programming for ML
	</h1>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Installation
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Adrian Hill
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Summer Semester 2023
		</p>
	</div>
"""

# ╔═╡ 7a078934-82c3-45a0-be32-77d6fe59485c
md"""# Installation
## Installing Julia
We will install Julia using [juliaup](https://github.com/JuliaLang/juliaup).
The following commands have to be entered in your terminal.

**Linux and macOS**
```bash
curl -fsSL https://install.julialang.org | sh
```

**Windows**

Install Julia [from the Windows store](https://www.microsoft.com/store/apps/9NJNWW8PVKMN) or run
```bash
winget install julia -s msstore
```
#### Setting the default version
For this class, we are going to use Julia 1.8. To set it as the default version on your machine, run
```bash
juliaup default 1.8
```
"""

# ╔═╡ 3133b51c-c1c0-43d3-8938-1179e9466e44
tip(
    md"If these options don't work out for you, you can also [manually download Julia 1.8](https://julialang.org/downloads/).",
)

# ╔═╡ a619a607-aeb6-4ca1-b380-4cd41c8e6768
md"""## Checking the installation
Start a Julia REPL ([Read-eval-print loop](https://en.wikipedia.org/wiki/Read–eval–print_loop)) session:
```bash
julia
```

If your installation was successful, you should be greeted by the Julia Logo and information about your Julia version.

![REPL](https://i.imgur.com/mSIJ0mP.png)
"""

# ╔═╡ 1af86ae9-22a6-43f0-80b5-b8d6026abb39
warning_box(md"Make sure you are using Julia 1.8!")

# ╔═╡ 7c9f3896-f9d8-477d-8a20-53114f6cc8ff
md"""## Using the package manager
Julia's package manager is called **Pkg**. In the Julia REPL, open the package manager by typing a closing square bracket **`]`**.


 The REPL prompt should change from `julia>` to `(@1.8) pkg>`:

![Pkg](https://i.imgur.com/rzH4rbv.png)

You can exit the package manager mode by pressing backspace.
"""

# ╔═╡ 3e5ae3af-079d-46e1-be43-b4935278c965
Markdown.MD(
    Markdown.Admonition(
        "tip",
        "Environments:",
        [
            md"""
            The name in parenthesis (here `@v1.8`) is the name of the currently activated environment.
            `(@v1.8)` is the global environment of our Julia 1.8 installation.

            We will learn more about Pkg and environments in a later lecture!
            """,
        ],
    ),
)

# ╔═╡ b599bc9c-3b25-4c2c-8192-b0ba38f4dcda
md"""## Installing packages
Packages can be added by typing `add PackageName` in the package manager.

For the purpose of this class, we are going to install Pluto in our global `(@v1.8)` environment:
```
(@v1.8) pkg> add Pluto
```

You should see Pkg install Pluto. Note that the package versions in your installation **don't** have to exactly match up with this screenshot:
![Pluto install](https://i.imgur.com/QY5QtYl.png)
"""

# ╔═╡ 822bf9d1-e323-4a20-9d79-0b10affd2ddc
md"""# Introduction to Pluto
## Why Pluto?
Pluto is the interactivate notebook this lecture is written in.
- Pluto notebooks contain fully reproducible environments
- Pluto is reactive, allowing you to experiment with code in an interactive manner
"""

# ╔═╡ 530499f5-294a-43bd-860f-ae942ac4f655
Markdown.MD(
    Markdown.Admonition(
        "tip",
        "Fun fact:",
        [
            md"""
            Pluto was developed by Fons van der Plas ([@fonsp](https://github.com/fonsp)) after he took a Julia course at TU Berlin!
            """,
        ],
    ),
)

# ╔═╡ 38feafd0-9620-4d22-8b47-bddf913cb247
md"""## Starting Pluto
Exit the package manager with backspace such that your REPL prompt reads `julia>` again. Now write the following in your REPL:
```julia-repl
julia> using Pluto

julia> Pluto.run()
```
Pluto should automatically open in your default browser. If it doesn't, click the link in the REPL.
"""

# ╔═╡ 757e913a-3697-41ba-b689-a91dd0893463
tip(md"""You might want to set a shell alias to start Pluto, e.g.
```bash
alias pluto="julia --banner=no -e 'using Pluto; Pluto.run()'"
```
""")

# ╔═╡ a8288d7c-9f8a-42f4-8f93-3037ec5ddb37
md"""## Opening lectures & homework
Notebooks hosted on the JuML course website have an *"Edit or run this notebook"* button in the top-right corner. Clicking this button will give you access to the notebook URL:

![Notebook URL](https://i.imgur.com/a3RLnwU.png)

You can then copy this URL into the *"Open a notebook"* field of the Pluto starting page:

![Starting page](https://i.imgur.com/o7TjYX5.png)

Doing this will ensure that you are working with the latest version of the lectures and homework. 
"""

# ╔═╡ f1d4d38b-5593-4493-976a-e4b9d486007a
tip(md"If you are familiar with Git, you can also clone the repository of this course. 

Just make sure to regularly `git pull` to keep your copy of the course up to date.")

# ╔═╡ 13b9791e-3b4e-4d0c-9945-50e6df8fa21a
md"""## Writing in a Pluto notebook
Unlike Jupyter notebooks, all cells in Pluto notebooks are code cells.
Strings can be formatted to [Markdown](https://www.markdownguide.org/) by prefixing them by `md`:

"""

# ╔═╡ 606919fb-c5f9-4fa6-93a8-5bc243b22691
"This is a *string*"

# ╔═╡ 380a07c0-6d59-4c31-a2db-fc139326c8dd
md"This is a *Markdown* string"

# ╔═╡ 45abe385-33d1-4518-8a0e-3f419ea44f96
md"Markdown supports $\LaTeX$ content:

$\int_{0}^{1} \sin\left(\pi\xi\right)\, d\xi$
"

# ╔═╡ e1570bbb-4820-41d0-8e79-628cc0f30c0b
md"The visibility of all cells can be toggled by clicking on the eye symbol on the left of a cell."

# ╔═╡ 4ebf5d79-16c7-4340-bfb5-73d6c4845e2a
md"""## Loading packages
We've previously seen how to add packages in the Julia REPL via Pkg.

Pluto also makes use of Pkg, however packages can be added and loaded by simply adding a `using` statement. Hovering over the check marks will give you extra information about the version of the installed package.
"""

# ╔═╡ 1108d61f-5d6d-460e-8806-f79a61afe506
tip(
    md"""Pluto notebooks are fully reproducible. We will discuss this in more depth in the final lectures.""",
)

# ╔═╡ ee23e418-e957-433c-b457-16fdb6c11aca
md"""## Reactivity
Pluto is reactive. If a variable that other cells depend upon is changed, all dependant cells will be re-computed. The reactivity **doesn't** depend on the order of the cells in the notebook.
"""

# ╔═╡ 0a7b2bb0-30b8-4e30-a5ae-9a638bd2149d
md"""We use the [PlutoUI package](https://github.com/fonsp/PlutoUI.jl)
to interact with our code using things like sliders:
"""

# ╔═╡ bdaed5a0-5201-4982-af88-e6de1d00f215
@bind x PlutoUI.Slider(1:10, default=3, show_value=true)

# ╔═╡ 9192483c-182e-4c3c-ba4f-3e47942c21c5
x^2

# ╔═╡ 524a4171-873c-48b7-9929-d3179bb3f47d
sqrt.(1:x)

# ╔═╡ 1a38f76f-807e-4454-b2d3-8ac84f0f4aa4
md"We can interpolate values into strings using `$(...)`:"

# ╔═╡ a8e8308b-5584-44b2-90b6-85a7f5728718
md"The value of x is $(x)."

# ╔═╡ 4acf4194-5ab4-4a10-9996-f2ca8c65afc9
Markdown.MD(
    Markdown.Admonition(
        "tip", "Note", [md"Reactivity is a feature of Pluto notebooks, not Julia itself."]
    ),
)

# ╔═╡ 6b6b5d2c-ad77-40fc-adde-e5f4925fb0b2
md"""## Caveats of reactivity
Each cell can only contain one statement. If multiple expressions depend on each other, they can either be written in separate cells or wrapped in a `begin ... end` statement:
"""

# ╔═╡ 3ed1ccc2-70f6-4820-9926-8f62378308c8
begin
    foo = 2
    bar = sqrt(foo)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.5"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "d9b3c1abbe5d36c122f42db12689ec8ec115a8c4"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "0e5c14c3bb8a61b3d53b2c0620570c332c8d0663"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.2.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "72ab280d921e8a013a83e64709f66bc3e854b2ed"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.20"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "8175fc2b118a3755113c8e68084dc1a9e63c61ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "ea3e4ac2e49e3438815f8946fa7673b658e35bdb"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "fd5dba2f01743555d8435f7c96437b29eae81a17"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─c5e6183d-8fc9-47f4-aff4-6a0fa75b3e4b
# ╟─c854cbe0-5e36-4569-9e1f-d17b2c3540d5
# ╟─676ec5af-e006-4870-b49c-08f180612113
# ╟─04376141-9c94-4197-804a-932c35a53777
# ╟─7a078934-82c3-45a0-be32-77d6fe59485c
# ╟─3133b51c-c1c0-43d3-8938-1179e9466e44
# ╟─a619a607-aeb6-4ca1-b380-4cd41c8e6768
# ╟─1af86ae9-22a6-43f0-80b5-b8d6026abb39
# ╟─7c9f3896-f9d8-477d-8a20-53114f6cc8ff
# ╟─3e5ae3af-079d-46e1-be43-b4935278c965
# ╟─b599bc9c-3b25-4c2c-8192-b0ba38f4dcda
# ╟─822bf9d1-e323-4a20-9d79-0b10affd2ddc
# ╟─530499f5-294a-43bd-860f-ae942ac4f655
# ╟─38feafd0-9620-4d22-8b47-bddf913cb247
# ╟─757e913a-3697-41ba-b689-a91dd0893463
# ╟─a8288d7c-9f8a-42f4-8f93-3037ec5ddb37
# ╟─f1d4d38b-5593-4493-976a-e4b9d486007a
# ╟─13b9791e-3b4e-4d0c-9945-50e6df8fa21a
# ╠═606919fb-c5f9-4fa6-93a8-5bc243b22691
# ╠═380a07c0-6d59-4c31-a2db-fc139326c8dd
# ╠═45abe385-33d1-4518-8a0e-3f419ea44f96
# ╟─e1570bbb-4820-41d0-8e79-628cc0f30c0b
# ╟─4ebf5d79-16c7-4340-bfb5-73d6c4845e2a
# ╠═c2ba8ec1-744b-4428-a5b3-5ad50752b396
# ╟─1108d61f-5d6d-460e-8806-f79a61afe506
# ╟─ee23e418-e957-433c-b457-16fdb6c11aca
# ╟─0a7b2bb0-30b8-4e30-a5ae-9a638bd2149d
# ╟─bdaed5a0-5201-4982-af88-e6de1d00f215
# ╠═9192483c-182e-4c3c-ba4f-3e47942c21c5
# ╠═524a4171-873c-48b7-9929-d3179bb3f47d
# ╟─1a38f76f-807e-4454-b2d3-8ac84f0f4aa4
# ╠═a8e8308b-5584-44b2-90b6-85a7f5728718
# ╟─4acf4194-5ab4-4a10-9996-f2ca8c65afc9
# ╟─6b6b5d2c-ad77-40fc-adde-e5f4925fb0b2
# ╠═3ed1ccc2-70f6-4820-9926-8f62378308c8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
