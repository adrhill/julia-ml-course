### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 755b8685-0711-48a2-a3eb-f80af39f10e1
begin
    using PlutoUI
    using PlutoTeachingTools
end

# ╔═╡ 7e9db4f6-b7a5-46b8-b386-c75c3aa9fcd6
using SparseArrays

# ╔═╡ 5d74be37-f1c2-4a14-afda-2501df203e4f
using OffsetArrays

# ╔═╡ 36a8f7fa-fd1b-4d3a-bdac-ef24a52902bb
using StaticArrays

# ╔═╡ 1acb96c1-c9e8-4b6d-b6a8-51f64d4c9342
using BenchmarkTools

# ╔═╡ 33cfaba3-a1a8-417d-9ab5-3e879ee4f38d
using LinearAlgebra

# ╔═╡ cc0696f1-e2dd-4ffe-9be6-b8307e1ad02b
using UnicodePlots

# ╔═╡ cbfc8bdf-2b6c-4dae-89da-c27342ec6afe
using Distributions

# ╔═╡ 0258bd29-ad24-40b2-b0df-7501040fd5e2
html"""<style>.dont-panic{ display: none }</style>"""

# ╔═╡ 83497498-2c14-49f4-bb5a-c252f655e006
ChooseDisplayMode()

# ╔═╡ 96b32c06-6136-4d44-be87-f2f67b374bbd
TableOfContents()

# ╔═╡ 3870338a-46d8-43f0-8242-23c358cad6d4
PlutoTeachingTools.default_language[] = PlutoTeachingTools.PTTEnglish.EnglishUS();

# ╔═╡ f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
html"""
	<h1 style="text-align:center">
		Julia for Machine Learning
	</h1>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Lesson 2: Introduction to Julia 2
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Arrays & Linear Algebra
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Adrian Hill
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Winter Semester 25/26
		</p>
	</div>
"""

# ╔═╡ 9a2ca93b-104b-40da-9cfe-3f4d06418759
md"""# Vectors
We already introduced vectors in the previous lecture, but didn't give an in-depth explanation. Remember that vectors are defined by comma-separated values inside square brackets:
"""

# ╔═╡ b4394877-36f5-47c7-84a0-ad3b07006a64
v1 = [1, 2, 3, 4, 5]

# ╔═╡ cf66a361-c4ec-47d0-af0d-8a93b6b039c8
md"""In Julia, vectors are just 1-dimensional arrays:"""

# ╔═╡ 8479215a-4d3c-4b9a-8a09-052e06d9f6b6
typeof(v1)

# ╔═╡ c5d3c475-1ee9-4fcb-9080-d2cdafd02ec6
md"""#### Element type
Vectors can be created for any element type. This type can be determined using the `eltype` method:"""

# ╔═╡ cc4e9b18-96ad-49a4-824a-694de19f96a5
eltype(v1)

# ╔═╡ 9d0cce50-7def-4b86-8be8-577023eb1ebd
v2 = ['a', 'b', 'c']

# ╔═╡ ce66d5ec-3fbd-4de1-9bb4-589cfd4b4f2f
typeof(v2)

# ╔═╡ b42f5f36-f9e7-42ee-8eea-1f43f8214680
eltype(v2)

# ╔═╡ 446a5987-671e-4607-8f32-ec237ca339bc
md"We can also specify the type of a vector when creating it. This is usually used to create empty vectors of a specific type."

# ╔═╡ 9740baf3-281b-4089-a462-04fa260f4d82
v3 = Float16[1, 2, 3]

# ╔═╡ 00f52a86-89f8-413a-b4cb-1ee656c01223
v4 = Char[]

# ╔═╡ b30568f8-45a7-4a7f-a8b8-a4c79b05f832
typeof(v3)

# ╔═╡ c9226d77-5c68-4790-8f66-5c91289af6f8
typeof(v4)

# ╔═╡ 664db5e5-95a8-4df4-b0bb-45cb2eccb080
md"""#### Basic functions
We can check the number of dimensions of an array using `ndims`:
"""

# ╔═╡ 4aa43df6-0d41-4e88-b4d8-6ea032806690
ndims(v1) # a vector as a 1-dimensional array.

# ╔═╡ 6147e9dd-0b82-404e-a101-b093c09169ec
md"We can inspect the `length` of a vector:"

# ╔═╡ 94879b08-2f78-4381-b21d-e9871063c653
length(v1)

# ╔═╡ 2a095c63-7f19-4ae8-b5ab-4b55f1526c95
md"The `size` of an array is a tuple of dimensions. In the case of vectors, this returns a singleton tuple containing the length:"

# ╔═╡ de13197d-7859-4bfe-832d-599308b0687e
size(v1)

# ╔═╡ 9a6afc4a-6c66-4ed1-9a6b-3c3219af6449
md"We can also check the size in memory in bytes:"

# ╔═╡ a908908d-2975-4c79-b598-e7c3b1463be2
sizeof(v1) # 5 Int64s => 5 * 64 bit = 5 * 8 bytes = 40 bytes

# ╔═╡ 878c9121-89d0-42fc-93bd-5effd858a3ff
md"""## Ranges
We already introduced ranges last week. Collecting a range results in a vector:
"""

# ╔═╡ 4fe94090-7fd2-412a-84d1-19f7cd2a0f4e
v5 = collect(1:5)

# ╔═╡ d719e5e1-5921-4ea9-b78d-462cb7b3810d
typeof(v5)

# ╔═╡ bec92f62-4968-4d8f-a65a-656691f27059
md"""## Comprehensions
We also introduced comprehensions as a way to define vectors:
"""

# ╔═╡ d52bbae5-eda6-4fc1-bb22-41ef617087c6
v6 = [sqrt(x) for x in 1:10]

# ╔═╡ a7ba5441-8ddb-4ffc-ae99-795dab26f1a8
v7 = [sqrt(x) for x in 1:10 if x % 2 == 0]

# ╔═╡ c66a192f-8bd7-462d-a062-cb670b07b723
md"""## Indexing
We can index into vectors using square bracket notation.

Let's create a small test vector with values from 1 to 10 for this purpose:
"""

# ╔═╡ 98ad601f-b944-4d79-a3c2-5c94bf17b50a
one_to_ten = collect(1:10)

# ╔═╡ 7eac40f2-4179-47d7-83e9-c4a5db964c7d
warning_box(md"Keep in mind that Julia's index is 1-based to match mathematical notation!")

# ╔═╡ 7157d0ad-57a1-4feb-ba78-038ea61f2f1b
one_to_ten[2] # second entry

# ╔═╡ 5e468ba7-8ad2-459f-8650-41492a1b5a63
one_to_ten[4] # fourth entry

# ╔═╡ 13f51add-f821-414e-9ef1-41f92fb83421
one_to_ten[2:4] # second until fourth entries

# ╔═╡ d86c915a-be35-4a08-a0a9-c71043ce65cf
one_to_ten[begin+2:end-6] # relative indexing

# ╔═╡ 0a6d5f26-4bcc-4576-a71b-8a1376e2a921
one_to_ten[4:-1:2] # iterate in reverse

# ╔═╡ 12ac4c1b-1117-4f0f-8ebe-10967e34bd8d
one_to_ten[[1, 3, 5]] # index values at specific positions 1, 3, 5

# ╔═╡ eb58ff2a-f72c-4f06-948e-0400f79ca2d6
md"Indexing will allocate a new vector in memory that is independent of the original (it makes a copy): "

