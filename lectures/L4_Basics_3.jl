### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# ╔═╡ 755b8685-0711-48a2-a3eb-f80af39f10e1
begin
    using PlutoUI
    using PlutoTeachingTools
    using LinearAlgebra
end

# ╔═╡ 83497498-2c14-49f4-bb5a-c252f655e006
ChooseDisplayMode()

# ╔═╡ 96b32c06-6136-4d44-be87-f2f67b374bbd
TableOfContents()

# ╔═╡ 2ad974b1-2bb1-4b67-8aff-a645b98d9bf9
PlutoTeachingTools.default_language[] = PlutoTeachingTools.PTTEnglish.EnglishUS();

# ╔═╡ f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
html"""
	<h1 style="text-align:center">
		Julia programming for ML
	</h1>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Lesson 4: Basics III
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Dicts, Sets and Custom Types
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Adrian Hill
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Summer Semester 2023
		</p>
	</div>
"""

# ╔═╡ adda5451-6669-4ccc-8f17-16ff0f2bccdb
md"# Dictionaries
In Julia, dictionaries are defined using `key => value` pairs:
"

# ╔═╡ 1fb9d847-8edd-447a-a437-77361a2978f4
capitals = Dict(
    "France" => "Paris", "Germany" => "Berlin", "Lebanon" => "Beirut", "Vietnam" => "Hanoi"
)

# ╔═╡ 2ac3cca3-5176-4e52-a999-1d0fe910ab00
md"Dictionaries allow us to look up values using known keys:"

# ╔═╡ 37b0abdf-c7f6-4f52-855b-1ace513b5169
capitals["Germany"]

# ╔═╡ 3d551d34-c1d8-4302-b613-a939b935d4b5
md"This can fail when a key is not part of a dictionary:"

# ╔═╡ 7f488ae7-8575-43ae-b727-785932a7e28e
capitals["USA"] # errors!

# ╔═╡ 8099d57e-7567-4fdb-9b55-b1f3d9785b33
md"This error can be avoid by checking whether a dictionary contains a specific key"

# ╔═╡ b39a123e-9dc7-42ba-9158-aa144c1f37bf
haskey(capitals, "USA")

# ╔═╡ 0e550818-6457-439f-8b63-a492891a981b
md"or by using the `get` function, which allows for a default return value:"

# ╔═╡ 1d9563de-dba2-4d29-b0d1-63a8568b1fce
get(capitals, "USA", "default return value")

# ╔═╡ fa5c1a11-faba-426a-8473-647a4d6cdc1f
md"## Iterating over dictionaries
Dictionaries are automatically destructured into key-value-pairs:
"

# ╔═╡ f86b01e2-730f-4581-8769-45f02b96235f
for (k, v) in capitals
    @info "$v is the capital of $k"
end

# ╔═╡ 205278da-aed8-4d3a-87f0-11e6fa9ac8cb
md"We can also directly access all keys and all values:"

# ╔═╡ cbc9050f-09bd-4005-9f61-48abe24ecfff
keys(capitals)

# ╔═╡ b3fc9128-cecd-48aa-9a40-e5fec2a3bf7d
values(capitals)

# ╔═╡ a9d08d3e-3331-4cb4-9ce3-19da7772f58e
tip(
    md"Dictionaries are mutable and have functions such as `get!`, `pop!`, `merge`, and many more. Take a look at the [Julia documentation on Dictionaries](https://docs.julialang.org/en/v1/base/collections/#Dictionaries).",
)

# ╔═╡ df9f43fa-79dd-4d34-9fa8-3ec62e524395
md"# Sets"

# ╔═╡ f97e1a47-0492-45d2-bf6a-88d3d2b9795b
begin
    # Define a set
    s1 = Set([1, 2, 3, 4])
    @info s1

    # Add a new number to the set
    push!(s1, 6)
    @info s1

    # Remove number from set
    pop!(s1, 2)
    @info s1

    # All elements of a set are unique, we can't add duplicates
    push!(s1, 3)
    @info s1
end

# ╔═╡ 7c93015c-9689-4324-b45f-f80ee6f384f7
md"We can take unions and intersections of sets:"

# ╔═╡ 2c6b9f60-1ac6-48f4-9bcc-094de38ae12e
s2 = Set([0, 1, 2, 3])

# ╔═╡ f045620a-ad4d-4387-bfb7-acd6def46a0d
union(s1, s2)

