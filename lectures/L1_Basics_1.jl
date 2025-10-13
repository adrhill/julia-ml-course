### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 1fcbc08a-a0b7-11ed-0477-13c86a949723
begin
    using PlutoUI
    using PlutoTeachingTools
end

# ╔═╡ ff822cbc-7d8b-4b75-a2eb-891d9ee2ff70
begin
    using AbstractTrees
    AbstractTrees.children(T::Type) = subtypes(T)
    print_type_tree(T) = print_tree(T)
end

# ╔═╡ f28ab96e-ff8a-46b4-b3db-b8ad5975352e
html"""<style>.dont-panic{ display: none }</style>"""

# ╔═╡ c5e6183d-8fc9-47f4-aff4-6a0fa75b3e4b
ChooseDisplayMode()

# ╔═╡ 98428309-2e55-4c8b-8c3a-3e98e677a1b2
PlutoTeachingTools.default_language[] = PlutoTeachingTools.PTTEnglish.EnglishUS();

# ╔═╡ c854cbe0-5e36-4569-9e1f-d17b2c3540d5
TableOfContents()

# ╔═╡ 04376141-9c94-4197-804a-932c35a53777
html"""
	<h1 style="text-align:center">
		Julia for Machine Learning
	</h1>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Lesson 1: Introduction to Julia
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Types, Control-Flow, Functions & Multiple Dispatch
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Adrian Hill
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Winter Semester 25/26
		</p>
	</div>
"""

# ╔═╡ 6352d357-885e-463f-94e9-ae6fc4f79593
md"""# Introduction to Julia
## Hello world
Let's print *"Hello world"* on our screen:
"""

# ╔═╡ b42d464b-800a-43c1-bb55-447f3c49c3c7
print("Hello world")

# ╔═╡ 054e2dd9-ccfa-41d7-8cbf-33b1645fd946
md"""Since we are working inside of a Pluto notebook, Pluto detected us printing to the terminal stream (`stdout`).

By default, Pluto will display the return value of each cell above the respective cell. We therefore don't need to manually print return values:
"""

# ╔═╡ 4a8c7c6b-a7d7-44be-b767-ca5e2a31d30f
"Hello world"  # outputs are displayed by default

# ╔═╡ 836e1bd2-83a1-4466-9c28-ef33b0180101
"Hello world"; # add a semicolon to hide them

# ╔═╡ 02dd64df-148d-4964-97f8-49b9c83880da
md"""## Variables
Variables bind values to a name
"""

# ╔═╡ 5e68f32e-5568-4a5f-9b9b-7a211df15968
my_var = 3

# ╔═╡ b0502992-7e67-44f5-98d5-2d78ac6fe5b6
another_var = 2 * my_var

# ╔═╡ 7437fcfc-fb33-4855-bacd-a34160af6b24
md"We can also use Unicode characters in our variable names:"

# ╔═╡ 13a11350-9140-410a-8559-22f8fb6b843e
α = 1.0 # typed as: \alpha<TAB>

# ╔═╡ e4773a83-d22e-4312-a05d-93d8a8552c35
안녕하세요 = "Hello"

# ╔═╡ 983319a6-d28c-4767-89d3-8c161825e8b4
🥧 = pi # typed as: \:pie:<TAB>

# ╔═╡ 32354273-fa48-49ac-9a3a-12ad459495d5
tip(
    md"""Since most Unicode symbols are named after their LaTeX counterparts, websites like [Detexify](http://detexify.kirelabs.org/classify.html) can be useful when you are trying to type a symbol for the first time.""",
)

# ╔═╡ 3df66af5-97cb-4251-8c65-a218f39fca25
warning_box(
    md"""With great power comes great responsibility: try to avoid Unicode variables in function names and keyword arguments that other people will have to interact with.

    Unicode variables are most useful when used internally in a context where mathematical conventions exist.
    For example, the internals of your code could assign the covariance matrix of some data to the variable `Σ` and the mean to `μ`.
    """,
)

# ╔═╡ aeb1472b-3c6f-4697-bcff-324ac0f9339f
md""" # Basic operators
## Arithmetic operators
| Expression | Name           | Description                             |
|:---------- |:-------------- |:----------------------------------------|
| `+x`       | unary plus     | the identity operation                  |
| `-x`       | unary minus    | maps values to their additive inverses  |
| `x + y`    | binary plus    | performs addition                       |
| `x - y`    | binary minus   | performs subtraction                    |
| `x * y`    | times          | performs multiplication                 |
| `x / y`    | divide         | performs division                       |
| `x ÷ y`    | integer divide | x / y, truncated to an integer          |
| `x \ y`    | inverse divide | equivalent to `y / x`                   |
| `x ^ y`    | power          | raises `x` to the `y`th power           |
| `x % y`    | remainder      | equivalent to `rem(x,y)`                |

Let's demo some of these:
"""

# ╔═╡ d9f68f07-9838-4598-bd70-a6aed8abf48c
1 + 2 * 3

# ╔═╡ f8d1ea84-3b4e-42a3-9c26-46beab337206
md"#### Powers and roots"

# ╔═╡ f9fe25cf-16d3-42bc-9102-d4e330af2d0c
5^2

# ╔═╡ e9fd1f66-3c48-4d2b-a3b0-4f3b990087ff
sqrt(2) == 2^0.5

# ╔═╡ e2bef8fb-6758-4528-bd24-f57c34b3e964
md"#### Floor division"

# ╔═╡ 4ef04a45-9596-487c-83c7-6f35f6ffbf4c
div(10, 3)

# ╔═╡ f112529a-9b05-4428-b5fe-fad6fad7afa0
md"This is equivalent to `÷`, which you can type as `\div<TAB>`:"

# ╔═╡ 36c9b759-8244-48e9-95f3-626538626f9d
10 ÷ 3

# ╔═╡ c026d456-8178-446d-948c-8bbbf2faee19
md"#### Remainder"

# ╔═╡ 71bcc34c-23d7-4a27-86cc-759010c5c611
5 % 3

# ╔═╡ bded41c2-763d-4140-85d4-7ef8390d4c23
md"this is equivalent to"

# ╔═╡ c5bf7c2e-1453-47a8-822c-b100add67763
rem(5, 3)

# ╔═╡ f8c9b6ec-534c-4fcf-93b8-6db9b23ed883
md"For negative numbers, remember that remainder $\neq$ modulo:"

# ╔═╡ d0769dac-14c7-4cf7-92bf-145a5cf975f1
rem(-5, 3)

# ╔═╡ 3714ec58-382f-44d4-a542-447492f52f7b
mod(-5, 3)

# ╔═╡ 3655a334-2f88-4089-a099-06bd8d4de51f
md"""## Numeric comparisons
| Operator  | Name                     |
|:--------- |:------------------------ |
| `==`      | equality                 |
| `!=`, `≠` | inequality               |
| `<`       | less than                |
| `<=`, `≤` | less than or equal to    |
| `>`       | greater than             |
| `>=`, `≥` | greater than or equal to |

Let's try out a simple example:
"""

