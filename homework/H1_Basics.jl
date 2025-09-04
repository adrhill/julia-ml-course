### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 755b8685-0711-48a2-a3eb-f80af39f10e1
begin
    using PlutoUI
    using PlutoTeachingTools
end

# ╔═╡ 4132e946-126d-43a8-85ab-c149adbbff81
html"""<style>.dont-panic{ display: none }</style>"""

# ╔═╡ f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
html"""
	<h1 style="text-align:left">
		Julia for Machine Learning
	</h1>
	<div style="text-align:left">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Homework 1: Julia Programming Basics
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Winter Semester 25/26<br>
		</p>
	</div>
"""

# ╔═╡ bdcb27c5-0603-49ac-b831-d78c558b31f0
md"Due date: **Monday, October 27th 2025 at 23:59**"

# ╔═╡ 6be73c03-925c-4afa-bd66-aca90e6b49fe
md"This notebook gives you live feedback!
Colored boxes in this notebook automatically run tests and keep you on the right track. Editing your code and running it will re-run all corresponding tests.

As part of the grading process, additional tests will be run by the instructors.
You are not allowed to use any additional Julia packages.

Please don't upload solutions to the exercises online!
"

# ╔═╡ ddd6e83e-5a0d-4ff0-afe4-dedfc860994c
md"### Student information"

# ╔═╡ d03e4e95-faab-4ab3-ab27-81189cbd8231
student = (
    name="Mara Mustermann",
    email="m.mustermann@campus.tu-berlin.de", # TU Berlin email address
    id=456123, # Matrikelnummer
)

# ╔═╡ ff5d316f-806c-4652-97d8-323462395c69
# Please don't edit your name here, but in the cell below. Thanks!
md"Submission by: **_$(student.name)_** ($(student.email), Matr.-Nr.: $(student.id))" # DO NOT EDIT

# ╔═╡ 44ec9e94-f6af-431e-8841-bae44431dfa3
if student.name == "Mara Mustermann"
    still_missing(md"""Please replace `"Mara Mustermann"` with your name.
            Use `Shift+Enter` to run your edits.""")
elseif student.email == "m.mustermann@campus.tu-berlin.de"
    still_missing(md"Please enter your TU Berlin E-Mail address.")
elseif student.id == 456123
    still_missing(md"Please enter your TU Berlin student ID (Matrikelnummer).")
elseif !isa(student.id, Number)
    still_missing(md"Please enter your TU Berlin student ID as number, not a string.")
else
    correct()
end

# ╔═╡ 06c0ad65-22d4-4c8e-ae19-4f05ba125e79
md"### Initializing packages
**Note:** Running this notebook for the first time can take several minutes.
"

# ╔═╡ 5061a130-fc0a-4306-bdf5-6966e8de938a
begin
    md_parse(str) = Markdown.parse(str)
    md_parse(md::Markdown.MD) = md
    function task(text, pts=1)
        if pts == 1
            pts_str = "(1 point)"
        elseif pts == 0
            pts_str = ""
        else
            pts_str = "($pts points)"
        end
        Markdown.MD(Markdown.Admonition("Task", "Task " * pts_str, [md_parse(text)]))
    end
end;

# ╔═╡ 8ece9aea-20f5-41db-95ca-08c8d4d2d4c1
task(
    "Please edit the code below with your student information.

Inside the code cell, use `Shift+Enter` to run your edits, or press the `▶` button in the bottom right of the cell.",
    0,
)

# ╔═╡ 74e27f45-9897-4ddd-8516-59669b17b1ad
PlutoTeachingTools.default_language[] = PlutoTeachingTools.PTTEnglish.EnglishUS();

# ╔═╡ d358da52-ee09-4533-a2ef-c68b847e24d5
md"## Exercise 1: Warm up
### Exercise 1.1 – Variables"