# ╔═╡ cdc36828-b390-4662-b86a-2562520ea597
intersect(s1, s2)

# ╔═╡ ff75d121-3e12-4b7c-92ee-bd524a17eccf
tip(
    md"Several other operations exist, e.g. `issubset`, `isdisjoint`, `isempty`, `issetequal`. Take a look at the [Julia documentation on Sets](https://docs.julialang.org/en/v1/base/collections/#Set-Like-Collections).",
)

# ╔═╡ 76ea4779-3b90-4120-8abd-e10ca60e0b3b
md"# Custom types
We have already seen type hierarchies in **Lesson 01: Basics I**.

Let's do a short recap and use a trope from object-oriented programming languages to introduce types: **Animals**.
"

# ╔═╡ c96fc26d-9fef-4e23-b8a9-fbee55e2e860
md"## Abstract types
We start by introducing the most simple kind of types, abstract types. These often get named using the prefix `Abstract`.
"

# ╔═╡ 8f9b0887-d70f-48de-a3f4-5c147f00faca
abstract type AbstractAnimal end

# ╔═╡ 86552f92-2246-4316-b3bb-70c29bdc4a03
md"Abstract types can not be instantiated. They are used to describe **sets of subtypes**.
"

# ╔═╡ 7180c799-ff95-494d-8486-6b011c09a723
md"## Subtypes
Subtypes are defined using `<: ParentType`. They can also be abstract types, allowing you to define several layers of type hierarchy:
"

# ╔═╡ 400a5de4-92b2-4f7e-b9f2-135cd925f99f
abstract type AbstractMammal <: AbstractAnimal end

# ╔═╡ 54399253-55f9-446f-9958-bd0a6f71e70d
abstract type AbstractBird <: AbstractAnimal end

# ╔═╡ 37f82d1d-965c-417a-8b04-8946b4a19891
md"Let's now define our first concrete type: cats. Each cat should have a name:
"

# ╔═╡ 0e04ad90-7bc4-4691-a98d-130b57a3e7c3
struct Cat <: AbstractMammal
    name
end

# ╔═╡ 57d6be61-d317-44c5-9648-9f68e3e88800
carlos = Cat("Carlos")

# ╔═╡ 2e0bade7-7046-4c45-956d-df9cec88331e
md"This is somewhat problematic: we can name our cat using integer numbers!"

# ╔═╡ b8c58bae-a699-4d03-8e1a-bc9d97d6c9e5
weird_name_cat = Cat(1.2)

# ╔═╡ f7e354e6-a8fc-4706-b9ab-3e6a8c66eea5
md"Let's do better by using **type annotations** when we define our `Dog` type:"

# ╔═╡ 3e34efc1-8ae8-4383-bd4c-2821f18d0580
struct Dog <: AbstractMammal
    name::String # <- additional type annotation!
end

# ╔═╡ 761f7302-00fd-4b48-95d1-b770f8cbf65c
david = Dog("David")

# ╔═╡ f866d17d-967d-40d8-9006-25a9cbe4729b
Dog(2.7)  # this now errors like we wanted!

# ╔═╡ 5cf374cd-e578-4b44-a6ae-d9935411da5e
md"""## Dispatching on types
Instead of writing "class functions" like in OOP, we define methods for our custom types:
"""

# ╔═╡ 130a843b-027f-45ad-968f-a5df614860d9
make_sound(d::Dog) = "Woof!"

# ╔═╡ 5c26720a-42ec-4014-8bc1-a163b6b3f1bc
md"We can also access the fields of our types:"

# ╔═╡ c57d01b2-ba09-40a7-b602-361a8bb42a22
make_sound(c::Cat) = "Meow! My name is $(c.name)!"

# ╔═╡ 2cf2dcf7-c99a-4486-96c7-760e0c3973ad
md"Let's try it:"

# ╔═╡ 63e6d746-59e3-481f-9696-8507ac01fdb9
make_sound(david)

# ╔═╡ c98fb587-2a05-4c56-9de6-cde540013366
make_sound(carlos)