# ╔═╡ b132137d-c60a-4b7e-ad65-00996d7732ce
4 <= 2

# ╔═╡ 23ab05c1-e50c-4a78-af18-923f5a6fc83d
md"""Another useful tool is the `isapprox` function, which can be used in infix-notation `≈` (`\approx<TAB>`).
"""

# ╔═╡ a9fd1637-3569-4a72-9baf-041b5e472139
1 ≈ 1.00000001

# ╔═╡ 8fd7eeac-656d-4e46-b389-9b215bac5f22
isapprox(1, 1.00000001)

# ╔═╡ 247071c7-36f1-4693-bcf1-a2b3057e719b
md"""## Boolean operators
| Expression | Name                 |
|:---------- |:---------------------|
| `!x`       | negation             |
| `x && y`   | short-circuiting and |
| `x \|\| y` | short-circuiting or  |
"""

# ╔═╡ 16b68419-c91c-406e-a50c-7aed4839324d
tip(md"Play around by changing variables in this notebook. Which outcome do you expect?")

# ╔═╡ 597bfad2-5c79-47a4-b42f-18ab869f0e30
md"Let's see these in action, starting with negation:"

# ╔═╡ 42e09352-09d0-490d-8115-3a417a509a20
!false

# ╔═╡ 77b1970a-604e-406a-ac89-fd5cdc028b3b
md"""There are two short-circuiting Boolean operators:
"""

# ╔═╡ 717c9384-dde9-4f4d-ad7a-344444ec09b2
true && false  # short-circuiting and

# ╔═╡ abd59d28-4a1e-4444-a7fa-292fdc24f91b
true || false  # short-circuiting or

# ╔═╡ be04937c-bdc3-4844-a595-fd7611337395
md"These are called short-circuiting because they only evaluate their right-hand side if necessary:"

# ╔═╡ 1f7c2b9f-67e9-4518-ae2a-d2c7dd23c788
3 < 2 && error("This error will never be thrown because 3 < 2 is already false")

# ╔═╡ df4edb12-f733-47b3-8a5a-4a33e8c0c7b8
2 > 1 || print("This will never be printed because 2 > 1 is already true")

# ╔═╡ 83af70d7-84e3-48c6-a1d3-b75ede505939
tip(md"These can also be used to write short if-statements!")

# ╔═╡ 4072af54-cb68-43a6-aea1-918c8e3434b9
md"""## Bitwise operators ⁽⁺⁾
These rarely get used in Machine Learning, so I will just summarize them for completeness:

| Expression | Name                                                                     |
|:---------- |:------------------------------------------------------------------------ |
| `~x`       | bitwise not                                                              |
| `x & y`    | bitwise and                                                              |
| `x \| y`   | bitwise or                                                               |
| `x ⊻ y`    | bitwise xor (exclusive or)                                               |
| `x ⊼ y`    | bitwise nand (not and)                                                   |
| `x ⊽ y`    | bitwise nor (not or)                                                     |
| `x >>> y`  | [logical shift](https://en.wikipedia.org/wiki/Logical_shift) right       |
| `x >> y`   | [arithmetic shift](https://en.wikipedia.org/wiki/Arithmetic_shift) right |
| `x << y`   | logical/arithmetic shift left                                            |

Examples can be found in the [Julia documentation](https://docs.julialang.org/en/v1/manual/mathematical-operations/#Bitwise-Operators).

"""

# ╔═╡ 0487d1ce-c6e8-40cb-b96c-94681f28c8d8
md"""## Updating operators
Most of the operators we have covered also have updating versions:
```
+=  -=  *=  /=  \=  ÷=  %=  ^=
```
"""

# ╔═╡ fbc531cb-d98a-45f5-8993-3f702a13090b
md"Due to Pluto's reactivity, we have to demonstrate these inside a `begin ... end` block:"

# ╔═╡ 30282852-5756-42f8-a64a-b0e3ae2726eb
begin
    x = 2
    x += 3  # 2 + 3 = 5
    x ^= 2  # 5 ^ 2 = 25
end

# ╔═╡ 348cf13f-74c3-4937-a3dc-9190b96aa72d
md"""These also exist for bitwise operations:
```
&=  |=  ⊻=  >>>=  >>=  <<=
```
"""

# ╔═╡ dd88e8aa-a06a-4d00-8d7f-76ebb43a3947
md"""# Type system
## Types
All variables in Julia have a type. The type of a value or variable can be printed using `typeof`:
"""

# ╔═╡ 9b61b024-42d6-4617-9f8e-9e81d24e5283
typeof("Hello World")

# ╔═╡ 8ac5222c-2e6c-4b64-a133-54ffb484e003
typeof('c')

# ╔═╡ d3bf40a2-7507-4de0-84d2-d7a628b444f0
md"There are multiple types for numbers:"

# ╔═╡ 008d2d39-5f5c-409a-96b8-3ad0d512599c
typeof(1)   # Default Int type is Int64

# ╔═╡ 0e9c89cc-461e-40bf-b8cb-f15f9e0f7e4f
typeof(1.0) # Default Float type is Float64

# ╔═╡ a6214274-3fb6-4f14-ace0-257f1078a742
md"To obtain a number of a specific type, we can use the type's constructor:"

# ╔═╡ 7039ea01-28e4-40c9-9fdd-2be14ffe2345
typeof(Float32(1.0))

# ╔═╡ f7d7321c-eca8-4fcb-8d7e-a44fd34725f5
md"We can also use scientific notation to define `Float64` and `Float32` numbers:"

# ╔═╡ eb36af06-2684-4b21-b8d9-48ebf07cc9d3
typeof(1.0e-2)

# ╔═╡ e7fc26ef-fb85-438f-9703-c33dfd05d2de
typeof(1.0f-2)

# ╔═╡ b4168f31-4f53-4e06-a1c8-61db7b90d2dd
md"## Other common numerical types"

# ╔═╡ bb044ef2-0d77-4748-82af-d7103cca3157
md"""### Irrational numbers
"""

# ╔═╡ 16dec848-9518-4afe-8f6b-f831179a7a3e
π # \pi<TAB>

# ╔═╡ 13426af6-42b7-4265-b0e8-60144363395e
ℯ # \euler<TAB>

# ╔═╡ 450b01ee-2d5f-4463-a9de-559ee66576ef
typeof(π)

# ╔═╡ b41bee43-f510-483f-9a12-d9d577367272
md"### Rational numbers
For integers $p$ and $q$,
rational numbers $\frac{p}{q}$ can be expressed as fractions using the syntax `p//q`.
"

# ╔═╡ 271cf99f-92ea-4e8c-ba0d-c4d848c5bb31
r = 1//3 # one third

# ╔═╡ fa9944fe-60c2-463e-af0c-cd836eade2f0
typeof(r)

# ╔═╡ 9358e01f-71b4-4ee1-96ca-2f754f011c71
md"This avoids rounding errors due to the finite precision of floating-point numbers and floating-point arithmetic:
"

# ╔═╡ 6e16fd91-bd6b-43c2-9f07-e54cfe1ad503
1 / 10 + 2 / 10 # error due to floating-point arithmetic