# ╔═╡ 73b4a85d-ab44-4445-973e-a309235605af
begin
    x1 = collect(1:10)
    y1 = x1[2:4] # copy part of x1 into new vector y1

    @info y1
    @info x1

    y1[1] = 42   # modify first entry in y1 to be 42
    @info y1  # y1 has changed    🟧
    @info x1  # x1 hasn't changed 🟪
end

# ╔═╡ 9511b49a-936c-4c43-b03b-eab3cb86ef8a
md"""## Views
Making a copy of an array is slow since we need to write all entries to memory.
Instead, we can use views to provide "a window" onto the relevant data in memory:
"""

# ╔═╡ 7b9f2e69-1235-4cfd-a97c-444555408241
view(one_to_ten, 2:4)

# ╔═╡ b0f71fe4-ee8e-47a8-a815-f1b082fb8763
md"With the `@view` macro, we can use the previously introduced index-notation:"

# ╔═╡ 5c546e19-cc3c-479a-84ca-b0615b0e4d88
@view one_to_ten[2:4]

# ╔═╡ 95e5e4f3-a989-4127-a61e-9fa9d3bea279
@view one_to_ten[begin+1:end-6]

# ╔═╡ 72485a86-5f90-4b8e-8827-ba3ca4af67c1
md"Views are of type `SubArray`:"

# ╔═╡ a7c24649-a826-44fd-bd4d-3bc00bcc2373
typeof(@view one_to_ten[2:4])

# ╔═╡ 9ef878c2-c444-49d3-bf6c-4fa7d5d44e5d
md"Modifying a view will also modify the original array:"

# ╔═╡ 6079c3b6-ea6f-4128-bd2f-2aa6631dd2d3
begin
    x2 = collect(1:10)
    y2 = @view x2[2:4] # create view onto x2

    @info y2
    @info x2

    y2[1] = 42   # modify first entry in y2 to be 42
    @info y2  # y2 has changed   🟧
    @info x2  # x2 ALSO changed! 🟧
end

# ╔═╡ 43c078fb-7964-48e0-92fd-55d306f36b1d
#! format: off
tip(
md"If a method requires a lot of calls to `@view`,
you can also use the `@views` macro (with an extra `s`) on a function, loop, or `begin ... end` block
to turn every indexing operation inside of it into a view!

**Example:**
The previous code block could have been written as

```julia
@views begin # every indexing operation in this code block will create a view
	x2 = collect(1:10)
	y2 = x2[2:4] # creates view onto x2 due to @views
	y2[1] = 42
end
```
",
)
#! format: on

# ╔═╡ b9a0dd69-02e5-4535-99f1-fa11cbe69b15
md"""## Type promotion ⁽⁺⁾
When directly constructing an array with "square bracket syntax", the arguments inside the brackets are promoted in type. You can view this as an implementation detail, but it is good to be aware of this behavior.

If all inputs have a common promotion type, that type will be the array `eltype`.
Otherwise, the `eltype` will be `Any`:
"""