# ╔═╡ 35a70393-5db0-4d35-8977-122ca8bb67c3
md"""## Custom constructors
So far, we have only used the default constructors that were generated when creating our `Cat` and `Dog` structs.

Let's get more fancy by introducing a `Parrot` type (🦜) and pretending that parrots only like to be given upper-case names.

##### Inner constructors
*Inside* structs, we define can define an *inner* constructor using the function `new`. Inner constructors are used to enforce invariants, e.g. to ensure that arguments are within allowed ranges.

##### Outer constructors
*Outside* structs, we can add arbitrarily many *outer* constructors using multiple dispatch.

Let's use an inner constructor to make sure all names are upper-case. Let's also implement an outer constructor to implement "PATTY" as the default name of all parrots.
"""

# ╔═╡ c46d684e-fcf5-4a6b-a658-378da5816438
begin
    struct Parrot <: AbstractBird
        name::String

        Parrot(name) = new(uppercase(name)) # inner constructor
    end

    Parrot() = Parrot("PATTY") # outer constructor
end

# ╔═╡ 7f61d258-527c-4fff-b9af-0c64d5c92f7f
paula = Parrot("Paula")

# ╔═╡ 076e2ad8-8793-4bbc-b3e9-f5ae55c23c54
patty = Parrot()

# ╔═╡ 53b5f31a-a440-4dcd-8d43-ba90bcbd4e15
tip(
    md"Gathering all constructors in a `begin ... end` block is only required in Pluto notebooks.",
)

# ╔═╡ 0a492572-ecd3-4a0c-a233-10253ef7cfd8
md"## Dispatching on abstract types
We can also dispatch on abstract types.

Instead of having to define `is_mammal` for each concrete animal type (`Cat`, `Dog`, `Parrot`), we simply define a fallback for the most general type `AbstractAnimal` and add a second method for `AbstractMammal`:
"

# ╔═╡ ac297bbf-e656-4d11-9f6c-16311cb864a7
is_mammal(m::AbstractAnimal) = false

# ╔═╡ 386b584f-b2c6-4a5a-91dc-7ee1c121d8ea
is_mammal(m::AbstractMammal) = true

# ╔═╡ 3067620b-f049-4d98-b5f7-8e2b253c73f3
is_mammal.([david, carlos, paula, patty])

# ╔═╡ 6a3ac4fb-ad86-468c-8583-6fe0623b4bfd
md"## Mutable types
Structs can be made mutable. However, these objects will generally be allocated on the heap.
"

# ╔═╡ e2a2bb59-100a-4ed3-a30c-8f5525c73cb4
mutable struct Student
    name::String
    id::Int
end

# ╔═╡ 645175f7-f6a1-48d1-916e-a9cdb1acf99a
begin
    # Add student
    kim = Student("Kim", 456543)
    @info kim.id

    # change student ID number
    kim.id = 456544
    @info kim.id
end

# ╔═╡ 2231d70c-79b1-453a-b24e-7e36d3ee4d1e
md"""## Callable types
Any type can be made "callable" by adding methods to its type. The Julia documentation calls this a [function-like object](https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects) or functor.
"""

# ╔═╡ 41ff1bdc-87ec-4345-8166-934e8081c19e
tip(md"This is similar to `__call__` in Python, with added multiple dispatch.")

# ╔═╡ 94c89fda-0d08-4665-ae8f-9908239d2859
md"# Advanced custom types"

# ╔═╡ a90640e7-dd47-49cf-8d27-32c5b53f8724

md"## Parametric composite types
Let's implement a more advanced and more practical example: our own complex number type.

In *Lesson 01: Basics I* we saw that the `Rational` and `Complex` types were *parametric* composite type. Let's implement our complex numbers the same way:
"

# ╔═╡ 64c54452-1eba-4e36-8afe-8225ce0a0ac1
struct MyComplex{T<:Real} <: Number
    re::T
    im::T
end

# ╔═╡ 83938403-600f-47f2-abb5-ba04aa31dcc2
md"""The big change compared to the previous structs are the curly braces `{T<:Real}` behind `MyComplex`. This can be read as follows:
1. `MyComplex` is a subtype of `Number`, the most general abstract number type.
1. It contains real and imaginary parts `re` and `im`.
1. `re` and `im` both have to be of the same *parametric* type `T`.
1. `T` has to be a subtype of the `Real` numbers.
"""

# ╔═╡ 23560362-0929-4d41-af6e-65aff42fd825
tip(
    md"""Point 4 is optional – we could have simply written
```julia
struct MyComplex{T} <: Number
	re::T
	im::T
end
```

However, by writing `MyComplex{T<:Real}`, we specify that e.g. `MyComplex{String}` is not allowed.""",
)