# ╔═╡ f02acec5-adf4-4b3c-9d68-18032d5b7017
1//10 + 2//10 # no error!

# ╔═╡ be8ed1b2-f2f7-4b38-b47c-c2d78730af23
md"We also introduce rounding errors
when casting rational numbers to floating point numbers:"

# ╔═╡ 83130d05-383a-4461-be95-3b8f296a8238
Float32(r)

# ╔═╡ 033e9b34-7c10-4bbb-9004-36f6c4ee4052
md"""### Complex numbers"""

# ╔═╡ 269667c2-7f00-4369-8eb8-85e493e059ef
c = 1.2 + 3.4im

# ╔═╡ 7893d98f-dacf-42bd-a587-f38b1cf2373f
typeof(c)

# ╔═╡ 640f0f22-7021-461c-8e04-d5f0661aa72f
md"## Parametric composite types"

# ╔═╡ bbda2d1d-f40e-4cfb-a8dc-a9561ff87213
question_box(md"""We just saw the `Rational{Int64}` and `Complex{Float64}` types.
What do these curly braces mean?
""")

# ╔═╡ e0ab8571-1cc8-40e4-aaf0-68500895fa42
md"""Some types hold values of other types.
Depending on the programming language they are found in, these types are called *structs*, *data classes* or *composite types*.

Julia allows for generic implementations of these composite types.
These so-called *parametric composite types* are indicated by *type parameters* `{T}` in curly braces:

- `Rational{Int64}` is a rational number represented by a `Int64` nominator and denominator. We could also have defined a rational number with any other `Integer` type.
- `Complex{Float64}` is a complex number represented by `Float64` real and imaginary parts. We could also have defined a complex number with any other `Real` type.
"""

# ╔═╡ 016ffd81-f142-42c4-93c0-e1ae71a4bfce
md"""Some types have multiple type parameters. The `Tuple` type *(round brackets)* is one example of this:"""

# ╔═╡ a9d7b66e-89a2-427b-b0ac-8311a9f60d38
my_tuple = (1, 2.0, "Foo")

# ╔═╡ 4200ad17-c27f-476e-a5c4-95f17233cc30
typeof(my_tuple)

# ╔═╡ b19f7ea2-db9d-4f3a-b9d6-6a6fd7ff5304
tip(md"We will learn how to define our own types in lecture 4!")

# ╔═╡ 06e254b9-c460-46b1-94b5-f9a8d8079c83
md""" ## Type hierarchy
Julia's types are part of a type hierarchy:
* the parent type can be shown using `supertype`
* subtypes can be shown using `subtypes`
"""

# ╔═╡ 1e3f2868-5746-43db-a5cb-c628ea24ccd8
supertype(Float64)

# ╔═╡ 0a163913-b59f-4bab-a1c5-244b32ac66ad
subtypes(AbstractFloat)

# ╔═╡ 89bc13bc-d747-4f42-b62b-c229c79002d1
md"""I have prepared a function `print_type_tree` in this notebook that will show type hierarchies:"""

# ╔═╡ fa0a7a24-8ac3-46da-91f7-7a285959997f
print_type_tree(Number)

# ╔═╡ bdf9a3ed-6017-4ac0-a7eb-95a4e96636a6
tip(
    md"""In Julia, only leaf nodes of the type hierarchy can be instantiated. All other types are "abstract types", usually indicated by the prefix `Abstract`.
""",
)

# ╔═╡ ea2353c2-a2c9-4d87-a316-ab952bc0b3ee
md"## Vectors
In Julia, vectors are defined by comma-separated values inside square brackets:
"

# ╔═╡ eede6d0a-36d3-4802-941c-a0ca5051335e
v1 = [1, 2, 3, 4, 5]

# ╔═╡ 6efde913-04d7-4f49-8d52-4c369506a6cb
v2 = ["Adrian", "Klaus-Robert"]

# ╔═╡ ae5ac145-ce40-4bfa-9e6d-69a253c27931
md"Vectors are also parametric types:"

# ╔═╡ 3496a358-8fdd-4fbb-8125-6c35c06012af
typeof(v1)

# ╔═╡ 91ac1cca-edbd-4534-9e97-261dfa334cb1
typeof(v2)

# ╔═╡ feadce71-ec02-4e70-a552-8f3f3245a750
tip(md"Vectors and arrays are going to be covered in more detail in lecture 2.")

# ╔═╡ bc8f2317-3cb9-4a8c-85a9-16d2607d47f7
md"""## Ranges
Using the syntax `start:stop`, we can define ranges:
"""

# ╔═╡ 49ccb9ae-59f5-46ef-a227-24b9c275fdd9
my_range = 1:1000

# ╔═╡ de326b18-197b-4ca7-af28-138ad2a5967a
typeof(my_range)

# ╔═╡ 47ad8eeb-7ac2-48b2-baf0-10619b291824
md"""### Collect
Ranges are "lazy" in the sense that they only contain the information needed to construct a sequence, but not the full data.

Using `collect`, the full sequence is written into a vector:
"""

# ╔═╡ ed5a17d0-74a5-493d-8205-e5555958a0f3
collect(my_range)

# ╔═╡ 0fa8b370-cf2a-47b8-ac3b-479e1221202b
md"We can inspect the difference in memory using `sizeof`:"

# ╔═╡ 2c82b252-dd51-44f2-a20c-a0ffb65ee210
sizeof(my_range) # 2 Int64s (start and stop) => 128 bit => 16 bytes

# ╔═╡ 5a5b2ebd-1da6-42ca-90d6-e63645ded46b
sizeof(collect(my_range)) # 1000 Int64s => 64000 bit => 8000 bytes

# ╔═╡ 9a12c858-74df-41b7-9ca6-6fdd47b430fb
md"""### Custom step size
We can also construct ranges with custom step sizes using the syntax `start:step:stop` where `step` is the step size between subsequent numbers.
"""

# ╔═╡ c52cd9c7-aa09-4881-b7a3-ee94c9124790
collect(1:2:10) # range from 1 to 10 with a step size of 2

# ╔═╡ 64f1fb95-4267-45da-a8cf-7707bc18ac96
md"Ranges also support negative step sizes:"

# ╔═╡ 34c689ca-eba3-46e7-a246-cd58d5f03cdc
collect(2:-0.2:1)

# ╔═╡ e73639d0-5dd2-42f6-abc2-6b67a9489fd5
md"""If even more control is desired, the `range` function can be used.
This function supports any three arguments out ouf `start`, `stop`, `step` and `length`:"""

# ╔═╡ 57e3ddbf-e2ba-4407-90ba-5cbee3ceb605
collect(range(1, 2; length=10))

# ╔═╡ dca1cc1f-4c30-468c-822b-f0ac2ed2a6fd
md"""# Control flow
## Conditional evaluation
Basic if-else statements match those in other languages:
"""

# ╔═╡ f5329516-df0f-44cc-b6bb-9a652742ce9c
a = 1 # Play with the values of a & b!

# ╔═╡ 52c35f28-1bac-4f68-a437-d9a175ba5e10
b = 1

