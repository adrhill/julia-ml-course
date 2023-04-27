### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# ╔═╡ 1fcbc08a-a0b7-11ed-0477-13c86a949723
begin
    using PlutoUI
    using PlutoTeachingTools
end

# ╔═╡ c5e6183d-8fc9-47f4-aff4-6a0fa75b3e4b
ChooseDisplayMode()

# ╔═╡ c854cbe0-5e36-4569-9e1f-d17b2c3540d5
TableOfContents()

# ╔═╡ 44ceefa1-61a1-4390-84f8-0940bb16237b
PlutoTeachingTools.default_language[] = PlutoTeachingTools.PTTEnglish.EnglishUS();

# ╔═╡ 04376141-9c94-4197-804a-932c35a53777
html"""
	<h1 style="text-align:center">
		Julia programming for ML
	</h1>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Getting Help
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Adrian Hill
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Summer Semester 2023
		</p>
	</div>
"""

# ╔═╡ 179a4ec9-5eec-4a53-8dfe-5f633db2d27a
md"""# Getting help from Julia
When starting out with a new programming language, the primary source of difficulty is **not knowing function names**.

Luckily, Julia comes with several functions to help you out!
"""

# ╔═╡ 9bb8258a-7e43-4f63-9c9d-c34394611a6a
md"""## Documentation – Pluto"""

# ╔═╡ f91ca4bd-e48e-40e7-9106-03aa48107a56
TwoColumnWideLeft(
    md"""Clicking on **Live Docs** in the lower right corner of a Pluto Notebook will open the documentation pane.

    Docs can be show by either
    1) typing the name of the function
    1) putting your cursor on a function name.

    Here we demonstrate this functionality on the `map` function.
    """,
    md"![Pluto docs](https://i.imgur.com/KVzibQH.png)",
)

# ╔═╡ ed388f95-9900-4f8c-9bbd-ba07ae39dde1
map # <- put your cursor on the function name

# ╔═╡ 3180cc73-02f4-4496-9aa7-5eced6c8de9e
md"""## Documentation – REPL
In the Julia REPL, type `?` to enter *help mode*.
Your prompt will change from `julia>` to `help?>`.
Here, you can type a function name to get help and examples on how to use it.

Once again, let's look up how to use the `map` function:
![REPL help mode](https://i.imgur.com/LFP1Rmt.png)
"""

# ╔═╡ 67973e2f-47aa-4d83-a79e-f8e8f706c689
md"""## Function lookups – `apropos`
But if we don't know the name of a function, how can we look up its documentation?
This is where the `apropos` function can help!

Let's figure out how to compute the determinant of a Matrix in Julia without using Google:
"""

# ╔═╡ f1350961-e857-4397-ba6b-743b827922d1
apropos("determinant")

# ╔═╡ 8a324e2a-1203-4402-81db-2451e04b5587
md"**Answer:** The determinant is computed using LinearAlgebra.jl's `det`!"

# ╔═╡ 5cffb53a-49d5-4aeb-be08-94c97ac4d6f1
tip(
    md"""
The `apropos` function is automatically called when passing a string in the REPL *help mode*:

![REPL help mode](https://i.imgur.com/7llLceN.png)
""",
)

# ╔═╡ 3a09ac13-8d6d-46f9-a6d0-d9b07fdabb8d
md"""## Method lookups – `methodswith`
If we are working with a specific dat type, we might want to discover methods that can be applied to it.

Let's find out which methods can be applied to a data type called `Set`:
"""

# ╔═╡ 32d4ec20-b070-43ec-9399-6fe26b665218
methodswith(Set)

# ╔═╡ ccf465d9-6591-4125-b964-cc96c3ae9e1b
md"""## Method lookups – `methods`
Since a lot of Julia code uses multiple dispatch, you might also want to know which methods a function has.

Let's see which methods are implemented for the function `filter`:
"""

# ╔═╡ 0c5305ca-1ee7-466d-9a84-5f5c2a60f611
methods(filter)

# ╔═╡ bd4a1233-a852-42e0-b240-ba1ce3560f5d
md"""## Finding source code
When using functions we didn't write ourselves, we might want to inspect how the function is implemented. Three macros can be used here: `@which`, `@edit` and `@less`.

The macro `@which` shows us the source file and line where the called function is defined:
"""