# ╔═╡ 1862d034-ba74-4d58-a566-248e47a6c4d2
v8 = [1, 2.3, 4//5]

# ╔═╡ 89892503-524b-43c5-bd35-430be8febacf
typeof(v8)

# ╔═╡ d4a009e8-9bb3-40bb-a43c-113ea31beec7
md"Some combinations of types don't have a common promotion type. This ends up creating a `Vector{Any}`:"

# ╔═╡ 27d7f892-964d-4871-97df-dda3376b5c42
does_not_promote = ["String", 1.4]

# ╔═╡ 6381fd9c-84cd-41f0-a13f-669a16f270cf
typeof(does_not_promote)

# ╔═╡ 8a3ff2f1-0de7-4840-b431-ff44691e1ff3
md"""### Avoiding type promotion

If type promotion is not desired, explicitly create a `Vector{Any}`
"""

# ╔═╡ 5c7d8961-ebb5-43fc-87e5-5f5bea48074b
v9 = Any[1, 2.3, 4//5]

# ╔═╡ fcbd3119-1a47-40c8-a7a5-652d9c293824
eltype(v9)

# ╔═╡ 2226efa4-d82b-454a-8dbb-2680847f601e
typeof.(v9)

# ╔═╡ 8627b598-00e6-407e-b92e-eec529b4b033
md"or use a tuple:"

# ╔═╡ 193ff069-ff3e-4e6d-a878-9ba3b3718802
t1 = (1, 2.3, 4//5)

# ╔═╡ ca4994de-c22f-44e5-bbdf-7c6099a0229a
typeof(t1)

# ╔═╡ 79c55150-0457-49b7-90a5-2cad980b2cb9
tip(
    md"""
For performance reasons, it is best to avoid Vectors of type `Vector{Any}`: Julia's compiler can't infer element types and therefore also can't specialize code, resulting in bad performance.

You can find out more about type promotion in the [Julia documentation on Conversion and Promotion](https://docs.julialang.org/en/v1/manual/conversion-and-promotion/#conversion-and-promotion).
""",
)

# ╔═╡ 30bd74d2-4cae-4f85-88fe-840fbf4af1aa
md"# Arrays"

# ╔═╡ e5e1c14f-fa2a-4618-b55b-cbfc58286184
md"""## Matrices
We just learned that **vectors are 1-dimensional arrays**.

A **2-dimensional array is called a Matrix**.
Matrices are defined using square brackets with additional symbols to indicate the desired type of concatenation:

- Horizontal concatenation (*column-wise*): spaces, tabs and double semicolons `;;`
- Vertical concatenation (*row-wise*): newlines and semicolons `;`

There are many possible ways to define matrices and block-matrices by combining these. Here are two common examples:
"""

# ╔═╡ cc059efb-a983-4068-ae64-a11cd6b54a51
M1 = [1 2; 3 4] # spaces between entries in row, semicolon between rows

# ╔═╡ cafa1dde-44ff-4601-a85c-6e193e9a3904
M2 = [
    1 2 # spaces between entries in row
    3 4 # newline between rows
]

# ╔═╡ 402547f6-fcde-420a-a4ea-10e199f5e2db
md"""## N-dimensional arrays
Arrays of dimension 3 and larger are called tensors.

### Manual definition ⁽⁺⁾
You will rarely have to write large tensors by hand, but Julia does [provide syntax for it](https://docs.julialang.org/en/v1/manual/arrays/#man-array-concatenation):

> Just as `;` and `;;` concatenate in the first and second dimension, using more semicolons extends this same general scheme. The number of semicolons in the separator specifies the particular dimension, so `;;;` concatenates in the third dimension, `;;;;` in the 4th, and so on.
"""

# ╔═╡ 457f1574-0f12-45a0-8e78-0af8fde8ee5d
A1 = [[1 2; 3 4];;;; [5 6; 7 8]] # concatenate two 2x2 matrices in the fourth dimension

# ╔═╡ 38b55332-0340-4fba-87f4-f7b7c2f9cbe2
md"""### Concatenation & reshaping
An much easier way is to use `cat` to con*cat*enate arrays
"""

# ╔═╡ 14c1da48-e07c-43bd-b8f4-eb393ddbd9b5
A2 = cat(M1, M2; dims=3) # concatenate two 2x2 matrices in the third dimension

# ╔═╡ 047b7fb9-9b51-49a7-859d-51c16ac31fff
md"or to reshape arrays and ranges:"

# ╔═╡ 10f75ce8-fe3a-4014-9c67-17c8f8b1bb71
reshape(1:18, 2, 3, 3)

# ╔═╡ 423e562d-5563-4d4b-9c2e-6f52d312ded5
md"The `reshape` functions takes as many parameters as dimensions you want to reshape to.

For example, to reshape an array $A$ to shape $p \times q \times r \times s$,
call `reshape(A, p, q, r, s)`.
"

# ╔═╡ ecd6d456-e9a0-4218-b90a-a1cd70815dc9
md"""## Basic operations
The operations `eltype`, `length`, `size` we've previously seen are defined for all types of arrays:
"""

# ╔═╡ 8c2e00ba-342b-42ce-8a06-07f8c82c321f
A = [1 2 3; 4 5 6]

# ╔═╡ f014020d-060b-44cd-8efe-e87483937307
eltype(A)

# ╔═╡ f1e58e16-40b5-4926-af00-2dc6c27a3d5a
size(A)

# ╔═╡ d36517ef-9905-4014-abda-11f6d19dc682
size(A, 2) # size along second dimension

# ╔═╡ 784bed8b-d0e1-4deb-af3a-1e8b9a727de4
length(A) # number of elements in matrix

# ╔═╡ 86ae9373-e349-4cef-a88d-1938a2675dfa
ndims(A) # number of dimensions

# ╔═╡ 9242d6ad-d2be-429a-8fb6-009dabddea40
reshape(A, 3, 2)

# ╔═╡ 2fe2256b-d99d-4f24-bab9-4a891da386b8
md"""## Comprehensions
Comprehensions can be used to define arrays of any dimensionality, not just vectors:
"""

# ╔═╡ 69f660d8-f45c-45ce-a3df-8c1df3cd2a3b
[complex(r, i) for r in 1:5, i in 6:10]

# ╔═╡ 82083ec4-6a42-4665-bce3-d7ebc1fa2df2
[x + y + z for x in 0:2, y in 0:9, z in 0:1]

# ╔═╡ 14445130-1469-4529-8305-02d2f330885a
md"Comprehensions can not only be used on `Number` types:"

# ╔═╡ bc93128f-7a09-4843-87c2-1977c55fa13d
greetings = ["Hello", "Hallo", "Bonjour"];

# ╔═╡ f3bcaf2b-91b5-49d6-938c-28ad1aee9908
names = ["Adrian Hill", "Klaus-Robert Müller"];

# ╔═╡ b4260f9b-f5ed-45a5-9e77-daddf56710cd
["$g $n" for g in greetings, n in names]

# ╔═╡ 6a405fa8-c679-4c8e-acf3-591fed68ec45
md"""## Indexing & Views
Indexing and views work just like on vectors. Just like in mathematical notation, the first index references rows, the second columns.
"""

# ╔═╡ 37c6c024-a242-4aff-8af4-1e71688d6819
A3 = reshape(1:20, 4, 5)

# ╔═╡ 926c6289-e960-494b-a8e4-774fe1894f20
A3[3, 2]

# ╔═╡ 2ff4b81a-f5e7-4148-89df-471650c9a873
A3[begin:3, 2:end-1] # begin and end also work

# ╔═╡ 5b9b145b-aa4d-4a9d-ade7-fbc893c18191
@view A3[begin:3, 2:end-1]

# ╔═╡ 1f25d491-1020-4258-b05d-e4110ee248a2
md"The column `:` symbol can be used as a shorthand for `begin:end`"

# ╔═╡ 8c30062e-0469-4763-b785-9ba18c238aed
A3[2, :] # second row, all columns

# ╔═╡ cde02e4f-ea3e-4353-b687-ce8d24c7c77d
md"Matrices can also be indexed by scalar values. This will iterate column-first through an array:"

# ╔═╡ a0c66bd2-a8dd-4150-bd9f-3957aa107f47
A3[6] # since we reshaped a range, A3[i] == i

# ╔═╡ 01a81f6f-a138-4fe7-8bd7-fa2a727ae68d
md"""## Special array constructors
There are also special methods to initialize arrays which are used quite often in numerical algorithms.

These often follow the syntax `function_name(Type, dims...)`, where `Type` and `dims` are both optional.

### Zeros and Ones
To obtain a matrix filled with zeros, use `zeros`:
"""

# ╔═╡ 34cb8bbb-89dd-4f33-bc1d-9b554ae80819
zeros(5) # vector

# ╔═╡ 29fa1439-1638-4512-ae70-a08c8702cf76
zeros(3, 3) # matrix

# ╔═╡ 352f0d14-5f22-4148-a116-bd27ba4927fe
zeros(Int, 3, 5, 2) # 3-dim array of type Int

# ╔═╡ 9ff329af-cde2-44ac-aae0-4b5e7a1b6b46
md"The function `ones` works in exactly the same way as `zeros`, but creates a matrix of ones:"

# ╔═╡ baa1b29a-d7ce-49eb-81dc-c37ef8266df7
ones(Float32, 3, 3) # matrix of type Float32

# ╔═╡ 9a91298d-c31d-48c9-93f4-28ae030b0ee2
tip(md"We will get to know identity matrices in the section on LinearAlgebra.jl!")

# ╔═╡ 9a80a295-da3e-459e-9312-2712d14456cb
md"### Pre-allocating matrices ⁽⁺⁾
Writing zeros and ones can take some time. Sometimes, we just want to make some space in memory to write our results into. This is called *pre-allocation*.
"

# ╔═╡ 3c07cbb9-2e8c-4971-8866-7ce2384750f2
md"""To create a matrix from scratch, we call the array constructor with `undef`:"""

# ╔═╡ 08545994-0432-40fb-968c-2d1fca11baad
out1 = Array{Float32}(undef, 3, 3)

# ╔═╡ c87a91ab-094e-4826-b171-1015a918c050
md"""If we want to allocate a matrix of the same shape as another matrix, `similar` is very convenient:
"""

# ╔═╡ 25c98cd3-c439-4c3c-88ef-f55fbe597f9c
out2 = similar(out1) # similar type and shape

# ╔═╡ 1e517d20-ef94-48e6-95b9-dabaac9e912e
out3 = similar(out1, Int) # similar shape, but different type

# ╔═╡ de14c13d-2059-4d07-9b76-d4d0285965d2
out4 = similar(out1, 4, 5) # similar type, but different shape

# ╔═╡ a3af0ab4-330c-46ec-a686-5b2230297086
md"""## Other array types ⁽⁺⁾
Not only the standard `Array` type can be used. The Julia standard library also provides sparse arrays and several packages implement their own types of arrays.
"""

# ╔═╡ 951c7a53-c90c-43b4-8028-a09a37f6a34c
md"""### SparseArrays.jl
Sparse arrays are arrays that contain mostly zeros, making it faster and more memory efficient to introduce a special data structure and matching algorithms.

"""

# ╔═╡ cfa047b9-e15d-403a-a2f0-9dbc0879a382
SA = sparse([1, 3, 2, 2], [2, 8, 4, 6], [2, 3, 4, 5]) # rows, columns, values

# ╔═╡ c30ff6f2-b034-4d3a-85db-6a6052bab764
md" Thinking of the inputs as a table can be helpful:

| Entry | Row | Column | Value |
|:-----:|:---:|:------:|:-----:|
| 1     | 1   | 2      | 2     |
| 2     | 3   | 8      | 3     |
| 3     | 2   | 4      | 4     |
| 4     | 2   | 6      | 5     |
"

# ╔═╡ 22929fda-ddc7-4c1e-bc30-b6f6c30c2e3a
md"""### OffsetArrays.jl
You really love Julia, but want zero-based indexing? Why not use [OffsetArrays.jl](https://github.com/JuliaArrays/OffsetArrays.jl)!

This package allows you to define arbitrary (positive, zero or negative) starting indices to each axis of an array. Let's define a zero-based matrix:
"""

# ╔═╡ 2118b306-0a10-4aa9-9198-52c062f18cd2
A

# ╔═╡ 635185b7-cffc-43ff-8245-b2db15bf7eda
OA = OffsetArray(A, 0:1, 0:2) # row indices from 0 to 1, columns from 0 to 2

# ╔═╡ 75e1b1d6-1258-4294-920d-2937e28942b9
OA[0, 0]

# ╔═╡ a705cf00-e54e-4ce6-ba26-3fede17cfd97
md"We don't have to stick to zero-based indexing – we can use any indices we want:"

# ╔═╡ d93fba29-1254-44d3-b1f4-1a83b776a9d9
OA2 = OffsetArray(A, -10:-9, 5:7) # row indices from -10 to -9, columns from 5 to 7

# ╔═╡ a1651444-9c28-4e99-a782-c4d32305d176
OA2[-9, 6]

# ╔═╡ 03c6a14f-e616-4007-9903-c1d53651d854
md"Everything we've learned about indexing and views also applies to OffsetArrays:"

# ╔═╡ 1f0a67e3-cbfc-4ce9-8206-0ab08b8e236b
@view OA[1, 1:end]

# ╔═╡ 2328e00b-3ff7-4dee-a5a2-67457cc44172
md"""### StaticArrays.jl
Sometimes, you will be working with statically sized arrays, e.g. to describe a rotation matrix.

Arrays from [StaticArrays.jl](https://github.com/JuliaArrays/StaticArrays.jl) can provide a huge performance benefit, as we will demonstrate on the computation of the inverse of a 3x3-Matrix.
"""

# ╔═╡ cbc8d493-4626-4a07-93d6-06c83921741d
M = [1 2 3; 4 6 5; 7 8 9] # regular matrix

# ╔═╡ 8e66d903-df13-4256-ae2d-8b90cea7612a
md"Static arrays use additional information about their size in their type:"

# ╔═╡ e592bec1-131b-4185-ab55-9dff949ef2da
SM = SMatrix{3,3}(M) # matrix type from StaticArrays.jl

# ╔═╡ ea91c44f-0ea4-4a1a-a284-9bf1453abd82
md"""We can benchmark functions by using the `@benchmark` macro from [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl). This will run each function multiple times and show us statistics and a histogram of the run-times:
"""

# ╔═╡ dfdd7a5c-0381-4e0d-a9dc-b380a3ce05a5
@benchmark inv(M)

# ╔═╡ 6779db72-ef4a-45d7-be24-fefa18075d65
@benchmark inv(SM)

# ╔═╡ 4cf438ef-ae36-4513-92f3-e46265d07eea
md"""## Iterating over arrays
Let's motivate array iteration by first showing a bad implementation of a function that prints each row of a matrix:
"""

# ╔═╡ 867c276d-4c43-4465-bc9b-621b97c0d2b8
function iterate_over_rows_bad(A::AbstractMatrix)
    n_rows = size(A, 1)
    for i in 1:n_rows
        @info A[i, :]
    end
end

# ╔═╡ 83814d80-abf3-4af5-aa6a-d0c7e74c4751
A

# ╔═╡ c1eace49-8c87-4588-b217-639fff2cd4f0
iterate_over_rows_bad(A) # works!

# ╔═╡ 885a9701-aa90-4c16-a982-d975acd03aba
md"""Our function works on the matrix `A`. However, the argument type declaration `::AbstractMatrix` of our function claims that it works on any matrix type!

Let's see what happens when we pass our previously defined OffsetArray:
"""

# ╔═╡ da710739-213b-4865-90a0-855895890bbf
OA

# ╔═╡ fee286b7-c274-4561-a4e9-23273b66d550
iterate_over_rows_bad(OA)

# ╔═╡ 1c820bf5-71ee-4139-b041-8a93a7afd138
md"""We get an out of bounds error!

`nrows` is still two, such that the print statement in the for-loop will try to print `OA[2, :]`.

A more robust implementation uses the iterator `eachrow`:
"""

# ╔═╡ 8717d822-3677-48ed-9f86-8b66dcdb8caa
function iterate_over_rows_good(A::AbstractMatrix)
    for row in eachrow(A)
        @info row
    end
end

# ╔═╡ 69668aa9-d245-4ed6-8389-d0cc0e802727
iterate_over_rows_good(A) # works and automatically uses views!

# ╔═╡ 5cee46db-8312-4b08-a057-093379903881
iterate_over_rows_good(OA) # also works and uses views!

# ╔═╡ 4d822c49-07de-4127-ade7-c339fe10076e
tip(
    md"""When iterating over arrays, it is recommended to use the following iterators whenever possible:

- `eachrow` - iterate over rows
- `eachcol` - iterate over columns
- `eachslice` - iterator over any slice of an nd-array
- `eachindex` - iterate over all indices of an array
""",
)

# ╔═╡ b12348a8-53dc-4a4d-8666-3849e94bdece
md"""# Linear Algebra
The LinearAlgebra.jl package is part of the Julia standard library, but needs to be explicitly loaded:
"""

# ╔═╡ e48d1f75-db8e-4b6e-9ad1-7546963fc49b
md"LinearAlgebra.jl provides all the functions you would expect from a linear algebra package:"

# ╔═╡ 9ed3a23a-5738-4205-91e5-5081fe6be3e1
M

# ╔═╡ 2a65cc87-49c8-401c-b16e-abff7f06b079
det(M) # determinant

# ╔═╡ 48417d74-9c91-4d34-bcf9-e074d5b079ba
tr(M) # trace

# ╔═╡ 48773893-9a65-47ea-b605-21b553b0cabd
inv(M) # matrix inverse

# ╔═╡ dffa4508-98ac-40b2-b65b-87622603366d
norm([1, 2, 3]) # ℓ2-norm

# ╔═╡ e942c28f-e557-4c83-af4d-ee344040778d
norm([1, 2, 3], 1)  # ℓ1-norm

# ╔═╡ a2ccdd44-f7ab-4e19-847a-149a4e2bb077
md"""## Matrix multiplication
In Julia, matrices are multiplied using the standard `*`-operator. Let's try multiplying some simple arrays.
"""

# ╔═╡ 222f01fa-57be-4b8e-8fcf-1892a0b85f17
M

# ╔═╡ 02664c9d-53c5-46e0-ac6c-127107579ab1
u = [1, 2, 3]

# ╔═╡ 3ae5516f-9354-4125-87ea-764d8e124d4b
v = [4, 3, 2]

# ╔═╡ cb8b6d98-d2aa-4ecb-9548-3e6d4ee7fdc9
md"""When multiplying two arrays $X\in\mathbb{R}^{a \times b}$ and $Y\in\mathbb{R}^{c \times d}$,
Julia expects the dimensions $b$ and $c$ to match. Otherwise we get a `DimensionMismatch` error.
"""

# ╔═╡ a88db4a6-b60b-4c12-8448-262740fd07a4
M * v # works

# ╔═╡ ef1c6a7f-4b68-46d6-a7d3-3b1aa13e0f6e
u * M # Error: u has dimensions (3, 1), but M has dimensions (3, 3)

# ╔═╡ e6c32403-a422-4cb1-8ea0-cbd80030ea3d
md"Vectors in Julia are column vectors of size $\mathbb{R}^{n\times 1}$. We can reshape them to $\mathbb{R}^{1\times n}$ row vectors using `transpose`:"

# ╔═╡ b72a9365-ce81-4c9b-938e-50bc2b29feaf
transpose(u)

# ╔═╡ 038e232d-e50d-4cb6-a40e-5ed40686ff6a
md"Since `u` is real-valued, we can also use `'`, the *adjoint* operator (also known as *conjugate transpose*):"

# ╔═╡ 23eaeb9b-f8a8-488d-b285-73878b0010b8
u'

# ╔═╡ afb737fc-a1bf-4f31-bf29-6dcee181b984
md"Now that the shapes match, we can multiply our arrays:"

# ╔═╡ 1a0d6200-263b-4861-a588-928301f758d2
u' * M  # (1, 3) × (3, 3) → (1, 3)

# ╔═╡ 19b9fb94-3f35-4acb-9a4a-6e73cf4bc727
u' * M * v

# ╔═╡ 8412c69c-657d-40d0-bae5-d73c7a0a06a5
md"Note that matrix multiplication on higher order tensors is undefined."

# ╔═╡ eec78205-4f49-4d72-882f-a0574e953c83
md"""## Dot product
Let's compute the [dot product](https://en.wikipedia.org/wiki/Dot_product) of two vectors.

$u \cdot v = \sum_i u_i v_i$

As we have learned on the previous slide, `u * v` implements matrix multiplication and will throw an error since the dimensions of `u` and `v` don't match up.

We can however implement the dot product by first transposing `u`, such that $u^T\in\mathbb{R}^{1\times n}$, $v\in\mathbb{R}^{n\times 1}$
"""

# ╔═╡ d227da3b-2283-4e62-91cd-01014c979a28
transpose(u) * v

# ╔═╡ 763a91c4-bfdc-419a-a870-ea47a03864c7
u' * v

# ╔═╡ 6f4e2428-bbe9-43c6-8e24-e7bf4bb1c828
md"LinearAlgebra also provides a function `dot`, which can be used via the operator `⋅` (`\cdot<TAB>`):"

# ╔═╡ 6d474dbf-0036-4f68-aaa8-1478b37a5a4b
dot(u, v)

# ╔═╡ 3387ba55-9cea-4cdc-bf62-106b2b432098
u ⋅ v

# ╔═╡ 6ab6588e-2c9d-43c8-aee2-b21ae851f53f
md"## Identity matrix
In Julia, we don't have to allocate identity matrices. LinearAlgebra's `I` represents identity matrices of any size:
"

# ╔═╡ 4bc40852-4d0d-4d89-aa04-c91b32e2fc04
I # Indentity matrix is of type `UniformScaling`

# ╔═╡ 8ef0fc0b-cb56-45f5-ab5f-ddc7fda987e6
md"The identity matrix acts as the multiplicative identity of all matrices:

$I_m A = A I_n = A \quad,\, \forall A \in \mathbb{R}^{m \times n}$
"

# ╔═╡ a299c289-7a51-43ef-94d6-8c8cd42f8439
A

# ╔═╡ 3b855422-9901-41a1-9d1f-10cb24fb23ba
I * A

# ╔═╡ bed771b5-67ea-4b20-a51c-5928beadcd9a
A * I

# ╔═╡ e52f9416-a362-4c2d-be06-4604a3efbc1c
md"""# Random numbers
The Julia standard library provides several functions to sample random numbers. We will demonstrate two of them:
- `rand`: sample from a uniform distribution $\mathcal{U}_{[0, 1]}$
- `randn`: sample from a Normal distribution $\mathcal{N}(0, 1)$
"""

# ╔═╡ dc851849-e33d-4438-a958-8a100b91f54f
rand()

# ╔═╡ 16c58360-558e-4879-a36c-66a877519a3e
randn()

# ╔═╡ cdc0782e-0973-470e-9873-8ab1b90e3b24
md"Let's draw a vector of `50k` values and visualize it in a histogram to make sure everything works as expected:"

# ╔═╡ f570e5f3-8e09-45e2-8934-f354e813a58e
rand(50000) |> histogram

# ╔═╡ 9f795a3a-092b-460a-8a04-d8605cf84384
randn(50000) |> histogram

# ╔═╡ dcf55c61-2578-49a6-8f58-39fb864693e5
md"We can draw arrays of random numbers in any shape"

# ╔═╡ 119ed15e-12ea-49d3-bc97-ddfc1398c4b7
rand(2, 3, 2)

# ╔═╡ d0e3fd22-099b-4cfe-877e-3dc02e9aa55e
md"and even specify the desired output type:"

# ╔═╡ 38295c2d-ba33-450d-aefc-50b376a64c81
rand(Float32, 2, 3, 2)

# ╔═╡ 203ad6b0-b351-45ce-8fcd-37838d6c1c1b
tip(
    md"""`rand` and `randn` can also be used deterministically by passing random number generators:
```julia
julia> using Random

julia> rng = MersenneTwister(1234); # use seed 1234

julia> randn(rng, Float32)
0.8673472f0
```
""",
)

# ╔═╡ f9486534-424a-4913-8396-35e3be4f8d17
md"""## Sampling from Iterables
You can also sample from any iterable: ranges, vectors, strings, tuples etc.
"""

# ╔═╡ baede2c8-50ff-4623-8742-e35917619f13
rand(1:4, 4, 4)

# ╔═╡ 44edff64-13d7-4378-8e21-088b4dbe419c
rand((5, 9), 4, 4)

# ╔═╡ bc714282-1c97-448b-b99e-3d496fed3a5a
rand("abc", 4, 4)

# ╔═╡ fee81d18-ab33-4928-8c60-68111507bc14
week_meal_plan = rand(["Pizza", "Salad", "Soup"], 3, 7)

# ╔═╡ 8ba035af-aed3-4b6c-a3bb-f73a46415d3b
md"""## Sampling from Distributions
We can use the package [Distributions.jl](https://github.com/JuliaStats/Distributions.jl) to define more complex distributions and sample from them:
"""

# ╔═╡ 5da0c56f-c6f4-4bff-9446-99180624b002
begin
    μ = 0
    θ = 1
    distribution = Laplace(μ, θ)
    rand(distribution, 50000) |> histogram
end

# ╔═╡ b857984b-ec1b-4409-bdf0-438228950f39
md"""# Broadcasting on arrays
We've already seen broadcasting on vectors in the previous lecture.
For higher-dimensional arrays, the behaviour is [a bit more complicated](https://docs.julialang.org/en/v1/manual/arrays/#Broadcasting):

>  Broadcast **expands singleton dimensions in array arguments to match the corresponding dimension in the other array** without using extra memory, and applies the given function elementwise

Let's go through an example and broadcast addition on

$\begin{align}
P &\in \mathbb{R}^{2×3×1×1×1} \\
Q &\in \mathbb{R}^{1×1×4×5} \quad .
\end{align}$

Julia will expand $P$ and $Q$ to

$\tilde{P},\,\tilde{Q} \in \mathbb{R}^{2×3×4×5×1}$


without allocating extra memory, then add them:

$R = \tilde{P} + \tilde{Q}$

This results in $R \in \mathbb{R}^{2×3×4×5×1}$.
"""

# ╔═╡ 02e99648-f457-469d-88b0-0cec5cb5826d
P = rand(2, 3, 1, 1, 1);

# ╔═╡ fc9e4870-9411-4feb-a459-8ce4124187f7
Q = rand(1, 1, 4, 5);

# ╔═╡ c25aec0f-b215-4bda-910d-e29268448623
R = P .+ Q;

# ╔═╡ bd968691-948a-4214-b49f-7faf52d407a4
size(P)

# ╔═╡ 4b39a76b-1206-495c-b68d-47efb85acfa5
size(Q)

# ╔═╡ eb9042f0-a46f-4104-88b4-dfc406df9481
size(R)

# ╔═╡ b2cdd7d0-e009-4fca-a16b-ddd19cabc6a0
md"""# Further resources
In this lecture, we didn't get to cover Cartesian Indices, which are a great tool for implementing algorithms on high-dimensional arrays.
The following blogpost gives a great introduction:

- [Multidimensional algorithms and iteration](https://julialang.org/blog/2016/02/iteration/)  by Tim Holy
- [Julia documentation on Cartesian Indices](https://docs.julialang.org/en/v1/manual/arrays/#Cartesian-indices)

Besides *SparseArrays.jl*, *OffsetArrays.jl* and *StaticArrays.jl*, the Julia ecosystem has many more packages to offer:

- [JuliaArrays](https://github.com/JuliaArrays): organization on GitHub that maintains packages implementing custom array types
- [JuliaLinearAlgebra](https://github.com/JuliaLinearAlgebra): organization on GitHub that maintains packages implementing linear algebra methods and matrix types
- [Tullio.jl](https://github.com/mcabbott/Tullio.jl): einsum macro that also works on GPUs
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
OffsetArrays = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
UnicodePlots = "b8865327-cd53-5732-bb35-84acbb429228"

[compat]
BenchmarkTools = "~1.6.0"
Distributions = "~0.25.118"
OffsetArrays = "~1.16.0"
PlutoTeachingTools = "~0.3.1"
PlutoUI = "~0.7.62"
StaticArrays = "~1.9.13"
UnicodePlots = "~3.7.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "8ccd917b567192666d9fd997091f9e5d0bcb61aa"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BenchmarkTools]]
deps = ["Compat", "JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "e38fbc49a620f5d0b660d7f543db1009fe0f8336"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.6.0"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "0b4190661e8a4e51a842070e7dd4fae440ddb7f4"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.118"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "68c173f4f449de5b438ee67ed0c9c748dc31a2ec"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.28"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "a434e811d10e7cbf4f0674285542e697dca605d0"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.42"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cd714447457c660382fe634710fb56eb255ee42e"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.6"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "688d6d9e098109051ae33d126fcfc88c4ce4a021"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "72aebe0b5051e5143a079a4685a46da330a40472"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.15"

[[deps.MarchingCubes]]
deps = ["PrecompileTools", "StaticArrays"]
git-tree-sha1 = "0e893025924b6becbae4109f8020ac0e12674b01"
uuid = "299715c1-40a9-479a-aaf9-4a633d36f717"
version = "0.1.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "cc0a5deefdb12ab3a096f00a6d42133af4560d71"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "a414039192a155fb38c4599a60110f0018c6ec82"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.16.0"

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

    [deps.OffsetArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+4"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "48566789a6d5f6492688279e22445002d171cf76"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.33"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

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
deps = ["Downloads", "HypertextLiteral", "Latexify", "Markdown", "PlutoLinks", "PlutoUI"]
git-tree-sha1 = "8252b5de1f81dc103eb0293523ddf917695adea1"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.3.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Profile]]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9da16da70037ba9d701192e27befedefb91ec284"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.2"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.Revise]]
deps = ["CodeTracking", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "5cf59106f9b47014c58c5053a1ce09c0a2e0333c"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.7.3"

    [deps.Revise.extensions]
    DistributedExt = "Distributed"

    [deps.Revise.weakdeps]
    Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "852bd0f55565a9e973fcfee83a84413270224dc4"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.8.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58cdd8fb2201a6267e1db87ff148dd6c1dbd8ad8"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.5.1+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "64cca0c26b4f31ba18f13f6c12af7c85f478cfde"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.5.0"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "0feb6b9031bd5c51f9072393eb5ab3efd31bf9e4"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.13"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "29321314c920c26684834965ec2ce0dacc9cf8e5"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.4"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "b423576adc27097764a90e163157bcfc9acf0f46"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.2"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodePlots]]
deps = ["ColorSchemes", "ColorTypes", "Contour", "Crayons", "Dates", "LinearAlgebra", "MarchingCubes", "NaNMath", "PrecompileTools", "Printf", "SparseArrays", "StaticArrays", "StatsBase"]
git-tree-sha1 = "24c0e2df19eb3f894d28a64e7486926f38de8a49"
uuid = "b8865327-cd53-5732-bb35-84acbb429228"
version = "3.7.2"

    [deps.UnicodePlots.extensions]
    FreeTypeExt = ["FileIO", "FreeType"]
    ImageInTerminalExt = "ImageInTerminal"
    IntervalSetsExt = "IntervalSets"
    TermExt = "Term"
    UnitfulExt = "Unitful"

    [deps.UnicodePlots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    FreeType = "b38be410-82b0-50bf-ab77-7b57e271db43"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Term = "22787eb5-b846-44ae-b979-8e399b8463ab"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─0258bd29-ad24-40b2-b0df-7501040fd5e2
# ╠═755b8685-0711-48a2-a3eb-f80af39f10e1
# ╟─83497498-2c14-49f4-bb5a-c252f655e006
# ╟─96b32c06-6136-4d44-be87-f2f67b374bbd
# ╟─3870338a-46d8-43f0-8242-23c358cad6d4
# ╟─f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
# ╟─9a2ca93b-104b-40da-9cfe-3f4d06418759
# ╠═b4394877-36f5-47c7-84a0-ad3b07006a64
# ╟─cf66a361-c4ec-47d0-af0d-8a93b6b039c8
# ╠═8479215a-4d3c-4b9a-8a09-052e06d9f6b6
# ╟─c5d3c475-1ee9-4fcb-9080-d2cdafd02ec6
# ╠═cc4e9b18-96ad-49a4-824a-694de19f96a5
# ╠═9d0cce50-7def-4b86-8be8-577023eb1ebd
# ╠═ce66d5ec-3fbd-4de1-9bb4-589cfd4b4f2f
# ╠═b42f5f36-f9e7-42ee-8eea-1f43f8214680
# ╟─446a5987-671e-4607-8f32-ec237ca339bc
# ╠═9740baf3-281b-4089-a462-04fa260f4d82
# ╠═00f52a86-89f8-413a-b4cb-1ee656c01223
# ╠═b30568f8-45a7-4a7f-a8b8-a4c79b05f832
# ╠═c9226d77-5c68-4790-8f66-5c91289af6f8
# ╟─664db5e5-95a8-4df4-b0bb-45cb2eccb080
# ╠═4aa43df6-0d41-4e88-b4d8-6ea032806690
# ╟─6147e9dd-0b82-404e-a101-b093c09169ec
# ╠═94879b08-2f78-4381-b21d-e9871063c653
# ╟─2a095c63-7f19-4ae8-b5ab-4b55f1526c95
# ╠═de13197d-7859-4bfe-832d-599308b0687e
# ╟─9a6afc4a-6c66-4ed1-9a6b-3c3219af6449
# ╠═a908908d-2975-4c79-b598-e7c3b1463be2
# ╟─878c9121-89d0-42fc-93bd-5effd858a3ff
# ╠═4fe94090-7fd2-412a-84d1-19f7cd2a0f4e
# ╠═d719e5e1-5921-4ea9-b78d-462cb7b3810d
# ╟─bec92f62-4968-4d8f-a65a-656691f27059
# ╠═d52bbae5-eda6-4fc1-bb22-41ef617087c6
# ╠═a7ba5441-8ddb-4ffc-ae99-795dab26f1a8
# ╟─c66a192f-8bd7-462d-a062-cb670b07b723
# ╠═98ad601f-b944-4d79-a3c2-5c94bf17b50a
# ╟─7eac40f2-4179-47d7-83e9-c4a5db964c7d
# ╠═7157d0ad-57a1-4feb-ba78-038ea61f2f1b
# ╠═5e468ba7-8ad2-459f-8650-41492a1b5a63
# ╠═13f51add-f821-414e-9ef1-41f92fb83421
# ╠═d86c915a-be35-4a08-a0a9-c71043ce65cf
# ╠═0a6d5f26-4bcc-4576-a71b-8a1376e2a921
# ╠═12ac4c1b-1117-4f0f-8ebe-10967e34bd8d
# ╟─eb58ff2a-f72c-4f06-948e-0400f79ca2d6
# ╠═73b4a85d-ab44-4445-973e-a309235605af
# ╟─9511b49a-936c-4c43-b03b-eab3cb86ef8a
# ╠═7b9f2e69-1235-4cfd-a97c-444555408241
# ╟─b0f71fe4-ee8e-47a8-a815-f1b082fb8763
# ╠═5c546e19-cc3c-479a-84ca-b0615b0e4d88
# ╠═95e5e4f3-a989-4127-a61e-9fa9d3bea279
# ╟─72485a86-5f90-4b8e-8827-ba3ca4af67c1
# ╠═a7c24649-a826-44fd-bd4d-3bc00bcc2373
# ╟─9ef878c2-c444-49d3-bf6c-4fa7d5d44e5d
# ╠═6079c3b6-ea6f-4128-bd2f-2aa6631dd2d3
# ╟─43c078fb-7964-48e0-92fd-55d306f36b1d
# ╟─b9a0dd69-02e5-4535-99f1-fa11cbe69b15
# ╠═1862d034-ba74-4d58-a566-248e47a6c4d2
# ╠═89892503-524b-43c5-bd35-430be8febacf
# ╟─d4a009e8-9bb3-40bb-a43c-113ea31beec7
# ╠═27d7f892-964d-4871-97df-dda3376b5c42
# ╠═6381fd9c-84cd-41f0-a13f-669a16f270cf
# ╟─8a3ff2f1-0de7-4840-b431-ff44691e1ff3
# ╠═5c7d8961-ebb5-43fc-87e5-5f5bea48074b
# ╠═fcbd3119-1a47-40c8-a7a5-652d9c293824
# ╠═2226efa4-d82b-454a-8dbb-2680847f601e
# ╟─8627b598-00e6-407e-b92e-eec529b4b033
# ╠═193ff069-ff3e-4e6d-a878-9ba3b3718802
# ╠═ca4994de-c22f-44e5-bbdf-7c6099a0229a
# ╟─79c55150-0457-49b7-90a5-2cad980b2cb9
# ╟─30bd74d2-4cae-4f85-88fe-840fbf4af1aa
# ╟─e5e1c14f-fa2a-4618-b55b-cbfc58286184
# ╠═cc059efb-a983-4068-ae64-a11cd6b54a51
# ╠═cafa1dde-44ff-4601-a85c-6e193e9a3904
# ╟─402547f6-fcde-420a-a4ea-10e199f5e2db
# ╠═457f1574-0f12-45a0-8e78-0af8fde8ee5d
# ╟─38b55332-0340-4fba-87f4-f7b7c2f9cbe2
# ╠═14c1da48-e07c-43bd-b8f4-eb393ddbd9b5
# ╟─047b7fb9-9b51-49a7-859d-51c16ac31fff
# ╠═10f75ce8-fe3a-4014-9c67-17c8f8b1bb71
# ╟─423e562d-5563-4d4b-9c2e-6f52d312ded5
# ╟─ecd6d456-e9a0-4218-b90a-a1cd70815dc9
# ╠═8c2e00ba-342b-42ce-8a06-07f8c82c321f
# ╠═f014020d-060b-44cd-8efe-e87483937307
# ╠═f1e58e16-40b5-4926-af00-2dc6c27a3d5a
# ╠═d36517ef-9905-4014-abda-11f6d19dc682
# ╠═784bed8b-d0e1-4deb-af3a-1e8b9a727de4
# ╠═86ae9373-e349-4cef-a88d-1938a2675dfa
# ╠═9242d6ad-d2be-429a-8fb6-009dabddea40
# ╟─2fe2256b-d99d-4f24-bab9-4a891da386b8
# ╠═69f660d8-f45c-45ce-a3df-8c1df3cd2a3b
# ╠═82083ec4-6a42-4665-bce3-d7ebc1fa2df2
# ╟─14445130-1469-4529-8305-02d2f330885a
# ╠═bc93128f-7a09-4843-87c2-1977c55fa13d
# ╠═f3bcaf2b-91b5-49d6-938c-28ad1aee9908
# ╠═b4260f9b-f5ed-45a5-9e77-daddf56710cd
# ╟─6a405fa8-c679-4c8e-acf3-591fed68ec45
# ╠═37c6c024-a242-4aff-8af4-1e71688d6819
# ╠═926c6289-e960-494b-a8e4-774fe1894f20
# ╠═2ff4b81a-f5e7-4148-89df-471650c9a873
# ╠═5b9b145b-aa4d-4a9d-ade7-fbc893c18191
# ╟─1f25d491-1020-4258-b05d-e4110ee248a2
# ╠═8c30062e-0469-4763-b785-9ba18c238aed
# ╟─cde02e4f-ea3e-4353-b687-ce8d24c7c77d
# ╠═a0c66bd2-a8dd-4150-bd9f-3957aa107f47
# ╟─01a81f6f-a138-4fe7-8bd7-fa2a727ae68d
# ╠═34cb8bbb-89dd-4f33-bc1d-9b554ae80819
# ╠═29fa1439-1638-4512-ae70-a08c8702cf76
# ╠═352f0d14-5f22-4148-a116-bd27ba4927fe
# ╟─9ff329af-cde2-44ac-aae0-4b5e7a1b6b46
# ╠═baa1b29a-d7ce-49eb-81dc-c37ef8266df7
# ╟─9a91298d-c31d-48c9-93f4-28ae030b0ee2
# ╟─9a80a295-da3e-459e-9312-2712d14456cb
# ╟─3c07cbb9-2e8c-4971-8866-7ce2384750f2
# ╠═08545994-0432-40fb-968c-2d1fca11baad
# ╟─c87a91ab-094e-4826-b171-1015a918c050
# ╠═25c98cd3-c439-4c3c-88ef-f55fbe597f9c
# ╠═1e517d20-ef94-48e6-95b9-dabaac9e912e
# ╠═de14c13d-2059-4d07-9b76-d4d0285965d2
# ╟─a3af0ab4-330c-46ec-a686-5b2230297086
# ╟─951c7a53-c90c-43b4-8028-a09a37f6a34c
# ╠═7e9db4f6-b7a5-46b8-b386-c75c3aa9fcd6
# ╠═cfa047b9-e15d-403a-a2f0-9dbc0879a382
# ╟─c30ff6f2-b034-4d3a-85db-6a6052bab764
# ╟─22929fda-ddc7-4c1e-bc30-b6f6c30c2e3a
# ╠═5d74be37-f1c2-4a14-afda-2501df203e4f
# ╠═2118b306-0a10-4aa9-9198-52c062f18cd2
# ╠═635185b7-cffc-43ff-8245-b2db15bf7eda
# ╠═75e1b1d6-1258-4294-920d-2937e28942b9
# ╟─a705cf00-e54e-4ce6-ba26-3fede17cfd97
# ╠═d93fba29-1254-44d3-b1f4-1a83b776a9d9
# ╠═a1651444-9c28-4e99-a782-c4d32305d176
# ╟─03c6a14f-e616-4007-9903-c1d53651d854
# ╠═1f0a67e3-cbfc-4ce9-8206-0ab08b8e236b
# ╟─2328e00b-3ff7-4dee-a5a2-67457cc44172
# ╠═36a8f7fa-fd1b-4d3a-bdac-ef24a52902bb
# ╠═cbc8d493-4626-4a07-93d6-06c83921741d
# ╟─8e66d903-df13-4256-ae2d-8b90cea7612a
# ╠═e592bec1-131b-4185-ab55-9dff949ef2da
# ╟─ea91c44f-0ea4-4a1a-a284-9bf1453abd82
# ╠═1acb96c1-c9e8-4b6d-b6a8-51f64d4c9342
# ╠═dfdd7a5c-0381-4e0d-a9dc-b380a3ce05a5
# ╠═6779db72-ef4a-45d7-be24-fefa18075d65
# ╟─4cf438ef-ae36-4513-92f3-e46265d07eea
# ╠═867c276d-4c43-4465-bc9b-621b97c0d2b8
# ╠═83814d80-abf3-4af5-aa6a-d0c7e74c4751
# ╠═c1eace49-8c87-4588-b217-639fff2cd4f0
# ╟─885a9701-aa90-4c16-a982-d975acd03aba
# ╠═da710739-213b-4865-90a0-855895890bbf
# ╠═fee286b7-c274-4561-a4e9-23273b66d550
# ╟─1c820bf5-71ee-4139-b041-8a93a7afd138
# ╠═8717d822-3677-48ed-9f86-8b66dcdb8caa
# ╠═69668aa9-d245-4ed6-8389-d0cc0e802727
# ╠═5cee46db-8312-4b08-a057-093379903881
# ╟─4d822c49-07de-4127-ade7-c339fe10076e
# ╟─b12348a8-53dc-4a4d-8666-3849e94bdece
# ╠═33cfaba3-a1a8-417d-9ab5-3e879ee4f38d
# ╟─e48d1f75-db8e-4b6e-9ad1-7546963fc49b
# ╠═9ed3a23a-5738-4205-91e5-5081fe6be3e1
# ╠═2a65cc87-49c8-401c-b16e-abff7f06b079
# ╠═48417d74-9c91-4d34-bcf9-e074d5b079ba
# ╠═48773893-9a65-47ea-b605-21b553b0cabd
# ╠═dffa4508-98ac-40b2-b65b-87622603366d
# ╠═e942c28f-e557-4c83-af4d-ee344040778d
# ╟─a2ccdd44-f7ab-4e19-847a-149a4e2bb077
# ╠═222f01fa-57be-4b8e-8fcf-1892a0b85f17
# ╠═02664c9d-53c5-46e0-ac6c-127107579ab1
# ╠═3ae5516f-9354-4125-87ea-764d8e124d4b
# ╟─cb8b6d98-d2aa-4ecb-9548-3e6d4ee7fdc9
# ╠═a88db4a6-b60b-4c12-8448-262740fd07a4
# ╠═ef1c6a7f-4b68-46d6-a7d3-3b1aa13e0f6e
# ╟─e6c32403-a422-4cb1-8ea0-cbd80030ea3d
# ╠═b72a9365-ce81-4c9b-938e-50bc2b29feaf
# ╟─038e232d-e50d-4cb6-a40e-5ed40686ff6a
# ╠═23eaeb9b-f8a8-488d-b285-73878b0010b8
# ╟─afb737fc-a1bf-4f31-bf29-6dcee181b984
# ╠═1a0d6200-263b-4861-a588-928301f758d2
# ╠═19b9fb94-3f35-4acb-9a4a-6e73cf4bc727
# ╟─8412c69c-657d-40d0-bae5-d73c7a0a06a5
# ╟─eec78205-4f49-4d72-882f-a0574e953c83
# ╠═d227da3b-2283-4e62-91cd-01014c979a28
# ╠═763a91c4-bfdc-419a-a870-ea47a03864c7
# ╟─6f4e2428-bbe9-43c6-8e24-e7bf4bb1c828
# ╠═6d474dbf-0036-4f68-aaa8-1478b37a5a4b
# ╠═3387ba55-9cea-4cdc-bf62-106b2b432098
# ╟─6ab6588e-2c9d-43c8-aee2-b21ae851f53f
# ╠═4bc40852-4d0d-4d89-aa04-c91b32e2fc04
# ╟─8ef0fc0b-cb56-45f5-ab5f-ddc7fda987e6
# ╠═a299c289-7a51-43ef-94d6-8c8cd42f8439
# ╠═3b855422-9901-41a1-9d1f-10cb24fb23ba
# ╠═bed771b5-67ea-4b20-a51c-5928beadcd9a
# ╟─e52f9416-a362-4c2d-be06-4604a3efbc1c
# ╠═dc851849-e33d-4438-a958-8a100b91f54f
# ╠═16c58360-558e-4879-a36c-66a877519a3e
# ╟─cdc0782e-0973-470e-9873-8ab1b90e3b24
# ╠═cc0696f1-e2dd-4ffe-9be6-b8307e1ad02b
# ╠═f570e5f3-8e09-45e2-8934-f354e813a58e
# ╠═9f795a3a-092b-460a-8a04-d8605cf84384
# ╟─dcf55c61-2578-49a6-8f58-39fb864693e5
# ╠═119ed15e-12ea-49d3-bc97-ddfc1398c4b7
# ╟─d0e3fd22-099b-4cfe-877e-3dc02e9aa55e
# ╠═38295c2d-ba33-450d-aefc-50b376a64c81
# ╟─203ad6b0-b351-45ce-8fcd-37838d6c1c1b
# ╟─f9486534-424a-4913-8396-35e3be4f8d17
# ╠═baede2c8-50ff-4623-8742-e35917619f13
# ╠═44edff64-13d7-4378-8e21-088b4dbe419c
# ╠═bc714282-1c97-448b-b99e-3d496fed3a5a
# ╠═fee81d18-ab33-4928-8c60-68111507bc14
# ╟─8ba035af-aed3-4b6c-a3bb-f73a46415d3b
# ╠═cbfc8bdf-2b6c-4dae-89da-c27342ec6afe
# ╠═5da0c56f-c6f4-4bff-9446-99180624b002
# ╟─b857984b-ec1b-4409-bdf0-438228950f39
# ╠═02e99648-f457-469d-88b0-0cec5cb5826d
# ╠═fc9e4870-9411-4feb-a459-8ce4124187f7
# ╠═c25aec0f-b215-4bda-910d-e29268448623
# ╠═bd968691-948a-4214-b49f-7faf52d407a4
# ╠═4b39a76b-1206-495c-b68d-47efb85acfa5
# ╠═eb9042f0-a46f-4104-88b4-dfc406df9481
# ╟─b2cdd7d0-e009-4fca-a16b-ddd19cabc6a0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