# ╔═╡ 6eb7ffa2-0d10-4036-a5d9-5fdd2af3bf0d
if a < b
    "a is less than b"
elseif a > b
    "a is greater than b"
else
    "a is equal to b"
end

# ╔═╡ bc521f35-f827-459a-adaf-881d7c37ecfd
md"""As we have previously introduced, short-circuit evaluations using `&&` and `||` can be used as an alternative to short `if`-statements:"""

# ╔═╡ 97548f86-66af-4ec3-89f0-431e06cdcad4
a > b && "a is greater than b"

# ╔═╡ d7d66a70-21bd-4ac5-acc8-fb971bfd5b60
md"""The ternary operator `?:` is also related to `if-else` statements

It takes the form `condition ? return_if_true : return_if_false`, for example:"""

# ╔═╡ 8f9c8a0d-a656-41b5-b9c7-c147a5eed86b
a >= b ? "a is greater or equal b" : "a is less than b"

# ╔═╡ eb838c02-5cb1-4113-b12f-1bf42a6b24ee
md"""## Loops
Julia supports classic `for` and `while` loops. Many types can be iterated over, for example ranges and vectors:
"""

# ╔═╡ 7519a12f-7e6a-4ff7-a025-054fd1ca2a70
for i in 1:5
    @info i
end

# ╔═╡ e43c14f1-f6e5-4f47-b4b9-803d5c13ccf9
for name in ["Adrian", "Klaus-Robert"]
    @info name
end

# ╔═╡ ebc873a2-1479-4428-b7ef-7887716b15bf
begin
    i = 1
    while i <= 5
        @info i
        i += 1
    end
end  # begin ... end block is only needed for Pluto

# ╔═╡ 5464d9a5-7988-4e42-b406-b0f6f0da850d
tip(
    md"Instead of the function `println()`, we used the logging macro `@info`.

This macro creates a log of the message on its right and looks a bit better inside Pluto Notebooks.
Here, the message we log is just the value of the integer `i` or string `name`.
",
)

# ╔═╡ 9a353b99-091f-4ac5-8b8b-4b4102b50f8e
md"""### Preliminary exit
We can use `break` to exit from `for` and `while` loops:
"""

# ╔═╡ c67cba22-d6fb-46b2-8ad0-1207d7a9c10e
for i in 1:100000
    i > 5 && break
    @info i
end

# ╔═╡ 35c8bd0d-dbff-4ca0-832e-0110d95d6e09
md"""### Skipping iterations
We can use `continue` to skip an iteration:
"""

# ╔═╡ 548f6bf8-b0d5-44d9-984c-71a5e74ee265
for i in 1:5
    # skip printing even numbers
    i % 2 == 0 && continue
    @info i
end

# ╔═╡ a27ae3a1-6506-48ce-a818-0092047d8d27
md"""# Functions
Functions in Julia are defined in a `function ... end` block:
"""

# ╔═╡ 1c527f2a-5b89-4192-837c-8fe15b5741ee
function my_add(x, y)
    return x + y
end

# ╔═╡ 19d4185f-3d42-4f37-8597-427598912375
my_add(2, 3)

# ╔═╡ 96c0720f-4fee-4761-950d-8d79283e6907
md"""The `return` keyword can be omitted, in which case the value of the last evaluated expression is returned.

Functions can also be defined in more compact "assignment form":
"""

# ╔═╡ f5fd5cce-7a1a-4039-9579-fa16ebf893e9
my_add_2(x, y) = x + y

# ╔═╡ 015ee10c-f774-4190-8540-a170e27539d0
my_add_2(2, 3)

# ╔═╡ 540c3e7f-63ea-4a55-a1ba-7b7a5d4e65a1
md"""## Multiple return values
Functions can return multiple values, separated by commas:
"""

# ╔═╡ 92f705dd-989c-4ff7-beb1-f626a04d51cd
function foo(x)
    return x, x + 1
end

# ╔═╡ 32f8e2f4-d10e-420d-b9f7-3e673fc48b77
x1, x2 = foo(5)

# ╔═╡ 1c5a2d9b-14ac-40c8-a795-e4036c318f80
md"Julia generally allows for easy destructuring – even outside of functions. Let's see some examples:"

# ╔═╡ c609715c-468f-4661-b5a6-98b34b0c6f4c
c1, c2, c3 = 1:3

# ╔═╡ ec953f3f-a015-4ef8-b5f5-b62d4c547c00
c2

# ╔═╡ bb4fa63b-05a6-4ae5-8f7f-7e47fcd5f287
md"This can also be used in for-loops:"

# ╔═╡ dcbca7f5-b91e-42a6-9af5-be765e050b55
for (i, c) in [(1, 'a'), (2, 'b'), (3, 'c')]
    @info "Integer $i and Character $c"
end

# ╔═╡ 7241b486-bbf3-4af2-ad57-b5eadb2d93f3
md"And destructuring generally also works recursively:"

# ╔═╡ ef293478-a134-4655-8ed7-37d52e0bf1fb
nested_inputs = [(1, ('a', 1.11)), (2, ('b', 2.22)), (3, ('c', 3.33))]

# ╔═╡ dcba0f1e-849d-434a-ae02-456a0a47cb8b
for (i, (c, f)) in nested_inputs
    @info "Integer $i, Character $c and Float $f"
end

# ╔═╡ 4e11b311-8ce2-4612-a6fd-4ddb5f214bda
md"""## Argument type declarations
Acceptable argument types can be declared within the function arguments using `::TypeName`.
The following function will only work on subtypes of `Integer`:
"""

# ╔═╡ 16b013cd-5ac2-4731-8899-552c6bff5dfa
function my_factorial(n::Integer)
    n >= 0 || error("n must be non-negative")
    n == 0 && return 1
    return n * my_factorial(n - 1)
end

# ╔═╡ 4419e09b-17bb-4f23-bebe-d9f841b15b1e
my_factorial(4) # Default Int = Int64

# ╔═╡ 2c6c2253-2ed7-4edf-9276-6075e5ab39f2
my_factorial(0x04) # 0x04 == UInt8(4)

# ╔═╡ ddf0666f-3048-4bd3-af0e-694e6c59554a
my_factorial(4.0) # errors on Floats!

# ╔═╡ 5c6a6419-3d2e-46a9-bd26-cd6789fc5691
md"""## Functions are first-class objects
Functions in Julia are [first-class objects](https://en.wikipedia.org/wiki/First-class_citizen) and can be used like variables.
Let's demonstrate this on the function `my_factorial` we previously defined:
"""

# ╔═╡ 5d89d0ab-cf59-4c74-9f40-d47280a9645a
my_factorial_2 = my_factorial

# ╔═╡ 2bac36e1-0217-42aa-8d76-cf8128e73365
my_factorial_2(4)

# ╔═╡ 569644b7-23ba-4fc9-be70-637a41090676
md"Functions are of type `typeof(function_name)` with parent type `Function`:"

# ╔═╡ 1f7cbb1c-257e-4e69-81a2-eec48e18eca5
typeof(my_factorial)