# ╔═╡ 251be6cc-216f-4dfa-982b-17f4b04df660
md"Let's try it out:"

# ╔═╡ ca66d97e-6e28-4523-b820-8c55b9614e72
ci = MyComplex(1, 3)

# ╔═╡ 3caaa0d0-cbfd-4f39-b6bf-9dd86b40fc0e
cf = MyComplex(1.2, 3.0)

# ╔═╡ 8972793d-3b6d-40b9-8f59-37687e55718f
typeof(ci)

# ╔═╡ dde9a6ae-e888-41be-8baa-c50746aa1672
typeof(cf)

# ╔═╡ 1db85444-9817-442f-b291-96e27e0f1bdc
tip(
    md"It is also possible to define composite types with multiple parameters. For example, we could have defined
```julia
struct MyComplex{T1, T2} <: Number
	re::T1
	im::T2
end
```
You can find out more in the [Julia documentation](https://docs.julialang.org/en/v1/manual/types/#Parametric-Abstract-Types).",
)

# ╔═╡ bca3a7e7-4db3-4135-bf29-263dfece9407
md"## Extending functions on custom types ⁽⁺⁾
Using multiple dispatch, we can extend functions from Julia Base or other packages by adding new methods using our own types.

### Pretty printing
The most common function you will want to extend is `Base.show`. This function defines how custom types are printed in the Julia REPL and notebooks:
"

# ╔═╡ 09a0bacf-d445-4939-a1bc-2e48a6a39415
function Base.show(io::IO, c::MyComplex)
    return println(io, "$(c.re)+$(c.im)im")
end

# ╔═╡ 473b7481-8630-41b0-82a4-fa39bc7a646e
md"### Base operators
Our `MyComplex` data type is useless if we can't compute anything with it, so let's implement addition and multiplication of complex numbers for the purpose of demonstration.

To extend operators from Julia Base, we need to import them explicitly.
We can then use the functional forms `+(a, b)` and `*(a, b)` of addition and multiplication to redefine them for `MySimpleComplex`.

We are simply defining additional methods using multiple dispatch!
"

# ╔═╡ a4d72f28-c11c-4c61-8243-5e5599097f48
begin
    import Base: +, *, zero

    # Addition & multiplication with real numbers
    +(a::MyComplex, b::Real) = MyComplex(a.re + b, a.im)
    *(a::MyComplex, b::Real) = MyComplex(a.re * b, a.im * b)

    # Addition & multiplication are commutative! Let's avoid code duplication
    +(a::Real, b::MyComplex) = b + a # calls previous method
    *(a::Real, b::MyComplex) = b * a # calls previous method

    # Addition of complex numbers
    +(a::MyComplex, b::MyComplex) = MyComplex(a.re + b.re, a.im + b.im)

    # Multiplication of complex numbers
    function *(a::MyComplex, b::MyComplex)
        re = a.re * b.re - a.im * b.im
        im = a.re * b.im + a.im * b.re
        return MyComplex(re, im)
    end

    # Let's also define the additive identity (x + zero(x) = x):
    zero(::MyComplex{T}) where {T} = MyComplex(zero(T), zero(T))
end

# ╔═╡ e7ae71af-5f00-4667-8949-b58a096a8dde
begin
    # Implements ax²+bx+c
    struct QuadraticFunction
        a::Float64
        b::Float64
        c::Float64
    end

    (q::QuadraticFunction)(x) = q.a^2 * x + q.b * x + q.c # add method
    (q::QuadraticFunction)() = q(42) # we can also use multiple dispatch here
end

# ╔═╡ 91e42218-7729-42bc-8f33-087b0d89a1fa
times_two_plus_one = QuadraticFunction(0.0, 2.0, 1.0)

# ╔═╡ 8e562848-f737-4436-b710-e07771a519bb
times_two_plus_one(5.0)

# ╔═╡ 629f1cf4-d69c-4077-ae97-a338bb0241cc
times_two_plus_one()

# ╔═╡ d78fabda-bd83-4367-b2a8-e9edddcb658f
warning_box(
    md"This is **not** a fully featured complex number type, as we would have to redefine most basic operators (`-` ,`/`, ...) and many more functions.
However, this hopefully gives you an idea how Julia implements these things!

Once again, gathering all these methods in a `begin ... end` block is only required inside Pluto notebooks.
",
)

# ╔═╡ fb391b06-9846-4c29-b7ce-0777c039f531
md"With a few lines of code, we can now seamlessly use our complex numbers!"

# ╔═╡ 4027636b-5d24-41dd-9aef-f2564f41333d
a, b = MyComplex(1, 2), MyComplex(3, 4)

# ╔═╡ 9f0a788b-c6ee-404c-bca9-f3fa7d1f0866
2 * a

# ╔═╡ 311907fe-98e6-4095-84a0-feecec37b40d
b + 5

# ╔═╡ 2df350b0-d0fa-45c6-a9f7-b256ccf5e7d9
a + b + 2

# ╔═╡ 6807ff68-10fc-4275-95e2-37883be8b343
a * b

# ╔═╡ 07147cea-d94b-4a14-bd2b-fbc5a1c50fdb
md"And due to the fact that our methods will also dispatch inside the Julia source code, our complex numbers also work in matrices!"

# ╔═╡ 016dc000-ddd3-4ce3-aea0-f44444088941
begin
    # Let's define two complex matrices A ∈ ℝ¹ˣ³, B ∈ ℝ³ˣ⁴
    A_re = rand(-9:9, 1, 3)
    A_im = rand(-9:9, 1, 3)
    B_re = rand(-9:9, 3, 4)
    B_im = rand(-9:9, 3, 4)

    # Our complex numbers
    A1 = MyComplex.(A_re, A_im)
    B1 = MyComplex.(B_re, B_im)

    # Julia's complex numbers
    A2 = Complex.(A_re, A_im)
    B2 = Complex.(B_re, B_im)
end;

# ╔═╡ a28d0171-aa9f-40d4-972d-88fcb1f65d3c
A1 * B1

# ╔═╡ e752a539-acda-4917-8e88-0dcf4c24c8dd
A2 * B2

# ╔═╡ aebcd587-80e1-463d-95ab-6fbae629531e
tip(
    md"If this awakened your curiosity, take a look at the actual [Julia source code](https://github.com/JuliaLang/julia/blob/3b2e0d8fbc10128c0f6f88823ccf6c33d5735abc/base/complex.jl) of the `Complex` type. Here is a curated selection:
1. [Type definition](https://github.com/JuliaLang/julia/blob/3b2e0d8fbc10128c0f6f88823ccf6c33d5735abc/base/complex.jl#L3-L16)
2. [Addition, multiplication and subtraction](https://github.com/JuliaLang/julia/blob/3b2e0d8fbc10128c0f6f88823ccf6c33d5735abc/base/complex.jl#L289-L346)
3. [Definition of the imaginary unit](https://github.com/JuliaLang/julia/blob/3b2e0d8fbc10128c0f6f88823ccf6c33d5735abc/base/complex.jl#L20-L36)
",
)

# ╔═╡ ff3740f7-59af-410f-9232-935c2c053260
md"""## Comparing OOP & Multiple dispatch ⁽⁺⁾
**Note:** This is my personal opinion.

In this lecture, we used tropes from object-oriented programming (OOP) to introduce Julia programming concepts. Let's take a look at a object-oriented Python implementation of our code:

```python
class Dog(Mammal):
	def __init__(self, name):
		self.name = name

	def make_sound(self):
		return "Woof!"
```
"""

# ╔═╡ c5cb6d12-30d3-40df-94fd-7ed900a00c94
md"""Python's `make_sound(self)` can be seen as an instance of *single dispatch* on the object's class.
For single-input functions like `make_sound` and functions with strict type restrictions, single dispatch is a well suited pattern.

##### Drawbacks of OOP
However, things already get more complicated when thinking about functions with two different input types, e.g. a function `interact(animal1, animal2)`:
* It often becomes unclear which class should implement which method (especially when the function is commutative).
* Inside the chosen class, we need to write separate if-else-statements for all possible types of the second argument.
* Things don't get easier with more than two arguments!

##### Drawbacks of Multiple dispatch
Julia's implementation of multiple dispatch also has its caveats:
* With no classes to "encapsulate" methods with, Julia programmers must take good care to keep their code organized. Methods like `make_sound` should either be grouped with other `make_sound` methods or with the primary type they dispatch on.
* Interfaces and traits that should be implemented are often left implicit. For example, we would have to dig into the [Julia documentation](https://docs.julialang.org/en/v1/manual/interfaces/) to find out which functions our `MyComplex` data type is expected to implement to be a fully fledged `Number` type.

While both philosophies have similarities, they require very different design approaches. Even though it is easy to extend functionality from Julia Base and other packages, it isn't always clear how well these extensions compose. Several Julia packages implementing interfaces exist, however the issue is most commonly mitigated by extensive package testing, which we will learn about in *Lesson 8: Workflows*.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.8"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "19e00ceabd198c1e3f8db0a525d8ac1d6bc69d32"

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
git-tree-sha1 = "d57c99cc7e637165c81b30eb268eabe156a45c49"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.2.2"

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
git-tree-sha1 = "d9ae7a9081d9b1a3b2a5c1d3dac5e2fdaafbd538"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.22"

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
git-tree-sha1 = "b970826468465da71f839cdacc403e99842c18ea"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.8"

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
git-tree-sha1 = "90cb983381a9dc7d3dff5fb2d1ee52cd59877412"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.1"

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
# ╠═755b8685-0711-48a2-a3eb-f80af39f10e1
# ╟─83497498-2c14-49f4-bb5a-c252f655e006
# ╟─96b32c06-6136-4d44-be87-f2f67b374bbd
# ╟─2ad974b1-2bb1-4b67-8aff-a645b98d9bf9
# ╟─f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
# ╟─adda5451-6669-4ccc-8f17-16ff0f2bccdb
# ╠═1fb9d847-8edd-447a-a437-77361a2978f4
# ╟─2ac3cca3-5176-4e52-a999-1d0fe910ab00
# ╠═37b0abdf-c7f6-4f52-855b-1ace513b5169
# ╟─3d551d34-c1d8-4302-b613-a939b935d4b5
# ╠═7f488ae7-8575-43ae-b727-785932a7e28e
# ╟─8099d57e-7567-4fdb-9b55-b1f3d9785b33
# ╠═b39a123e-9dc7-42ba-9158-aa144c1f37bf
# ╟─0e550818-6457-439f-8b63-a492891a981b
# ╠═1d9563de-dba2-4d29-b0d1-63a8568b1fce
# ╟─fa5c1a11-faba-426a-8473-647a4d6cdc1f
# ╠═f86b01e2-730f-4581-8769-45f02b96235f
# ╟─205278da-aed8-4d3a-87f0-11e6fa9ac8cb
# ╠═cbc9050f-09bd-4005-9f61-48abe24ecfff
# ╠═b3fc9128-cecd-48aa-9a40-e5fec2a3bf7d
# ╟─a9d08d3e-3331-4cb4-9ce3-19da7772f58e
# ╠═df9f43fa-79dd-4d34-9fa8-3ec62e524395
# ╠═f97e1a47-0492-45d2-bf6a-88d3d2b9795b
# ╟─7c93015c-9689-4324-b45f-f80ee6f384f7
# ╠═2c6b9f60-1ac6-48f4-9bcc-094de38ae12e
# ╠═f045620a-ad4d-4387-bfb7-acd6def46a0d
# ╠═cdc36828-b390-4662-b86a-2562520ea597
# ╟─ff75d121-3e12-4b7c-92ee-bd524a17eccf
# ╟─76ea4779-3b90-4120-8abd-e10ca60e0b3b
# ╟─c96fc26d-9fef-4e23-b8a9-fbee55e2e860
# ╠═8f9b0887-d70f-48de-a3f4-5c147f00faca
# ╟─86552f92-2246-4316-b3bb-70c29bdc4a03
# ╟─7180c799-ff95-494d-8486-6b011c09a723
# ╠═400a5de4-92b2-4f7e-b9f2-135cd925f99f
# ╠═54399253-55f9-446f-9958-bd0a6f71e70d
# ╟─37f82d1d-965c-417a-8b04-8946b4a19891
# ╠═0e04ad90-7bc4-4691-a98d-130b57a3e7c3
# ╠═57d6be61-d317-44c5-9648-9f68e3e88800
# ╟─2e0bade7-7046-4c45-956d-df9cec88331e
# ╠═b8c58bae-a699-4d03-8e1a-bc9d97d6c9e5
# ╟─f7e354e6-a8fc-4706-b9ab-3e6a8c66eea5
# ╠═3e34efc1-8ae8-4383-bd4c-2821f18d0580
# ╠═761f7302-00fd-4b48-95d1-b770f8cbf65c
# ╠═f866d17d-967d-40d8-9006-25a9cbe4729b
# ╟─5cf374cd-e578-4b44-a6ae-d9935411da5e
# ╠═130a843b-027f-45ad-968f-a5df614860d9
# ╟─5c26720a-42ec-4014-8bc1-a163b6b3f1bc
# ╠═c57d01b2-ba09-40a7-b602-361a8bb42a22
# ╟─2cf2dcf7-c99a-4486-96c7-760e0c3973ad
# ╠═63e6d746-59e3-481f-9696-8507ac01fdb9
# ╠═c98fb587-2a05-4c56-9de6-cde540013366
# ╟─35a70393-5db0-4d35-8977-122ca8bb67c3
# ╠═c46d684e-fcf5-4a6b-a658-378da5816438
# ╠═7f61d258-527c-4fff-b9af-0c64d5c92f7f
# ╠═076e2ad8-8793-4bbc-b3e9-f5ae55c23c54
# ╟─53b5f31a-a440-4dcd-8d43-ba90bcbd4e15
# ╟─0a492572-ecd3-4a0c-a233-10253ef7cfd8
# ╠═ac297bbf-e656-4d11-9f6c-16311cb864a7
# ╠═386b584f-b2c6-4a5a-91dc-7ee1c121d8ea
# ╠═3067620b-f049-4d98-b5f7-8e2b253c73f3
# ╟─6a3ac4fb-ad86-468c-8583-6fe0623b4bfd
# ╠═e2a2bb59-100a-4ed3-a30c-8f5525c73cb4
# ╠═645175f7-f6a1-48d1-916e-a9cdb1acf99a
# ╟─2231d70c-79b1-453a-b24e-7e36d3ee4d1e
# ╠═e7ae71af-5f00-4667-8949-b58a096a8dde
# ╠═91e42218-7729-42bc-8f33-087b0d89a1fa
# ╠═8e562848-f737-4436-b710-e07771a519bb
# ╠═629f1cf4-d69c-4077-ae97-a338bb0241cc
# ╟─41ff1bdc-87ec-4345-8166-934e8081c19e
# ╟─94c89fda-0d08-4665-ae8f-9908239d2859
# ╟─a90640e7-dd47-49cf-8d27-32c5b53f8724
# ╠═64c54452-1eba-4e36-8afe-8225ce0a0ac1
# ╟─83938403-600f-47f2-abb5-ba04aa31dcc2
# ╟─23560362-0929-4d41-af6e-65aff42fd825
# ╟─251be6cc-216f-4dfa-982b-17f4b04df660
# ╠═ca66d97e-6e28-4523-b820-8c55b9614e72
# ╠═3caaa0d0-cbfd-4f39-b6bf-9dd86b40fc0e
# ╠═8972793d-3b6d-40b9-8f59-37687e55718f
# ╠═dde9a6ae-e888-41be-8baa-c50746aa1672
# ╟─1db85444-9817-442f-b291-96e27e0f1bdc
# ╟─bca3a7e7-4db3-4135-bf29-263dfece9407
# ╠═09a0bacf-d445-4939-a1bc-2e48a6a39415
# ╟─473b7481-8630-41b0-82a4-fa39bc7a646e
# ╠═a4d72f28-c11c-4c61-8243-5e5599097f48
# ╟─d78fabda-bd83-4367-b2a8-e9edddcb658f
# ╟─fb391b06-9846-4c29-b7ce-0777c039f531
# ╠═4027636b-5d24-41dd-9aef-f2564f41333d
# ╠═9f0a788b-c6ee-404c-bca9-f3fa7d1f0866
# ╠═311907fe-98e6-4095-84a0-feecec37b40d
# ╠═2df350b0-d0fa-45c6-a9f7-b256ccf5e7d9
# ╠═6807ff68-10fc-4275-95e2-37883be8b343
# ╟─07147cea-d94b-4a14-bd2b-fbc5a1c50fdb
# ╠═016dc000-ddd3-4ce3-aea0-f44444088941
# ╠═a28d0171-aa9f-40d4-972d-88fcb1f65d3c
# ╠═e752a539-acda-4917-8e88-0dcf4c24c8dd
# ╟─aebcd587-80e1-463d-95ab-6fbae629531e
# ╟─ff3740f7-59af-410f-9232-935c2c053260
# ╟─c5cb6d12-30d3-40df-94fd-7ed900a00c94
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