# ╔═╡ 838dd2c1-b64b-4e4e-af2a-08d7c9e3bff8
@which sqrt(4.0)

# ╔═╡ 76edccb2-a9cc-43bf-93e9-ccc9e693f5df
md"""Outside of Pluto, you can directly open this file in your default editor using the macro `@edit`
```julia
@edit sqrt(4.0)
```

or view the entire source code using `@less`:
```julia
@less sqrt(4.0)
```
"""

# ╔═╡ f08887f6-fce9-40ca-a659-7e9624c1f6bc
md"## Finding packages
Package search can be found on [JuliaHub.com](https://juliahub.com/ui/Home):

![](https://i.imgur.com/JtWiDUW.png)
"

# ╔═╡ 2915a88f-3bef-4d54-8c5f-6c3da7cb4386
md"""# Getting help from humans
#### TU Berlin students
If you are a TU Berlin student taking the "Julia programming for ML" course, you get personal help by either
- asking questions during lectures / exercises / office hours
- asking in the forum of the JuML ISIS page
- sending me an email

#### Julia community
If you are **not** a TU Berlin student taking the course, there are several other places to get help from the Julia community:
- the `#helpdesk` channel of the [Julia Slack](https://julialang.org/slack/)
- the `#helpdesk` channel of the [Julia Zulip](https://julialang.zulipchat.com/) chat
- the [Julia Discourse](https://discourse.julialang.org) forum
"""

# ╔═╡ e4f79673-057e-4589-be7f-3ce9affb7f6a
tip(
    md"If you are viewing this notebook from the course website, you might have to `Ctrl + click` links. Alternatively, use the standalone notebooks.",
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.9"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "fe1ea3a3075103bc4edb8f048cc2dcf2ba1b5d4e"

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
git-tree-sha1 = "d730914ef30a06732bdd9f763f6cc32e92ffbff1"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.1"

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
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "6a125e6a4cb391e0b9adbd1afa9e771c2179f8ef"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.23"

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
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

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
git-tree-sha1 = "8c8b07296990c12ac3a9eb9f74cd80f7e81c16b7"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.9"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

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
git-tree-sha1 = "feafdc70b2e6684314e188d95fe66d116de834a7"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.2"

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
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

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
# ╠═1fcbc08a-a0b7-11ed-0477-13c86a949723
# ╟─c5e6183d-8fc9-47f4-aff4-6a0fa75b3e4b
# ╟─c854cbe0-5e36-4569-9e1f-d17b2c3540d5
# ╟─44ceefa1-61a1-4390-84f8-0940bb16237b
# ╟─04376141-9c94-4197-804a-932c35a53777
# ╟─179a4ec9-5eec-4a53-8dfe-5f633db2d27a
# ╟─9bb8258a-7e43-4f63-9c9d-c34394611a6a
# ╟─f91ca4bd-e48e-40e7-9106-03aa48107a56
# ╠═ed388f95-9900-4f8c-9bbd-ba07ae39dde1
# ╟─3180cc73-02f4-4496-9aa7-5eced6c8de9e
# ╟─67973e2f-47aa-4d83-a79e-f8e8f706c689
# ╠═f1350961-e857-4397-ba6b-743b827922d1
# ╟─8a324e2a-1203-4402-81db-2451e04b5587
# ╟─5cffb53a-49d5-4aeb-be08-94c97ac4d6f1
# ╟─3a09ac13-8d6d-46f9-a6d0-d9b07fdabb8d
# ╠═32d4ec20-b070-43ec-9399-6fe26b665218
# ╟─ccf465d9-6591-4125-b964-cc96c3ae9e1b
# ╠═0c5305ca-1ee7-466d-9a84-5f5c2a60f611
# ╟─bd4a1233-a852-42e0-b240-ba1ce3560f5d
# ╠═838dd2c1-b64b-4e4e-af2a-08d7c9e3bff8
# ╟─76edccb2-a9cc-43bf-93e9-ccc9e693f5df
# ╟─f08887f6-fce9-40ca-a659-7e9624c1f6bc
# ╟─2915a88f-3bef-4d54-8c5f-6c3da7cb4386
# ╟─e4f79673-057e-4589-be7f-3ce9affb7f6a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