# ╔═╡ cf46afbb-f73b-4ef2-9f6c-ceb78a964af0
md"""## Higher-order functions
Functions can also return functions:
"""

# ╔═╡ 99d7a398-b532-4829-9bc0-87ab510a88cf
function make_multiplier(x)
    function times_x(y)
        return x * y
    end
    return times_x
end

# ╔═╡ c559c6d6-acef-490f-9a29-f3cac37e249e
times_two = make_multiplier(2)

# ╔═╡ 558e5589-9eed-4c03-a145-a868d251d58e
times_two(8)

# ╔═╡ 2b944e3c-1a90-4b11-924f-a771ad41e5c5
md"""## Optional arguments
Optional arguments provide a way to implement sensible default values for function arguments.

Let's implement a general $p$-norm function

$\|x\|_p ~=~ \left(\sum_n|x_n|^p\right)^{\frac{1}{p}}$

which defaults to the $\ell^2$-norm using $p=2$:
"""

# ╔═╡ 89f79535-2681-4a93-a80f-28f74f22be0c
function my_norm(xs, p=2)
    return sum(xs .^ p)^(1 / p)
end

# ╔═╡ cd0ef716-5f6e-478e-a45c-536ff93ae82d
my_norm([1, 2, 3])

# ╔═╡ 0662860a-ab3d-4af1-9006-036878796ec4
my_norm([1, 2, 3], 2)

# ╔═╡ 1db747f4-e346-4ebb-98a8-52c5c54c0d0f
my_norm([1, 2, 3], 1)

# ╔═╡ 5a3cd927-b806-4f36-bb27-8f8f000a62a5
md"## Keyword arguments
At first, it might be confusing that Julia offers both optional and keyword arguments.

Let's highlight differences by reimplementing the previous function using keyword arguments. Keyword arguments are separated from (optional) arguments using a semicolon `;` in the function signature:
"

# ╔═╡ 52cf9d22-08a5-4937-b81c-d9ced5f1a584
function my_norm_kw(xs; p=2)
    return sum(xs .^ p)^(1 / p)
end

# ╔═╡ f0d36634-8ced-4c2b-83f1-d60bec137402
my_norm_kw([1, 2, 3])

# ╔═╡ 6d0f066a-5085-4f35-895d-c36d840296e0
md"Calling the function without explicitly stating the keyword argument name will result in an error:"

# ╔═╡ 800dc904-4f1c-4aa8-b8c5-5737d92325da
my_norm_kw([1, 2, 3], 1) # errors since keyword is missing!

# ╔═╡ 61a04197-deaa-4b08-bf0e-d0245e9ae678
my_norm_kw([1, 2, 3]; p=1) # works

# ╔═╡ e9d34b48-4069-4629-97d3-e2b6da0e6ff8
md"""Typically, keyword arguments are used for functions with a large number of behaviors or "settings". They make function calls easier to read, since each keyword argument is labeled by its name.
"""

# ╔═╡ baa8ebb9-ad5c-44fd-9316-1b63fec81ffc
tip(
    md"""
Our `my_norm` function is an example where optional arguments are better suited than keyword arguments. The purpose of this example was to highlight differences between the two argument types.

One example where keyword arguments are more suitable than optional arguments is a plotting function that allow users to set multiple options such as line color, width and style:
```julia
function plot(x, y; style="solid", width=1, color="black")
    # ...
end
```
""",
)

# ╔═╡ faecf80f-166f-4850-9ef2-13df3f6addc3
md"""## Anonymous functions
Functions can also be created "anonymously" without giving them a name using the syntax

	(inputs) -> outputs

This is also known as a "Lambda-function". These functions are especially useful for functions that take other functions as inputs, e.g. `map` and `filter`.

`map` takes a function and applies in to each value of an array. Let's demonstrate this by squaring and adding 1 to all numbers from 1 to 5:
"""

# ╔═╡ 69ca1efc-630b-4fc2-af86-cc61f7eee3f6
map(x -> x^2 + 1, 1:5)

# ╔═╡ 34809709-6d38-4e63-a962-ef6519a6c6f2
md"We can also `filter` out numbers between 1 and 10 which are divisible by 3:"

# ╔═╡ 91deeb65-6522-42b1-a545-4bf950cad7fe
filter(x -> x % 3 == 0, 1:10)

# ╔═╡ 670ea56a-0c91-4558-8441-d327c4b8d423
md"""Anonymous functions can also have multiple inputs using the syntax `(x, y) -> 2x + y`."""

# ╔═╡ abaa2851-df38-4e50-84d6-3356d3611a38
md"""## Function composition
Let's compose two functions `f` and `g`.
The most common approach is calling `g(f(x))`:
"""

# ╔═╡ bc7ddafa-26c8-4fc5-9051-4c10a867a947
sqrt(sum(1:10))

# ╔═╡ 995b1f73-f3a2-4671-a824-b85cccdbd8d8
md"""### Pipes
We can also use the piping operator `|>` to chain functions.
Using pipes, `g(f(x))` can be written as `f(x) |> g`.
"""

# ╔═╡ 5fe2af35-2e93-46be-b0fa-c6b6af2f9866
sum(1:10) |> sqrt

# ╔═╡ c140df86-7a1b-4c25-a6b9-e8c070e66615
md"""### Composition operator ⁽⁺⁾
We can also compose functions using  `∘` (`\circ<TAB>`).
This matches mathematical notation for function composition:
"""

# ╔═╡ ac2c8cb8-bf89-4eff-a4e2-0feedfc84521
(sqrt ∘ sum)(1:10)

# ╔═╡ e3c47b17-cc63-414a-b3af-8dd14851d759
md"remember that functions can be used like variables:"

# ╔═╡ 67d03c44-df17-419b-ada3-201229774527
sqrt_of_sum = sqrt ∘ sum # h = g ∘ f

# ╔═╡ b599d93f-e50d-4e63-8116-b3fd4ed0f798
sqrt_of_sum(1:10)

# ╔═╡ e2eaf8cd-40b6-4c16-8f76-7aaea0985b0a
md"""# Multiple dispatch
You will frequently want to have different implementations of a function based on its input types.

For example, a function `multiply(a, b)` requires different implementations based on whether `a` and `b` are real numbers, complex numbers or even matrices.
In Julia, each implementation of a function is called a *method*.

Julia automatically selects the correct method to apply based on *all* input types of a function. This is called *multiple dispatch*.
"""

# ╔═╡ ea0149e9-4ea4-4513-999f-4a44393c63a8
test_dispatch(x) = "General case: $(typeof(x)), x=$(x)"

# ╔═╡ d76a2109-ac2e-44b6-8eab-7be50e2632e6
test_dispatch(x::Float64) = "Special case: Float64, x=$(x)"

# ╔═╡ 9bfec8ef-1fa8-4318-92fd-90935f935e9c
test_dispatch(2)

# ╔═╡ 2c853e88-fdeb-4492-83b2-f65e704c14c1
test_dispatch(2.0)

# ╔═╡ d99f7bc2-dfae-4543-b38e-b4c7191d2e0e
test_dispatch("Hello world")