# ╔═╡ e5670193-6221-49c6-a880-d287f717545e
task("Define variables such that their type matches the given variable name.
You can give the variables any value you want.", 0.5)

# ╔═╡ b96fde59-1f2a-4d07-a5cc-6ec48e5079f1
my_string = missing # replace `missing` with your code!

# ╔═╡ 12faf3e9-4380-430c-aedf-25380558b09a
my_int = missing

# ╔═╡ 9d20c79d-4f97-4a39-ac1a-eed311a6149a
my_float64 = missing

# ╔═╡ d9a237b0-c112-4ee2-9232-725ce97679dc
my_float32 = missing

# ╔═╡ b8e741c9-feff-4017-a037-0fbd9cd4f49a
my_complex = missing

# ╔═╡ 2001c0fb-e4cd-49d6-b305-429c0597bad2
# my_string
if !@isdefined(my_string)
    not_defined(:my_string)
elseif ismissing(my_string)
    still_missing(md"Replace `missing` in `my_string` with your answer.")
elseif !isa(my_string, String)
    keep_working(
        Markdown.parse("`my_string` should be a `String`. Got `$(typeof(my_string))`.")
    )
    # my_int
elseif !@isdefined(my_int)
    not_defined(:my_int)
elseif ismissing(my_int)
    still_missing(md"Replace `missing` in `my_int` with your answer.")
elseif !isa(my_int, Int)
    keep_working(Markdown.parse("`my_int` should be an `Int`. Got `$(typeof(my_int))`."))
    # my_float
elseif !@isdefined(my_float64)
    not_defined(:my_float64)
elseif ismissing(my_float64)
    still_missing(md"Replace `missing` in `my_float64` with your answer.")
elseif !isa(my_float64, Float64)
    keep_working(
        Markdown.parse("`my_float` should be a `Float64`. Got `$(typeof(my_float64))`.")
    )
    # my_float32
elseif !@isdefined(my_float32)
    not_defined(:my_float32)
elseif ismissing(my_float32)
    still_missing(md"Replace `missing` in `my_float32` with your answer.")
elseif !isa(my_float32, Float32)
    keep_working(
        Markdown.parse("`my_float32` should be a `Float32`. Got `$(typeof(my_float32))`.")
    )
    # my_complex
elseif !@isdefined(my_complex)
    not_defined(:my_complex)
elseif ismissing(my_complex)
    still_missing(md"Replace `missing` in `my_complex` with your answer.")
elseif !isa(my_complex, Complex)
    keep_working(
        Markdown.parse("`my_complex` should be `Complex`. Got `$(typeof(my_complex))`.")
    )
    # Correct!
else
    correct()
end

# ╔═╡ cb395709-4237-488d-a294-7cb6e294c724
md"### Exercise 1.2 – Broadcasting"

# ╔═╡ 2ee7ce83-a828-4468-9daf-7cdbf657e52e
task("""The following expressions are all broken.
Fix each expression by broadcasting.

This only requires **adding a single dot** (`.`) to each line and for one expression exactly one space.""", 0.5)

# ╔═╡ c84be3a2-73a9-42f1-bf6b-3fbf64258cf5
my_square_roots = sqrt([4, 9, 16])

# ╔═╡ a11ccc2b-3c5b-493a-8e8b-8b46b44bd3a4
my_favorite_primes = [7, 12, 18] - 5

# ╔═╡ 6a1c553d-66ef-42da-83ad-5b46a7e4c58b
md"Before you fix the following expressions, think about what you expect them to return!"

# ╔═╡ 6eaffea6-099d-441e-b54b-f08bc9b478c7
my_broadcast_1 = 2^(1:8)

# ╔═╡ a87612a8-62dd-44d4-89c4-c712870b00c3
my_broadcast_2 = (1:8)^2

# ╔═╡ da70e426-ea78-4969-9402-efffd5576238
my_broadcast_3 = (1:8)^(1:8)

# ╔═╡ 35f59a25-0ab4-4c18-82c8-466fdeeb3471
# my_square_roots
if !@isdefined(my_square_roots)
    not_defined(:my_square_roots)
elseif !(my_square_roots == [2.0, 3.0, 4.0])
    keep_working(md"`my_square_roots` still need some work.")
    # my_favorite_primes
elseif !@isdefined(my_favorite_primes)
    not_defined(:my_favorite_primes)
elseif !(my_favorite_primes == [2, 7, 13])
    keep_working(md"`my_favorite_primes` still need some work.")
    # my_broadcast_1
elseif !@isdefined(my_broadcast_1)
    not_defined(:my_broadcast_1)
elseif !(my_broadcast_1 == [2, 4, 8, 16, 32, 64, 128, 256])
    keep_working(md"`my_broadcast_1` still need some work.")
    # my_broadcast_2
elseif !@isdefined(my_broadcast_2)
    not_defined(:my_broadcast_2)
elseif !(my_broadcast_2 == [1, 4, 9, 16, 25, 36, 49, 64])
    keep_working(md"`my_broadcast_2` still need some work.")
    # my_square_roots
elseif !@isdefined(my_broadcast_3)
    not_defined(:my_broadcast_3)
elseif !(my_broadcast_3 == [1, 4, 27, 256, 3125, 46656, 823543, 16777216])
    keep_working(md"`my_broadcast_3` still need some work.")
    # Correct!
else
    correct()
end

# ╔═╡ 56fc8e66-852d-4653-ad4c-2f5ecd0be769
md"### Exercise 1.3 – Types"

# ╔═╡ 23174858-aa5f-42bf-ac1c-56ee88d87f7f
task("Define `my_types` such that it is a vector of the types in `my_vars`.", 0.5)

# ╔═╡ 7d098a0b-1a11-4225-b044-82d29f05ad05
my_vars = [1.3, 'b', 3, im, "String", 2//3]

# ╔═╡ f190cbbb-24e7-4c83-b7fb-9477ccdb5023
my_types = missing  # should be equal to types in `my_vars`

# ╔═╡ a4b05061-e48e-4dbb-aa1c-df242c5b2785
if !@isdefined(my_types)
    not_defined(:my_types)
elseif ismissing(my_types)
    still_missing()
elseif my_types == Vector{Any}
    keep_working(
        md"Don't return the type of `my_vars`, but the types of the elements inside of `my_vars`.",
    )
elseif !isa(my_types, Vector{<:Type})
    keep_working(
        Markdown.parse("`my_types` should be vector of types. Got `$(typeof(my_types))`.")
    )
elseif !(my_types == [Float64, Char, Int64, Complex{Bool}, String, Rational{Int64}])
    keep_working(md"You didn't return the exact types.")
else
    correct()
end

# ╔═╡ 077a73ca-b401-40ef-abae-ea87f78436a3
hint(md"Use `typeof` to return the type of a variable. You can then either
- use the dot-syntax from the previous exercise
- use a list comprehension

Why not try both?
")

# ╔═╡ 5c6660ae-8b04-49ef-b4a7-df47b9e71f67
md"## Exercise 2: Functions
### Exercise 2.1 – Control flow"

# ╔═╡ dabfa315-fa26-4056-8b19-eaab8322db82
task(
    "Implement a function `smaller(a, b)` which returns `a` if `a ≤ b` and `b` if `b < a`.", 0.5
)

# ╔═╡ 49e6ab33-9452-4dc1-ac59-d47e70c325a5
function smaller(a, b)
    # Write your code here!
    return missing
end

# ╔═╡ ffbd5d8c-86f9-4c5d-9d9c-1d1a0083a439
md"Let's see some test outputs:"

# ╔═╡ 12fe4d4b-3f2f-4d26-b4f7-b8e83605c7e8
smaller(1.2, 5.3) # should return 1.2

# ╔═╡ 6edb4abb-02ae-4d18-8cdb-6a47586584a2
smaller(4.2, 2.3) # should return 2.3

# ╔═╡ 712c7e22-f144-4da0-9a6a-37d5a9006336
if !@isdefined(smaller)
    not_defined(:smaller)
else
    let
        result = smaller(2.7, 1.23)
        if ismissing(result)
            still_missing()
        elseif isnothing(result)
            keep_working(md"Did you forget to write `return`?")
        elseif result != 1.23
            keep_working()
        elseif smaller(1//3, 1//2) != 1//3
            keep_working()
        elseif smaller(1.23, 1.23) != 1.23
            keep_working()
        else
            correct()
        end
    end
end

# ╔═╡ 60b79139-13d1-4945-9c50-66b0304e7e75
md"### Exercise 2.2 – Loops"

# ╔═╡ 3039f9f1-9077-4050-b0d6-c404612d2e38
task(
    "Write a function `my_sum` that computes the sum of all elements in a vector **using a for-loop**.", 0.5
)

# ╔═╡ f54461c4-392c-4a83-933c-d30a41ce4e0e
function my_sum(xs)
    # Write your code here!
	return missing
end

# ╔═╡ bcb0ff95-f769-46f3-abf3-d5807107413b
md"Remember that you can add your own cells to test your code while you write it.

Simply click the `+` symbol on the left of a cell to add another cell below or above it.
"

# ╔═╡ de7f59f0-17b5-41a0-be32-cbaad14d777e
my_sum([1, -2, 4]) # From here on, test your functions by yourself!

# ╔═╡ 6d988869-35f6-4771-9002-b8b32560e1cc
if !@isdefined(my_sum)
    not_defined(:my_sum)
else
    let
        result = my_sum([1, 5, 4, -2])
        if ismissing(result)
            still_missing()
        elseif isnothing(result)
            keep_working(md"Did you forget to write `return`?")
        elseif result != 8
            keep_working()
        else
            correct()
        end
    end
end

# ╔═╡ d0377938-ca4b-4186-b708-b31a23e23807
md"### Exercise 2.3 – List comprehensions"

# ╔═╡ 2b4dac4c-e710-407d-aa78-4ed181748cf8
task(
    md"""Write a function `my_powers(x, ymax)` that returns a vector of numbers $x^y$ for all $y$ from 1 to $y_{max}$:

$\left[ x^1, x^2, \ldots, x^{y_{max}}\right]$
""", 0.5
)

# ╔═╡ af9b11ed-bb17-4ff3-a8f8-057f4777e5f9
function my_powers(x, ymax::Int)
    # You don't have to change this line:
    ymax < 1 && error("ymax has to be larger or equal 1.")

    # but you have to write code here!
    return missing
end

# ╔═╡ b74c95c2-db7a-4a72-b7c6-3e6644d90158
md"Once you've written the function, you can interact with it using PlutoUI sliders:"

# ╔═╡ 20283e2f-9c00-43d2-bafd-1044ef520248
@bind pow Slider(1:20; default=5, show_value=true)

# ╔═╡ 2011a382-c148-4b7b-a78d-d2813c0d4fcf
my_powers(2, pow)

# ╔═╡ b5711f19-cd31-46b1-92c1-f51480c9065a
if !@isdefined(my_powers)
    not_defined(:my_powers)
else
    let
        result = my_powers(2, 10)
        if ismissing(result)
            still_missing()
        elseif isnothing(result)
            keep_working(md"Did you forget to write `return`?")
        elseif result != [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024]
            keep_working()
        elseif my_powers(3, 10) == [3, 9, 27, 81, 243, 729, 2187]
            keep_working()
        else
            correct()
        end
    end
end

# ╔═╡ 16fdaf27-8345-436d-911c-ef09e9bb48e8
md"## Exercise 3: Data preprocessing
Our goal in this exercise is to write a data preprocessing utility that standardizes our data before we apply it to a machine learning algorithm. We will do this step by step on a small toy dataset:
"

# ╔═╡ 2f483635-5080-48c6-b961-9dbc916268a4
test_data = [
    -2.463,
    -0.934,
    -1.854,
    -3.875,
    2.477,
    -1.1875,
    -1.158,
    -1.224,
    -1.344,
    -0.319,
    -0.525,
    -1.388,
    -1.837,
    -1.316,
    -0.597,
    -1.068,
    0.1412,
    -0.959,
    -1.479,
    -2.004,
    -0.1953,
    -1.222,
    -1.457,
    -0.768,
    -0.4158,
    -3.06,
    -1.428,
    -1.165,
    -0.226,
    -1.204,
    -1.135,
    -0.835,
    -2.46,
    -1.36,
    -1.239,
    -1.266,
    -0.8613,
    -1.226,
    -1.055,
    -1.037,
    -1.969,
    -1.564,
    -0.982,
    -1.238,
    -1.414,
    -2.246,
    -29.25,
    -1.3955,
    -1.237,
    -1.005,
]

# ╔═╡ 04185b35-7d17-47a1-91b7-39c2aa6d5316
md"Since the following exercises all build on top of each other, you are allowed to re-use code."

# ╔═╡ adcb02c4-50b9-415a-b06b-e775d4a88c28
md"### Exercise 3.1 – Mean"

# ╔═╡ 2c6a5d50-8861-47b6-adaf-8641d73e47cd
task(md"
Write a function `my_mean` that computes the mean $\mu$ of all elements in a vector:

$\mu = \frac{1}{n}\sum_{i=1}^{n} x_i$

You can reuse `my_sum`.
")

# ╔═╡ bae3ffd7-2d9a-4450-9f5e-6b7c296529d5
function my_mean(xs)
    # Write your code here!
    return missing
end

# ╔═╡ 31ac70a3-2dcc-497f-a996-81e087615b0f
if !@isdefined(my_mean)
    not_defined(:my_mean)
else
    let
        result = my_mean(test_data)
        if ismissing(result)
            still_missing()
        elseif isnothing(result)
            keep_working(md"Did you forget to write `return`?")
        elseif !(result ≈ -1.776584)
            keep_working()
        else
            correct()
        end
    end
end

# ╔═╡ 183c4510-35d5-472e-9dc3-8ee3eb5e5760
hint(md"The length of a vector can be returned using `length(xs)`.")

# ╔═╡ 71e86db6-0f51-4cca-b37e-aac59d8a5fff
md"### Exercise 3.2 – Standard deviation"

# ╔═╡ 54ccc15f-2232-403f-b6cc-503bd832eed7
task(
    md"Write a function `my_std` that computes the ([corrected](https://en.wikipedia.org/wiki/Unbiased_estimation_of_standard_deviation)) sample standard deviation $\sigma$ of all elements in a vector:

$\sigma(x) = \sqrt{\frac{1}{n-1}\sum_{i=1}^{n} \left(x_i - \mu\right)^2}$
",
    2,
)

# ╔═╡ 2af1806e-c9af-4616-a654-9b0d52a08c65
function my_std(xs)
    # Write your code here!
    return missing
end

# ╔═╡ 041fe618-588e-4fb6-b1d5-455a7d8bdf6f
if !@isdefined(my_std)
    not_defined(:my_std)
else
    let
        result = my_std(test_data)
        if ismissing(result)
            still_missing()
        elseif isnothing(result)
            keep_working(md"Did you forget to write `return`?")
        elseif result ≈ 4.019627671581536
            keep_working(md"""You implemented the "un-corrected" standard deviation.""")
        elseif !(result ≈ 4.060437120600567)
            keep_working()
        else
            correct()
        end
    end
end

# ╔═╡ d05e0303-583a-45ed-af8c-2e517b5c995b
hint(
    md"Make use the dot-syntax from exercise 1.2 to broadcast basic operators like `-` and `^`.",
)

# ╔═╡ 602e2bb4-6a35-4050-9e6d-ba7bd26ecf39
md"""### Exercise 3.3 – Standardization
Standardization takes data $X$ and returns transformed data $X'$ with mean $\mu'=0$ and standard deviation $\sigma'=1$:

$X' = \frac{X-\mu}{\sigma}$
"""

# ╔═╡ 0192e66f-48fe-4e27-962c-5d6be35e45ce
task("Implement a function `standardize(xs)` that standardizes a vector.", 2)

# ╔═╡ 5d080901-92f2-45d5-8603-3fc8e90137e0
function standardize(xs)
    # Write your code here!
    return missing
end

# ╔═╡ ac830b8f-9ca5-4a86-981f-e9953700a6b0
md"Let's check whether the transformed data has $\mu'=0$ and $\sigma'=1$.

Note that due to [rounding errors](https://en.wikipedia.org/wiki/Machine_epsilon) arising from floating point arithmetic, the results will not be exactly zero and one:
"

# ╔═╡ 089cfc54-7010-4c3b-822b-55eacd849bf9
preprocessed_data = standardize(test_data)

# ╔═╡ 6f482227-2961-44fd-9f34-7373f099e1a5
my_mean(preprocessed_data)

# ╔═╡ 77938197-8164-402a-b688-939312c7078e
my_std(preprocessed_data)

# ╔═╡ 35c913da-6883-4c83-9f6a-d12cd85bb89e
if !@isdefined(standardize)
    not_defined(:my_std)
else
    let
        result = standardize(test_data)
        if ismissing(result)
            still_missing()
        elseif isnothing(result)
            keep_working(md"Did you forget to write `return`?")
        elseif !(
            result[1:3] ≈ [-0.16904977952188419, 0.20751066325474235, -0.01906592755918599]
        )
            keep_working()
        else
            correct()
        end
    end
end

# ╔═╡ 372cae6d-ef09-46a3-af90-03f83be6c08a
md"### Exercise 3.4 – Inverse transform
There are two more things we can improve in our `standardize` function:

1. When applying standardization, the transformation $\frac{X-\mu}{\sigma}$ depends on the mean and standard deviation of the data $X$. Applying the function `standardize` to two different datasets will therefore apply two different transformations.

    This is a problem if we want to re-apply the exact same transformation computed on our training set to our testing set.

2. Additionally, we want to have an inverse of our transformation to apply to the inference results of our machine learning model. This inverse transform should implement

$X = \left(X' \cdot \sigma\right) + \mu$

Since we haven't learned how to define our own types yet (look forward to lecture 4!), we will use higher-order functions to solve this problem.
"

# ╔═╡ 0fff4cd1-8972-4aaf-85d5-6515404b8b86
task(
    "Write a function `get_transformations` that takes a data vector `data` and returns two functions:
1. A function `transform` implementing standardization with the mean and standard deviation of `data`
2. A function `inverse_transform` implementing the inverse of standardization with the mean and standard deviation of `data`
",
    2,
)

# ╔═╡ cce72fb1-b694-4b84-9cc6-e209acd398db
function get_transformations(data)
    # Write code here!

    function transform(xs)
        # Write code here!
        return xs
    end

    function inverse_transform(xs)
        # Write code here!
        return xs
    end

    return transform, inverse_transform # don't change this line
end

# ╔═╡ bdb67c9d-baae-4c58-bf30-ad8490ee8549
tf, inv_tf = get_transformations(test_data)

# ╔═╡ 9d383e80-f264-4fc4-8287-66a60d03461b
md"Let's apply the function `tf` that our function returned. Once again, we will check whether the transformed data has $\mu'=0$ and $\sigma'=1$:"

# ╔═╡ 863913f2-167f-4c39-8694-83c4947a36bd
transformed_data = tf(test_data)

# ╔═╡ df0389aa-76b8-455f-ab0b-fd58ba6656f6
my_mean(transformed_data)

# ╔═╡ db31f84e-2e10-46a0-857e-0fb9d045b9b8
my_std(transformed_data)

# ╔═╡ c0a59c0f-887e-43b6-86cc-91b4a9a00f0b
md"And let's test the inverse transformation. The following vectors should be equal:"

# ╔═╡ 5ce2da1a-c116-48e6-9ae2-a2c6f95c1ada
inv_tf(transformed_data)

# ╔═╡ 6d335fa1-5349-4eac-973b-0e570149fe7c
test_data

# ╔═╡ e21865d8-294f-47c0-b68d-7767318c6f9f
if !@isdefined(get_transformations)
    not_defined(:get_transformations)
else
    let
        train = [1, 4, 5]
        test = [2, 1, 3]
        ft, it = get_transformations(train)
        if !isa(get_transformations(train), Tuple{Function,Function})
            keep_working(md"`get_transformations` should return two functions")
        elseif !(ft(test) ≈ [-0.6405126152203485, -1.12089707663561, -0.1601281538050872])
            keep_working(md"The answer is not quite right. Keep working on `transform`.")
        elseif !(it(ft(test)) ≈ test)
            keep_working(
                md"The answer is not quite right. Keep working on `inverse_transform`."
            )
        else
            correct()
        end
    end
end

# ╔═╡ edb7814a-eddf-4c87-8857-19bb0a0c0241
md"""# Feedback
This is the fourth iteration of the *"Julia for Machine Learning"* class. Please help us make the course better!

You can write whatever you want in the following string. Feel free to add or delete whatever you want.
"""

# ╔═╡ f60be2e0-9b43-46b5-96ef-7747ab56e164
feedback = """
The homework took me around XX minutes.

In the lecture / homework I would have liked more detailed explanations on:
* foo
* bar

I liked:
* baz

I didn't like:
* qux
""";

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.3.1"
PlutoUI = "~0.7.62"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "65874a65b39702642b8f819a8904f6c2925e64f2"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

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
# ╟─4132e946-126d-43a8-85ab-c149adbbff81
# ╟─ff5d316f-806c-4652-97d8-323462395c69
# ╟─f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
# ╟─bdcb27c5-0603-49ac-b831-d78c558b31f0
# ╟─6be73c03-925c-4afa-bd66-aca90e6b49fe
# ╟─ddd6e83e-5a0d-4ff0-afe4-dedfc860994c
# ╟─8ece9aea-20f5-41db-95ca-08c8d4d2d4c1
# ╠═d03e4e95-faab-4ab3-ab27-81189cbd8231
# ╟─44ec9e94-f6af-431e-8841-bae44431dfa3
# ╟─06c0ad65-22d4-4c8e-ae19-4f05ba125e79
# ╠═755b8685-0711-48a2-a3eb-f80af39f10e1
# ╟─5061a130-fc0a-4306-bdf5-6966e8de938a
# ╟─74e27f45-9897-4ddd-8516-59669b17b1ad
# ╟─d358da52-ee09-4533-a2ef-c68b847e24d5
# ╟─e5670193-6221-49c6-a880-d287f717545e
# ╠═b96fde59-1f2a-4d07-a5cc-6ec48e5079f1
# ╠═12faf3e9-4380-430c-aedf-25380558b09a
# ╠═9d20c79d-4f97-4a39-ac1a-eed311a6149a
# ╠═d9a237b0-c112-4ee2-9232-725ce97679dc
# ╠═b8e741c9-feff-4017-a037-0fbd9cd4f49a
# ╟─2001c0fb-e4cd-49d6-b305-429c0597bad2
# ╟─cb395709-4237-488d-a294-7cb6e294c724
# ╟─2ee7ce83-a828-4468-9daf-7cdbf657e52e
# ╠═c84be3a2-73a9-42f1-bf6b-3fbf64258cf5
# ╠═a11ccc2b-3c5b-493a-8e8b-8b46b44bd3a4
# ╟─6a1c553d-66ef-42da-83ad-5b46a7e4c58b
# ╠═6eaffea6-099d-441e-b54b-f08bc9b478c7
# ╠═a87612a8-62dd-44d4-89c4-c712870b00c3
# ╠═da70e426-ea78-4969-9402-efffd5576238
# ╟─35f59a25-0ab4-4c18-82c8-466fdeeb3471
# ╟─56fc8e66-852d-4653-ad4c-2f5ecd0be769
# ╟─23174858-aa5f-42bf-ac1c-56ee88d87f7f
# ╠═7d098a0b-1a11-4225-b044-82d29f05ad05
# ╠═f190cbbb-24e7-4c83-b7fb-9477ccdb5023
# ╟─a4b05061-e48e-4dbb-aa1c-df242c5b2785
# ╟─077a73ca-b401-40ef-abae-ea87f78436a3
# ╟─5c6660ae-8b04-49ef-b4a7-df47b9e71f67
# ╟─dabfa315-fa26-4056-8b19-eaab8322db82
# ╠═49e6ab33-9452-4dc1-ac59-d47e70c325a5
# ╟─ffbd5d8c-86f9-4c5d-9d9c-1d1a0083a439
# ╠═12fe4d4b-3f2f-4d26-b4f7-b8e83605c7e8
# ╠═6edb4abb-02ae-4d18-8cdb-6a47586584a2
# ╟─712c7e22-f144-4da0-9a6a-37d5a9006336
# ╟─60b79139-13d1-4945-9c50-66b0304e7e75
# ╟─3039f9f1-9077-4050-b0d6-c404612d2e38
# ╠═f54461c4-392c-4a83-933c-d30a41ce4e0e
# ╟─bcb0ff95-f769-46f3-abf3-d5807107413b
# ╠═de7f59f0-17b5-41a0-be32-cbaad14d777e
# ╟─6d988869-35f6-4771-9002-b8b32560e1cc
# ╟─d0377938-ca4b-4186-b708-b31a23e23807
# ╟─2b4dac4c-e710-407d-aa78-4ed181748cf8
# ╠═af9b11ed-bb17-4ff3-a8f8-057f4777e5f9
# ╟─b74c95c2-db7a-4a72-b7c6-3e6644d90158
# ╠═20283e2f-9c00-43d2-bafd-1044ef520248
# ╠═2011a382-c148-4b7b-a78d-d2813c0d4fcf
# ╟─b5711f19-cd31-46b1-92c1-f51480c9065a
# ╟─16fdaf27-8345-436d-911c-ef09e9bb48e8
# ╟─2f483635-5080-48c6-b961-9dbc916268a4
# ╟─04185b35-7d17-47a1-91b7-39c2aa6d5316
# ╟─adcb02c4-50b9-415a-b06b-e775d4a88c28
# ╟─2c6a5d50-8861-47b6-adaf-8641d73e47cd
# ╠═bae3ffd7-2d9a-4450-9f5e-6b7c296529d5
# ╟─31ac70a3-2dcc-497f-a996-81e087615b0f
# ╟─183c4510-35d5-472e-9dc3-8ee3eb5e5760
# ╟─71e86db6-0f51-4cca-b37e-aac59d8a5fff
# ╟─54ccc15f-2232-403f-b6cc-503bd832eed7
# ╠═2af1806e-c9af-4616-a654-9b0d52a08c65
# ╟─041fe618-588e-4fb6-b1d5-455a7d8bdf6f
# ╟─d05e0303-583a-45ed-af8c-2e517b5c995b
# ╟─602e2bb4-6a35-4050-9e6d-ba7bd26ecf39
# ╟─0192e66f-48fe-4e27-962c-5d6be35e45ce
# ╠═5d080901-92f2-45d5-8603-3fc8e90137e0
# ╟─ac830b8f-9ca5-4a86-981f-e9953700a6b0
# ╠═089cfc54-7010-4c3b-822b-55eacd849bf9
# ╠═6f482227-2961-44fd-9f34-7373f099e1a5
# ╠═77938197-8164-402a-b688-939312c7078e
# ╟─35c913da-6883-4c83-9f6a-d12cd85bb89e
# ╟─372cae6d-ef09-46a3-af90-03f83be6c08a
# ╟─0fff4cd1-8972-4aaf-85d5-6515404b8b86
# ╠═cce72fb1-b694-4b84-9cc6-e209acd398db
# ╠═bdb67c9d-baae-4c58-bf30-ad8490ee8549
# ╟─9d383e80-f264-4fc4-8287-66a60d03461b
# ╠═863913f2-167f-4c39-8694-83c4947a36bd
# ╠═df0389aa-76b8-455f-ab0b-fd58ba6656f6
# ╠═db31f84e-2e10-46a0-857e-0fb9d045b9b8
# ╟─c0a59c0f-887e-43b6-86cc-91b4a9a00f0b
# ╠═5ce2da1a-c116-48e6-9ae2-a2c6f95c1ada
# ╠═6d335fa1-5349-4eac-973b-0e570149fe7c
# ╟─e21865d8-294f-47c0-b68d-7767318c6f9f
# ╟─edb7814a-eddf-4c87-8857-19bb0a0c0241
# ╠═f60be2e0-9b43-46b5-96ef-7747ab56e164
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
