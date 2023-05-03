### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# ╔═╡ f8f70047-543e-4ee9-a9f2-bb5b5d7bb691
begin
    using PlutoUI
    using PlutoTeachingTools
end

# ╔═╡ 7805f29e-fdda-4d59-a5ab-a56bb1e7aece
using BenchmarkTools

# ╔═╡ ba372f70-9704-429a-859d-64b7a132a6d0
ChooseDisplayMode()

# ╔═╡ d0394d67-f73e-4cde-b3f0-c62da781c1cb
TableOfContents()

# ╔═╡ dc09ff3a-e8e9-11ed-02be-591ffc3def78
html"""
	<h1 style="text-align:left">
		Julia programming for ML
	</h1>
	<div style="text-align:left">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Feedback: Week 1
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Summer Semester 2023<br>
		</p>
	</div>
"""

# ╔═╡ 239603a3-aeb1-4141-aab3-c1a521145827
md"# Feedback from you
1) *I would have liked the feedback in notebooks to be anonymous*
    * there is an anonymous feedback option on ISIS!
1) *How do I hand in the homework?*
    * Upload the `.jl`-file of the notebook on ISIS
1) *I would have liked more information about parallelization, CUDA support, ML libraries, building Deep Learning architectures*
    * This is coming up in week 4
1) *How do I import all notebooks to Pluto?*
    * Clone the repository (demo in lecture)
1) *I would have liked more theoretical insight into standardization*
    * We can't cover theory in this lecture, but I will try to add more visualization to future notebooks
"

# ╔═╡ e3f1ba6b-9b3f-4f06-bc08-a9454627edaf
md"# Questions from you"

# ╔═╡ b8483c44-61d5-4a11-81fd-4419187d210c
warning_box(md"All of this is very advanced and therefore optional content.")

# ╔═╡ 11df4df2-1b15-4c39-b4ad-a65afbf8c93b
md" ## Difference between map and broadcast
### Size mismatch
Based on the input dimensions, `map` and `broadcast` (`.`) act very differently:
"

# ╔═╡ 0ca559d2-6575-4110-91df-530162ae6264
map(+, [1, 2, 3], [10, 20, 30, 40])

# ╔═╡ 4a4c0e1d-6154-4523-bfd4-6859ac723d8a
broadcast(+, [1, 2, 3], [10, 20, 30, 40]) # errors!

# ╔═╡ f88aaeea-4d75-4181-ad9c-afb6046deb3d
[1, 2, 3] .+ [10, 20, 30, 40] # same as `broadcast`

# ╔═╡ f7976448-8a43-419b-902f-ab1b117246bb
md"### Array dimensions & transpose
Today we will learn about vectors, matrices and transposing. 

`map` and `broadcast` act very differently when adding column and row vectors:"