# ╔═╡ ebc6a699-c2e1-4988-a992-c9bf329aefa4
md"""The methods of function `f` can be shown using `methods(f)`, e.g. for the sine function:
"""

# ╔═╡ 62e799db-8058-4745-b9e3-cbb6761acebd
methods(sin)

# ╔═╡ 4b05bb8d-c6e8-4736-90e3-c79154aa36f3
md"""# Comprehensions
Comprehensions are a powerful and compact way to define arrays.
The syntax somewhat resembles set notation in mathematics:
"""

# ╔═╡ de2ae139-f928-4901-aab0-31162477aab6
v3 = [x^2 for x in 1:10]

# ╔═╡ 35f9917d-bf2c-499a-a3ef-41e78f375033
md"It is also possible to pass an additional filtering function. For example, we can get a vector of the squares of all even numbers from 1 to 10:"

# ╔═╡ a8864f40-886f-4b9e-9433-796a2f298608
v4 = [x^2 for x in 1:10 if iseven(x)]

# ╔═╡ 34fc83bd-662e-40b0-bab6-9c18ae2f92c4
md"""# Broadcasting
Any function `f(A)` can be applied element-wise over its inputs by using the syntax `f.(A)`:
"""

# ╔═╡ a0a77ce0-c509-4230-a268-113147e04089
test_array = [1, 2, 3, 4, 5]

# ╔═╡ f8f62831-b5e1-4747-8b98-d6cff3d24d6c
sin.(test_array)

# ╔═╡ 90964587-3913-41a2-9067-d83099bebe64
md"this also works on user defined functions"

# ╔═╡ 72380c6b-c07d-4fa7-9840-b4efeb0d5cec
add_two(x) = x + 2

# ╔═╡ c39d3b94-e1c6-479f-a196-5ddc4c193b21
add_two.(test_array)

# ╔═╡ 3c9837fd-cf97-4289-90b7-1295d7371cae
md"as well as on the operators we have learned about today. Simply add a dot before an operator:"

# ╔═╡ 584889ca-7ef1-4c37-8f33-f91ca2f156d2
test_array .^ 2

# ╔═╡ 5789f130-dab3-4042-a283-ae88d433a4d8
2 .^ test_array

# ╔═╡ e03c8042-d8f6-49d3-b075-ff0689755176
tip(md"We will cover broadcasting in more detail in lecture 2.")

# ╔═╡ 0468b820-4879-4db4-b3a7-646f05eba11d
md"""# Further resources
Cheat sheets:
- [MATLAB–Python–Julia cheat sheet](https://cheatsheets.quantecon.org)
- [The Fast Track to Julia](https://cheatsheet.juliadocs.org)

Noteworthy differences from other languages:
- [Differences from Python](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-Python)
- [Differences from MATLAB](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-MATLAB)
- [Differences from C/C++](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-C/C)
- [Differences from R](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-R)
- [Differences from Common Lisp](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-Common-Lisp)

Other:
- [Julia documentation](https://docs.julialang.org/en/v1/)
- [Official learning resources](https://julialang.org/learning/)
- [Performance Tips](https://docs.julialang.org/en/v1/manual/performance-tips/)
"""

# ╔═╡ 9723d981-3c86-4ae9-ada9-8c9f95c31552
tip(
    md"If you are viewing this notebook from the course website, you might have to `Ctrl + click` links. Alternatively, use the standalone notebooks.",
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractTrees = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractTrees = "~0.4.5"
PlutoTeachingTools = "~0.3.1"
PlutoUI = "~0.7.62"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "6ebd83e7e3c8abf01e89b247385e3b0b31c651f8"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

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

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

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
# ╟─f28ab96e-ff8a-46b4-b3db-b8ad5975352e
# ╠═1fcbc08a-a0b7-11ed-0477-13c86a949723
# ╟─c5e6183d-8fc9-47f4-aff4-6a0fa75b3e4b
# ╟─98428309-2e55-4c8b-8c3a-3e98e677a1b2
# ╟─c854cbe0-5e36-4569-9e1f-d17b2c3540d5
# ╟─04376141-9c94-4197-804a-932c35a53777
# ╟─6352d357-885e-463f-94e9-ae6fc4f79593
# ╠═b42d464b-800a-43c1-bb55-447f3c49c3c7
# ╟─054e2dd9-ccfa-41d7-8cbf-33b1645fd946
# ╠═4a8c7c6b-a7d7-44be-b767-ca5e2a31d30f
# ╠═836e1bd2-83a1-4466-9c28-ef33b0180101
# ╟─02dd64df-148d-4964-97f8-49b9c83880da
# ╠═5e68f32e-5568-4a5f-9b9b-7a211df15968
# ╠═b0502992-7e67-44f5-98d5-2d78ac6fe5b6
# ╟─7437fcfc-fb33-4855-bacd-a34160af6b24
# ╠═13a11350-9140-410a-8559-22f8fb6b843e
# ╠═e4773a83-d22e-4312-a05d-93d8a8552c35
# ╠═983319a6-d28c-4767-89d3-8c161825e8b4
# ╟─32354273-fa48-49ac-9a3a-12ad459495d5
# ╟─3df66af5-97cb-4251-8c65-a218f39fca25
# ╟─aeb1472b-3c6f-4697-bcff-324ac0f9339f
# ╠═d9f68f07-9838-4598-bd70-a6aed8abf48c
# ╟─f8d1ea84-3b4e-42a3-9c26-46beab337206
# ╠═f9fe25cf-16d3-42bc-9102-d4e330af2d0c
# ╠═e9fd1f66-3c48-4d2b-a3b0-4f3b990087ff
# ╟─e2bef8fb-6758-4528-bd24-f57c34b3e964
# ╠═4ef04a45-9596-487c-83c7-6f35f6ffbf4c
# ╟─f112529a-9b05-4428-b5fe-fad6fad7afa0
# ╠═36c9b759-8244-48e9-95f3-626538626f9d
# ╟─c026d456-8178-446d-948c-8bbbf2faee19
# ╠═71bcc34c-23d7-4a27-86cc-759010c5c611
# ╟─bded41c2-763d-4140-85d4-7ef8390d4c23
# ╠═c5bf7c2e-1453-47a8-822c-b100add67763
# ╟─f8c9b6ec-534c-4fcf-93b8-6db9b23ed883
# ╠═d0769dac-14c7-4cf7-92bf-145a5cf975f1
# ╠═3714ec58-382f-44d4-a542-447492f52f7b
# ╟─3655a334-2f88-4089-a099-06bd8d4de51f
# ╠═b132137d-c60a-4b7e-ad65-00996d7732ce
# ╟─23ab05c1-e50c-4a78-af18-923f5a6fc83d
# ╠═a9fd1637-3569-4a72-9baf-041b5e472139
# ╠═8fd7eeac-656d-4e46-b389-9b215bac5f22
# ╟─247071c7-36f1-4693-bcf1-a2b3057e719b
# ╟─16b68419-c91c-406e-a50c-7aed4839324d
# ╟─597bfad2-5c79-47a4-b42f-18ab869f0e30
# ╠═42e09352-09d0-490d-8115-3a417a509a20
# ╟─77b1970a-604e-406a-ac89-fd5cdc028b3b
# ╠═717c9384-dde9-4f4d-ad7a-344444ec09b2
# ╠═abd59d28-4a1e-4444-a7fa-292fdc24f91b
# ╟─be04937c-bdc3-4844-a595-fd7611337395
# ╠═1f7c2b9f-67e9-4518-ae2a-d2c7dd23c788
# ╠═df4edb12-f733-47b3-8a5a-4a33e8c0c7b8
# ╟─83af70d7-84e3-48c6-a1d3-b75ede505939
# ╟─4072af54-cb68-43a6-aea1-918c8e3434b9
# ╟─0487d1ce-c6e8-40cb-b96c-94681f28c8d8
# ╟─fbc531cb-d98a-45f5-8993-3f702a13090b
# ╠═30282852-5756-42f8-a64a-b0e3ae2726eb
# ╟─348cf13f-74c3-4937-a3dc-9190b96aa72d
# ╟─dd88e8aa-a06a-4d00-8d7f-76ebb43a3947
# ╠═9b61b024-42d6-4617-9f8e-9e81d24e5283
# ╠═8ac5222c-2e6c-4b64-a133-54ffb484e003
# ╟─d3bf40a2-7507-4de0-84d2-d7a628b444f0
# ╠═008d2d39-5f5c-409a-96b8-3ad0d512599c
# ╠═0e9c89cc-461e-40bf-b8cb-f15f9e0f7e4f
# ╟─a6214274-3fb6-4f14-ace0-257f1078a742
# ╠═7039ea01-28e4-40c9-9fdd-2be14ffe2345
# ╟─f7d7321c-eca8-4fcb-8d7e-a44fd34725f5
# ╠═eb36af06-2684-4b21-b8d9-48ebf07cc9d3
# ╠═e7fc26ef-fb85-438f-9703-c33dfd05d2de
# ╟─b4168f31-4f53-4e06-a1c8-61db7b90d2dd
# ╟─bb044ef2-0d77-4748-82af-d7103cca3157
# ╠═16dec848-9518-4afe-8f6b-f831179a7a3e
# ╠═13426af6-42b7-4265-b0e8-60144363395e
# ╠═450b01ee-2d5f-4463-a9de-559ee66576ef
# ╟─b41bee43-f510-483f-9a12-d9d577367272
# ╠═271cf99f-92ea-4e8c-ba0d-c4d848c5bb31
# ╠═fa9944fe-60c2-463e-af0c-cd836eade2f0
# ╟─9358e01f-71b4-4ee1-96ca-2f754f011c71
# ╠═6e16fd91-bd6b-43c2-9f07-e54cfe1ad503
# ╠═f02acec5-adf4-4b3c-9d68-18032d5b7017
# ╟─be8ed1b2-f2f7-4b38-b47c-c2d78730af23
# ╠═83130d05-383a-4461-be95-3b8f296a8238
# ╟─033e9b34-7c10-4bbb-9004-36f6c4ee4052
# ╠═269667c2-7f00-4369-8eb8-85e493e059ef
# ╠═7893d98f-dacf-42bd-a587-f38b1cf2373f
# ╟─640f0f22-7021-461c-8e04-d5f0661aa72f
# ╟─bbda2d1d-f40e-4cfb-a8dc-a9561ff87213
# ╟─e0ab8571-1cc8-40e4-aaf0-68500895fa42
# ╟─016ffd81-f142-42c4-93c0-e1ae71a4bfce
# ╠═a9d7b66e-89a2-427b-b0ac-8311a9f60d38
# ╠═4200ad17-c27f-476e-a5c4-95f17233cc30
# ╟─b19f7ea2-db9d-4f3a-b9d6-6a6fd7ff5304
# ╟─06e254b9-c460-46b1-94b5-f9a8d8079c83
# ╠═1e3f2868-5746-43db-a5cb-c628ea24ccd8
# ╠═0a163913-b59f-4bab-a1c5-244b32ac66ad
# ╟─89bc13bc-d747-4f42-b62b-c229c79002d1
# ╠═fa0a7a24-8ac3-46da-91f7-7a285959997f
# ╟─ff822cbc-7d8b-4b75-a2eb-891d9ee2ff70
# ╟─bdf9a3ed-6017-4ac0-a7eb-95a4e96636a6
# ╟─ea2353c2-a2c9-4d87-a316-ab952bc0b3ee
# ╠═eede6d0a-36d3-4802-941c-a0ca5051335e
# ╠═6efde913-04d7-4f49-8d52-4c369506a6cb
# ╟─ae5ac145-ce40-4bfa-9e6d-69a253c27931
# ╠═3496a358-8fdd-4fbb-8125-6c35c06012af
# ╠═91ac1cca-edbd-4534-9e97-261dfa334cb1
# ╟─feadce71-ec02-4e70-a552-8f3f3245a750
# ╟─bc8f2317-3cb9-4a8c-85a9-16d2607d47f7
# ╠═49ccb9ae-59f5-46ef-a227-24b9c275fdd9
# ╠═de326b18-197b-4ca7-af28-138ad2a5967a
# ╟─47ad8eeb-7ac2-48b2-baf0-10619b291824
# ╠═ed5a17d0-74a5-493d-8205-e5555958a0f3
# ╟─0fa8b370-cf2a-47b8-ac3b-479e1221202b
# ╠═2c82b252-dd51-44f2-a20c-a0ffb65ee210
# ╠═5a5b2ebd-1da6-42ca-90d6-e63645ded46b
# ╟─9a12c858-74df-41b7-9ca6-6fdd47b430fb
# ╠═c52cd9c7-aa09-4881-b7a3-ee94c9124790
# ╟─64f1fb95-4267-45da-a8cf-7707bc18ac96
# ╠═34c689ca-eba3-46e7-a246-cd58d5f03cdc
# ╟─e73639d0-5dd2-42f6-abc2-6b67a9489fd5
# ╠═57e3ddbf-e2ba-4407-90ba-5cbee3ceb605
# ╟─dca1cc1f-4c30-468c-822b-f0ac2ed2a6fd
# ╠═f5329516-df0f-44cc-b6bb-9a652742ce9c
# ╠═52c35f28-1bac-4f68-a437-d9a175ba5e10
# ╠═6eb7ffa2-0d10-4036-a5d9-5fdd2af3bf0d
# ╟─bc521f35-f827-459a-adaf-881d7c37ecfd
# ╠═97548f86-66af-4ec3-89f0-431e06cdcad4
# ╟─d7d66a70-21bd-4ac5-acc8-fb971bfd5b60
# ╠═8f9c8a0d-a656-41b5-b9c7-c147a5eed86b
# ╟─eb838c02-5cb1-4113-b12f-1bf42a6b24ee
# ╠═7519a12f-7e6a-4ff7-a025-054fd1ca2a70
# ╠═e43c14f1-f6e5-4f47-b4b9-803d5c13ccf9
# ╠═ebc873a2-1479-4428-b7ef-7887716b15bf
# ╟─5464d9a5-7988-4e42-b406-b0f6f0da850d
# ╟─9a353b99-091f-4ac5-8b8b-4b4102b50f8e
# ╠═c67cba22-d6fb-46b2-8ad0-1207d7a9c10e
# ╟─35c8bd0d-dbff-4ca0-832e-0110d95d6e09
# ╠═548f6bf8-b0d5-44d9-984c-71a5e74ee265
# ╟─a27ae3a1-6506-48ce-a818-0092047d8d27
# ╠═1c527f2a-5b89-4192-837c-8fe15b5741ee
# ╠═19d4185f-3d42-4f37-8597-427598912375
# ╟─96c0720f-4fee-4761-950d-8d79283e6907
# ╠═f5fd5cce-7a1a-4039-9579-fa16ebf893e9
# ╠═015ee10c-f774-4190-8540-a170e27539d0
# ╟─540c3e7f-63ea-4a55-a1ba-7b7a5d4e65a1
# ╠═92f705dd-989c-4ff7-beb1-f626a04d51cd
# ╠═32f8e2f4-d10e-420d-b9f7-3e673fc48b77
# ╟─1c5a2d9b-14ac-40c8-a795-e4036c318f80
# ╠═c609715c-468f-4661-b5a6-98b34b0c6f4c
# ╠═ec953f3f-a015-4ef8-b5f5-b62d4c547c00
# ╟─bb4fa63b-05a6-4ae5-8f7f-7e47fcd5f287
# ╠═dcbca7f5-b91e-42a6-9af5-be765e050b55
# ╟─7241b486-bbf3-4af2-ad57-b5eadb2d93f3
# ╠═ef293478-a134-4655-8ed7-37d52e0bf1fb
# ╠═dcba0f1e-849d-434a-ae02-456a0a47cb8b
# ╟─4e11b311-8ce2-4612-a6fd-4ddb5f214bda
# ╠═16b013cd-5ac2-4731-8899-552c6bff5dfa
# ╠═4419e09b-17bb-4f23-bebe-d9f841b15b1e
# ╠═2c6c2253-2ed7-4edf-9276-6075e5ab39f2
# ╠═ddf0666f-3048-4bd3-af0e-694e6c59554a
# ╟─5c6a6419-3d2e-46a9-bd26-cd6789fc5691
# ╠═5d89d0ab-cf59-4c74-9f40-d47280a9645a
# ╠═2bac36e1-0217-42aa-8d76-cf8128e73365
# ╟─569644b7-23ba-4fc9-be70-637a41090676
# ╠═1f7cbb1c-257e-4e69-81a2-eec48e18eca5
# ╟─cf46afbb-f73b-4ef2-9f6c-ceb78a964af0
# ╠═99d7a398-b532-4829-9bc0-87ab510a88cf
# ╠═c559c6d6-acef-490f-9a29-f3cac37e249e
# ╠═558e5589-9eed-4c03-a145-a868d251d58e
# ╟─2b944e3c-1a90-4b11-924f-a771ad41e5c5
# ╠═89f79535-2681-4a93-a80f-28f74f22be0c
# ╠═cd0ef716-5f6e-478e-a45c-536ff93ae82d
# ╠═0662860a-ab3d-4af1-9006-036878796ec4
# ╠═1db747f4-e346-4ebb-98a8-52c5c54c0d0f
# ╟─5a3cd927-b806-4f36-bb27-8f8f000a62a5
# ╠═52cf9d22-08a5-4937-b81c-d9ced5f1a584
# ╠═f0d36634-8ced-4c2b-83f1-d60bec137402
# ╟─6d0f066a-5085-4f35-895d-c36d840296e0
# ╠═800dc904-4f1c-4aa8-b8c5-5737d92325da
# ╠═61a04197-deaa-4b08-bf0e-d0245e9ae678
# ╟─e9d34b48-4069-4629-97d3-e2b6da0e6ff8
# ╟─baa8ebb9-ad5c-44fd-9316-1b63fec81ffc
# ╟─faecf80f-166f-4850-9ef2-13df3f6addc3
# ╠═69ca1efc-630b-4fc2-af86-cc61f7eee3f6
# ╟─34809709-6d38-4e63-a962-ef6519a6c6f2
# ╠═91deeb65-6522-42b1-a545-4bf950cad7fe
# ╟─670ea56a-0c91-4558-8441-d327c4b8d423
# ╟─abaa2851-df38-4e50-84d6-3356d3611a38
# ╠═bc7ddafa-26c8-4fc5-9051-4c10a867a947
# ╟─995b1f73-f3a2-4671-a824-b85cccdbd8d8
# ╠═5fe2af35-2e93-46be-b0fa-c6b6af2f9866
# ╟─c140df86-7a1b-4c25-a6b9-e8c070e66615
# ╠═ac2c8cb8-bf89-4eff-a4e2-0feedfc84521
# ╟─e3c47b17-cc63-414a-b3af-8dd14851d759
# ╠═67d03c44-df17-419b-ada3-201229774527
# ╠═b599d93f-e50d-4e63-8116-b3fd4ed0f798
# ╟─e2eaf8cd-40b6-4c16-8f76-7aaea0985b0a
# ╠═ea0149e9-4ea4-4513-999f-4a44393c63a8
# ╠═d76a2109-ac2e-44b6-8eab-7be50e2632e6
# ╠═9bfec8ef-1fa8-4318-92fd-90935f935e9c
# ╠═2c853e88-fdeb-4492-83b2-f65e704c14c1
# ╠═d99f7bc2-dfae-4543-b38e-b4c7191d2e0e
# ╟─ebc6a699-c2e1-4988-a992-c9bf329aefa4
# ╠═62e799db-8058-4745-b9e3-cbb6761acebd
# ╟─4b05bb8d-c6e8-4736-90e3-c79154aa36f3
# ╠═de2ae139-f928-4901-aab0-31162477aab6
# ╟─35f9917d-bf2c-499a-a3ef-41e78f375033
# ╠═a8864f40-886f-4b9e-9433-796a2f298608
# ╟─34fc83bd-662e-40b0-bab6-9c18ae2f92c4
# ╠═a0a77ce0-c509-4230-a268-113147e04089
# ╠═f8f62831-b5e1-4747-8b98-d6cff3d24d6c
# ╟─90964587-3913-41a2-9067-d83099bebe64
# ╠═72380c6b-c07d-4fa7-9840-b4efeb0d5cec
# ╠═c39d3b94-e1c6-479f-a196-5ddc4c193b21
# ╟─3c9837fd-cf97-4289-90b7-1295d7371cae
# ╠═584889ca-7ef1-4c37-8f33-f91ca2f156d2
# ╠═5789f130-dab3-4042-a283-ae88d433a4d8
# ╟─e03c8042-d8f6-49d3-b075-ff0689755176
# ╟─0468b820-4879-4db4-b3a7-646f05eba11d
# ╟─9723d981-3c86-4ae9-ada9-8c9f95c31552
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