# ╔═╡ b48ecd48-83d8-4609-bbdb-ad9e92001254
map(+, [1, 2, 3], [4, 5, 6]')

# ╔═╡ 7ce6c6b5-5236-4124-b515-69c176a1f99c
broadcast(+, [1, 2, 3], [4, 5, 6]')

# ╔═╡ 19ce9120-53ab-4bc6-b48b-7b14785f2bc7
[1, 2, 3] .+ [4, 5, 6]' # same as broadcast

# ╔═╡ 716d04a9-d8ed-45a9-9335-9565fc0fab90
md"### Generators
A list comprehension that is not collected (without square brackets `[...]`) is called a generator:
"

# ╔═╡ 22428074-972d-402f-a7f5-ea1b46b02272
my_comprehension = [i^2 for i in 1:10000]

# ╔═╡ 7a38fa4d-0142-4ce7-9ce3-008b8cb212a7
my_generator = (i^2 for i in 1:10000)

# ╔═╡ 92c05272-4811-4adb-b73d-1ef601fc00c2
typeof(my_comprehension)

# ╔═╡ e59e5245-d107-4eff-a13f-5d1e8d015c16
typeof(my_generator)

# ╔═╡ aa59ef74-d816-46f8-8337-b0bc580606c2
md"Generators don't allocate:"

# ╔═╡ 2e347ac9-8fd0-4d98-b5a5-42b650024275
sizeof(my_comprehension) # 1000 Int64 => 64000 bit = 8000 bytes

# ╔═╡ a059a5b2-9cbc-4e62-9ccd-be278aeb8470
sizeof(my_generator) # Function + 2 Int64 of range => 128 bit => 16 bytes

# ╔═╡ 03eec63f-b180-4822-aca1-16a36b5f8884
md"For generators, there is a large difference in performance between `map` and `broadcast`:
* `broadcast` first has to call collect all entries in a generator
* `map` has a specialized method for generators

On fully allocated arrays, there will be no difference in performance.
"

# ╔═╡ 51e194c3-0e88-4f72-bd44-60fd6529553e
@benchmark map(sqrt, my_generator)

# ╔═╡ 6ba6fa26-ad81-4798-b422-145763fc2720
@benchmark sqrt.(my_generator)

# ╔═╡ 0b3c2b66-4c12-4fed-af7d-9351ab87b03b
md"## Difference between map and comprehensions
### Filtering
Comprehensions allow additional filtering, `map` doesn't:"

# ╔═╡ 58fce315-293f-46e4-8acc-1c89eb25f40d
[x for x in 1:10 if iseven(x)]

# ╔═╡ baf0d6d7-1f82-4253-8fb2-7677c47f0c78
md"### Return type
List comprehensions always return an array, even when the input was e.g. a tuple:
"

# ╔═╡ a3875468-cb88-4527-84ae-5a04ca91f14b
map(x -> x^2, (1, 2, 3))  # returns Tuple{Int64, Int64, Int64}

# ╔═╡ 532d291e-0bc5-46a6-9415-c98d8bb6d208
[x^2 for x in (1, 2, 3)]  # returns Vector{Int64}

# ╔═╡ c19d69fc-168a-46dc-ad23-9a83622372cf
md"""## Difference between `print` and `@info`
* `print` writes to an output stream, defaulting to `stdout` (standard output, typically your active terminal)
* `@info` is a [logging function](https://docs.julialang.org/en/v1/stdlib/Logging/). There are several others: `@warn`, `@debug`, ...

Logging can have a couple of advantages over printing:
* you see the line it came from
* automatically labels arguments
* can be filtered, disabled
* don't interfere with other IO
* `print` output can be scrambled when using parallelized code
"""

# ╔═╡ 57fd7f6f-e695-4d3c-a739-64ecd1d90d77
print("This is short for...")

# ╔═╡ 645e58e3-613d-4a0b-b0cd-87bd65fc153b
print(stdout, "...this")

# ╔═╡ fc4855ed-d4b4-4d4f-9c92-350c3dc80428
md"# Homework feedback"

# ╔═╡ ff3340a7-03fa-48b6-8980-9eb4c9b74a30
md"## Please enter your name
Don't leave this unmodified. Your name isn't Mara Mustermann!"

# ╔═╡ 1e9a2cee-b038-4bbb-9718-a22ef956e81a
student = (
    name="Mara Mustermann",
    email="m.mustermann@campus.tu-berlin.de", # TU Berlin email address
    id=456123, # Matrikelnummer
)

# ╔═╡ f9b8b173-4f48-4605-8c6b-e522c63fef40
md"## Please replace `missing` with your code
Don't call your variable `missing`!

```julia
function my_sum(xs)
	missing = 0
	for i in xs
		missing += i
	end
    return missing
end
```

`missing` represents missing values and is of type `Missing`:
"

# ╔═╡ 3777af6e-7dfd-42be-b605-905faef1c027
typeof(missing)

# ╔═╡ 85eeb7de-2aa5-4797-83de-8a2256faa1b8
md"## Broadcasting isn't always necessary
For example, the multiplication of a vector by a scalar is mathematically well defined:"

# ╔═╡ f7724f86-dcd3-4f41-b21c-d38c23e8c49d
[1, 2, 3] .* 2  # broadcasting not required

# ╔═╡ b0f3c638-aa92-4abf-8c18-a6fd6816afd8
[1, 2, 3] * 2

# ╔═╡ 0de85d85-962e-4b4b-8569-b68bfb8c0e0d
md"Addition and subtraction of two vectors of the same length is also well defined:"

# ╔═╡ fd30652e-f50d-4801-8c37-7ef0d564bed6
[1, 2, 3] + [2, 2, 3]

# ╔═╡ 37dd57ac-b750-497b-b018-5dc8e4d489c9
[1, 2, 3] - [2, 2, 3]

# ╔═╡ a69cb5a7-5ac4-4de7-ba1b-f0a05b592b01
md"""## Testing for edge cases
Some people wrote tests for several edge-cases in the inputs, for example
```julia
n = length(xs)
n == 0 && error("Empty input array")
```
You did really well!

Julia comes with several functions that start with "`is`", e.g. `iseven`, `isodd`, `isempty`, `isnothing` that can help you write concise tests:
```julia
isempty(xs) && error("Empty input array")
```
"""

# ╔═╡ 433c8a4c-c272-4952-8e54-8ac08c5abf2f
isempty([])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BenchmarkTools = "~1.3.2"
PlutoTeachingTools = "~0.2.11"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "453d5fc03c9a333b91908565ebb6938f9c1b7ecc"

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

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

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
git-tree-sha1 = "8c57307b5d9bb3be1ff2da469063628631d4d51e"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.21"

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
git-tree-sha1 = "88222661708df26242d0bfb9237d023557d11718"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.11"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

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
# ╠═f8f70047-543e-4ee9-a9f2-bb5b5d7bb691
# ╟─ba372f70-9704-429a-859d-64b7a132a6d0
# ╟─d0394d67-f73e-4cde-b3f0-c62da781c1cb
# ╟─dc09ff3a-e8e9-11ed-02be-591ffc3def78
# ╟─239603a3-aeb1-4141-aab3-c1a521145827
# ╟─e3f1ba6b-9b3f-4f06-bc08-a9454627edaf
# ╟─b8483c44-61d5-4a11-81fd-4419187d210c
# ╟─11df4df2-1b15-4c39-b4ad-a65afbf8c93b
# ╠═0ca559d2-6575-4110-91df-530162ae6264
# ╠═4a4c0e1d-6154-4523-bfd4-6859ac723d8a
# ╠═f88aaeea-4d75-4181-ad9c-afb6046deb3d
# ╟─f7976448-8a43-419b-902f-ab1b117246bb
# ╠═b48ecd48-83d8-4609-bbdb-ad9e92001254
# ╠═7ce6c6b5-5236-4124-b515-69c176a1f99c
# ╠═19ce9120-53ab-4bc6-b48b-7b14785f2bc7
# ╟─716d04a9-d8ed-45a9-9335-9565fc0fab90
# ╠═22428074-972d-402f-a7f5-ea1b46b02272
# ╠═7a38fa4d-0142-4ce7-9ce3-008b8cb212a7
# ╠═92c05272-4811-4adb-b73d-1ef601fc00c2
# ╠═e59e5245-d107-4eff-a13f-5d1e8d015c16
# ╟─aa59ef74-d816-46f8-8337-b0bc580606c2
# ╠═2e347ac9-8fd0-4d98-b5a5-42b650024275
# ╠═a059a5b2-9cbc-4e62-9ccd-be278aeb8470
# ╟─03eec63f-b180-4822-aca1-16a36b5f8884
# ╠═7805f29e-fdda-4d59-a5ab-a56bb1e7aece
# ╠═51e194c3-0e88-4f72-bd44-60fd6529553e
# ╠═6ba6fa26-ad81-4798-b422-145763fc2720
# ╟─0b3c2b66-4c12-4fed-af7d-9351ab87b03b
# ╠═58fce315-293f-46e4-8acc-1c89eb25f40d
# ╟─baf0d6d7-1f82-4253-8fb2-7677c47f0c78
# ╠═a3875468-cb88-4527-84ae-5a04ca91f14b
# ╠═532d291e-0bc5-46a6-9415-c98d8bb6d208
# ╟─c19d69fc-168a-46dc-ad23-9a83622372cf
# ╠═57fd7f6f-e695-4d3c-a739-64ecd1d90d77
# ╠═645e58e3-613d-4a0b-b0cd-87bd65fc153b
# ╟─fc4855ed-d4b4-4d4f-9c92-350c3dc80428
# ╟─ff3340a7-03fa-48b6-8980-9eb4c9b74a30
# ╠═1e9a2cee-b038-4bbb-9718-a22ef956e81a
# ╟─f9b8b173-4f48-4605-8c6b-e522c63fef40
# ╠═3777af6e-7dfd-42be-b605-905faef1c027
# ╟─85eeb7de-2aa5-4797-83de-8a2256faa1b8
# ╠═f7724f86-dcd3-4f41-b21c-d38c23e8c49d
# ╠═b0f3c638-aa92-4abf-8c18-a6fd6816afd8
# ╟─0de85d85-962e-4b4b-8569-b68bfb8c0e0d
# ╠═fd30652e-f50d-4801-8c37-7ef0d564bed6
# ╠═37dd57ac-b750-497b-b018-5dc8e4d489c9
# ╟─a69cb5a7-5ac4-4de7-ba1b-f0a05b592b01
# ╠═433c8a4c-c272-4952-8e54-8ac08c5abf2f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
