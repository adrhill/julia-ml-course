### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 755b8685-0711-48a2-a3eb-f80af39f10e1
begin
    using PlutoUI
    using PlutoTeachingTools

    using LinearAlgebra
    using Statistics
    using Distributions
    using BenchmarkTools

    using Images
    using ImageMagick
    using TestImages

    using LaTeXStrings
    using Plots
end

# ╔═╡ f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
html"""
	<h1 style="text-align:left">
		Julia programming for ML
	</h1>
	<div style="text-align:left">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Homework 2: Indexing & Linear Algebra
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Winter Semester 23/24<br>
		</p>
	</div>
"""

# ╔═╡ bdcb27c5-0603-49ac-b831-d78c558b31f0
md"Due date: **Monday, December 4th 2023 at 23:59**"

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
task("Please add your student information to the cell below.", 0)

# ╔═╡ 74e27f45-9897-4ddd-8516-59669b17b1ad
PlutoTeachingTools.default_language[] = PlutoTeachingTools.PTTEnglish.EnglishUS();

# ╔═╡ d358da52-ee09-4533-a2ef-c68b847e24d5
md"## Exercise 1: Warm up
### Exercise 1.1 – Indexing vectors"

# ╔═╡ e5670193-6221-49c6-a880-d287f717545e
task(
    "Strings can be indexed just like numerical arrays. Use indexing to return specific characters from the string `hello`.",
    0,
)

# ╔═╡ a4bb8383-1238-411e-b697-ed258d3c0c6d
hello = "Hello World!"

# ╔═╡ cb871521-e3d8-4b87-a474-b45b5c8167a9
second_letter = missing # second character in `hello_world`

# ╔═╡ 5e70263e-6512-40ef-ad0a-38287dfba684
if !@isdefined(second_letter)
    not_defined(:second_letter)
else
    if ismissing(second_letter)
        still_missing()
    elseif second_letter != 'e'
        keep_working()
    else
        correct()
    end
end

# ╔═╡ 11df83bc-cb8e-4782-89f4-8abb73803621
first_five = missing # first five characters in `hello_world`

# ╔═╡ b3d54500-daab-4360-943d-30997c90aa02
if !@isdefined(first_five)
    not_defined(:first_five)
else
    if ismissing(first_five)
        still_missing()
    elseif first_five != "Hello"
        keep_working()
    else
        correct()
    end
end

# ╔═╡ fed6823a-bd16-4efd-804c-58dd5a2339ef
last_six = missing # last six characters in `hello_world`

# ╔═╡ e6db1935-af93-4850-acfe-92cec4de4fed
hint(md"Try to make use of `end`.")

# ╔═╡ 17f681ef-f30f-41fa-af34-7f331d359518
if !@isdefined(last_six)
    not_defined(:last_six)
else
    if ismissing(last_six)
        still_missing()
    elseif last_six != "World!"
        keep_working()
    else
        correct()
    end
end

# ╔═╡ 7d81c2cb-5ce2-4a25-96f4-66688863bb54
seven_to_eleven = missing # seventh to eleventh characters in `hello_world`

# ╔═╡ 7adeed1a-70d7-45c4-99e1-9be23bbbeb86
if !@isdefined(seven_to_eleven)
    not_defined(:seven_to_eleven)
else
    if ismissing(seven_to_eleven)
        still_missing()
    elseif seven_to_eleven != "World"
        keep_working()
    else
        correct()
    end
end

# ╔═╡ 0af1c0ee-9739-41be-833e-20b838d3e502
md"### Exercise 1.2 – Indexing matrices
In this exercise, we will be indexing values in an image:
"

# ╔═╡ 09cf939d-88df-4c7e-b164-67bfa431aaa7
img = testimage("mandril_gray")

# ╔═╡ 337eeee7-d39a-4a0e-9988-3e8830ae3989
md"Images in Julia are just matrices of colors, e.g. `Matrix{Gray}` or `Matrix{RGB}`:"

# ╔═╡ 23676fde-e080-4e78-9c22-a2f05178f0c1
typeof(img)

# ╔═╡ 85717691-5103-4c6f-bf6f-f56bbdb67b43
eltype(img)

# ╔═╡ 542df6a2-5e73-4eff-af6e-353e39861c6c
md"This image is of size $(size(img)):"

# ╔═╡ bb555bee-b9d5-4b6e-95c2-2793c3a2820b
size(img)

# ╔═╡ effd9509-4ad7-4d1f-96a5-dd9b32b09daa
md"We can crop an image by indexing it:"

# ╔═╡ 110bb376-57b6-4957-8e99-b8f564090fc1
img[1:100, 1:200]

# ╔═╡ d6dabb0b-c6bc-4581-bb20-5dc598f5d323
task(
    "Write a function `my_crop` that takes an image and returns the right half of it:
```
┌───────┐   ┌───┬───┐               ┌───┐
│       │   │   │   │  crop_right   │   │
│ Image │ = │ L │ R │ ────────────► │ R │
│       │   │   │   │               │   │
└───────┘   └───┴───┘               └───┘

```
If the image contains an uneven number of columns, ignore the center column.
For example, applying `my_crop` to an input matrix 
```julia
3×5 Matrix{Int64}:
 1  4  7  10  13
 2  5  8  11  14
 3  6  9  12  15
```
should return
```julia
3×2 Matrix{Int64}:
 10  13
 11  14
 12  15
```
You can assume that the image is a regular Matrix using 1-based indexing.
",
    2,
)

# ╔═╡ 15fe42c4-9262-4673-b1b8-f417de0271d9
function my_crop(img)
    return missing # Replace `missing` with your code
end

# ╔═╡ 9f137e55-ff39-4b95-b501-78921c27f4db
md"Don't forget that you can add cells with your own tests here!"

# ╔═╡ 4c3b1036-f530-43de-83e2-91ef962a86d6
my_crop([1 2 3 4; 5 6 7 8])

# ╔═╡ 377fa7fd-f4a0-46a3-9511-d52155981cb9
if !@isdefined(my_crop)
    not_defined(:my_crop)
else
    let
        mat1 = [1 5 9 13; 2 6 10 14; 3 7 11 15; 4 8 12 16]
        mat2 = [1 4 7 10 13; 2 5 8 11 14; 3 6 9 12 15]
        result1 = my_crop(mat1)
        result2 = my_crop(mat2)

        if ismissing(result1)
            still_missing()
        elseif isnothing(result1)
            keep_working(md"Did you forget to write `return`?")
        elseif ismissing(result2)
            still_missing()
        elseif result1 != [9 13; 10 14; 11 15; 12 16]
            keep_working()
        elseif result2 != [10 13; 11 14; 12 15]
            keep_working(
                md"For matrices with an uneven amount of columns, ignore the center column."
            )
        else
            correct()
        end
    end
end

# ╔═╡ 7f8b9940-9ebf-4d93-a76c-1e055c733122
hint(md"`size` returns a tuple, which can be deconstructed using `h, w = size(img)`.

 You then need to compute the index of the center column. Several approaches are possible:
 - use `iseven` and an if-else statement or ternary operator
 - use `ceil(Int, x)`

 Also try returning a `@view`!")

# ╔═╡ d5ebd2a3-8067-479c-bd9d-6e9c7c55972e
my_crop(img)

# ╔═╡ 3e933ccb-a6f3-4c2c-99ae-7ff03ed3a786
md"## Exercise 2: Singular value decomposition
The [Singular value decomposition](https://en.wikipedia.org/wiki/Singular_value_decomposition) (SVD) factorizes matrices $M$ into 

$M = U \Sigma V' \quad .$

LinearAlgebra.jl implements SVD in the function `svd`. For this implementation of SVD:  
*  $\Sigma$ is a vector of  sorted, non-negative real numbers, the [singular values](https://en.wikipedia.org/wiki/Singular_value)
*  $U$ is a unitary matrix
*  $V$ is a unitary matrix 
*  $V'$ is the adjoint / conjugate transpose of $V$
"

# ╔═╡ 8d144b90-32de-4367-86aa-89dd897c66d5
M = rand(4, 3)

# ╔═╡ 57a9a2a7-06cd-4d55-b7fd-2f6d86f938a7
U, Σ, V = svd(M)

# ╔═╡ afc54444-091c-4d06-95d3-dc7f0cb127b5
U * Diagonal(Σ) * V' ≈ M

# ╔═╡ 61895459-48df-419f-b884-5cb51e1038e9
U' * U ≈ I # U is unitary

# ╔═╡ c467be45-d8ef-4f68-9794-0ee9f15acf5f
V' * V ≈ I # V is unitary

# ╔═╡ 5858a0b8-6ead-4f26-b7be-ec684bd4602d
md"### Exercise 2.1: Low-rank approximation"

# ╔═╡ 49c75eed-d1cc-47e0-884b-8c327f638250
task(
    md"Write a function `rank_n_approx` that uses SVD to compute a rank $n$ approximation $\tilde{A}$ of the input matrix $A$.

For this purpose:
1. Compute $U$, $\Sigma$ and $V$ from $A$
2. In $\Sigma$, set all singular values after the $n$-th entry to zero. We will call this $\tilde{\Sigma}.$
3. Return $\tilde{A} = U \tilde{\Sigma} V'$
",
    2,
)

# ╔═╡ ec262620-a818-4f5c-b6b9-24a58b73a603
function rank_n_approx(A, n)
    return missing # Replace `missing` with your code
end

# ╔═╡ 81a85548-ccf0-4d09-9cdf-f6eefc08017a
md"Let's see if the function works:"

# ╔═╡ 8789e280-9d06-4284-8f43-42824e06bb20
T = rand(-9:9, 5, 5)

# ╔═╡ 3fe28b4d-4a7a-4ea9-9b60-7a50c8f6b1e3
T̃ = rank_n_approx(T, 1)

# ╔═╡ 6112c7eb-b2fb-4f46-8601-bc5787577042
rank(T)

# ╔═╡ bcb516cd-6bee-4cd8-b633-a872a2bc107f
rank(T̃)

# ╔═╡ 0585d514-9255-49c5-bf57-c408c71600c7
if !@isdefined(rank_n_approx)
    not_defined(:rank_n_approx)
else
    let
        T = [1 2 3; 1 2 2; 1 1 1]
        sol = [
            0.9403007439221942 2.074443754686133 2.9668694123600576
            1.1341430107639383 1.8327264015961187 2.074443754686132
            0.8924256576739248 1.1341430107639388 0.9403007439221938
        ]
        result = rank_n_approx(T, 2)

        if ismissing(result)
            still_missing()
        elseif isnothing(result)
            keep_working(md"Did you forget to write `return`?")
        elseif !(result ≈ sol)
            keep_working()
        else
            correct()
        end
    end
end

# ╔═╡ ef2c3f94-5db0-4a49-8bb2-cd2380e6fd82
hint(
    md"You can set values in an array to zero by using the `.=` operator, which will broadcast assignments.",
)

# ╔═╡ 7e4268d1-54d9-429b-9ec2-c2ccab5a7eda
@bind n Slider(1:50, default=50, show_value=true)

# ╔═╡ 8401a066-f5c0-4d86-8d0e-e9c287762252
md"Note that from a numerical perspective, it is a bit unusual to multiply the factorization $U \tilde{\Sigma} V'$ back together into an array $\tilde{A}$. We did this so we can apply the low-rank approximation to our image. 

Let's compute a rank $n=$ $(n) approximation. Adjust the rank using the following slider:"

# ╔═╡ f597829c-b0c7-4b7f-b58b-bac8e52030f5
rank_n_approx(img, n) .|> Gray

# ╔═╡ 5bba64bc-1dd1-4a71-bfe0-86497c31d617
md"## Exercise 3: Kernel Ridge Regression
Given the dataset $(X, y)$, we want to apply Kernel ridge regression to predict $\hat{y}$ for unknown $x$.
"

# ╔═╡ f1846dfe-0718-49f9-9825-84256a871ac7
X = [0.004, 0.018, 0.083, 0.276, 0.325, 0.610, 0.667, 0.698, 0.877, 0.951]

# ╔═╡ a72971ae-b1de-4892-85d2-52cb8ff025ff
y = [0.003, 0.094, 0.444, 0.905, 0.820, -0.474, -0.883, -0.931, -0.616, -0.269]

# ╔═╡ dcba5dbb-1a3d-49e8-a301-68c6bcae13b7
md"Let's visualize the data we are given in a scatter plot:"

# ╔═╡ 87236fbd-e09c-4b81-b065-5954b2057b9b
scatter(X, y; label="Data", xlabel=L"x", ylabel=L"y")

# ╔═╡ 4e1f60e5-77c1-467a-9500-69c00f74700c
md"### Exercise 3.1 – Kernel function"

# ╔═╡ ef23ba30-3f81-4676-850f-1a65062753a6
task(
    md"Define a function `rbf` that evaluates the [radial basis function kernel](https://en.wikipedia.org/wiki/Radial_basis_function_kernel) (RBF kernel) $k$ on two data points $x_i$, $x_j$:

$k(x_i, x_j) = \exp\left(-\frac{||x_i - x_j|| ^2}{2\sigma^2}\right)$
",
)

# ╔═╡ 7f9afd24-fd1c-49cd-b6bf-598cea9758c7
md"Note that you can type σ using `\sigma<TAB>`. 

`σ`'s default value `σ_slider` is defined at the bottom of this notebook."

# ╔═╡ 3e0b27fc-1ccb-440b-a98f-ee6541f3282e
md"### Exercise 3.2 – Training kernel matrix $K_{XX}$"

# ╔═╡ e2a37317-171d-4c45-975e-2752daf88008
task(md"Use broadcasting to compute the training kernel matrix `kXX`, defined as

$K_{XX} = \begin{bmatrix}
    k(x_1, x_1) & \cdots & k(x_1, x_n) \\
    \vdots 		& \ddots & \vdots \\
    k(x_n, x_1) & \cdots & k(x_n, x_n)
\end{bmatrix} \in \mathbb{R}^{n \times n}$

where $x_i$ is the $i$-th entry in the dataset $X$ and $k$ is the kernel function.
Use the RBF kernel with $\sigma=0.5$.")

# ╔═╡ 45d51447-beb8-4682-8b09-f65de7cfb95a
kXX = missing # Replace `missing` with your code

# ╔═╡ 776d80f1-ea26-4aeb-8bd5-c230956fa724
md"Since kernel functions $k$ are symmetric and positive-definite, this should also apply to the matrix $K$:"

# ╔═╡ 5774bd94-3c87-48b5-868e-73418afbb5c7
issymmetric(kXX)

# ╔═╡ 23227a0e-413a-4e05-9bf2-109a499b12cb
isposdef(kXX)

# ╔═╡ 5eea7d2e-cfda-4b42-9697-31ef645a1a79
if !@isdefined(kXX)
    not_defined(:kXX)
else
    if ismissing(kXX)
        still_missing()
    elseif isnothing(kXX)
        keep_working(md"`kXX` is `nothing`.")
    elseif typeof(kXX) != Matrix{Float64}
        keep_working(md"`kXX` should be of type `Matrix{Float64}`.")
    elseif size(kXX) != (10, 10)
        keep_working(md"`kXX` should be of size (10, 10), got $(size(kXX)).")
    elseif !issymmetric(kXX)
        keep_working(md"`kXX` should be a symmetric matrix.")
    elseif !isposdef(kXX)
        keep_working(md"`kXX` should be a positive-definite matrix.")
    elseif !(sum(kXX) ≈ 70.69205369179959)
        keep_working(md"Did you use $\sigma=0.5$?")
    else
        correct()
    end
end

# ╔═╡ ce97f41f-8b71-468f-bac3-39a66e440cd5
hint(md"There are several viable approaches:
* broadcast the RBF kernel over `X` and `X'`
* use a multi-dimensional comprehension
* pre-allocate a matrix and write into it using for-loops
")

# ╔═╡ 45d61914-591c-48bb-a0ad-902028d61089
md"### Exercise 3.3 – Test kernel matrix $K_{\hat{x}X}$"

# ╔═╡ cecb430c-0236-4a16-b74f-1809710fbdfe
task(
    md"Compute `kxX`, defined as

$K_{\hat{x}X} = \begin{bmatrix}
    k(\hat{x}, x_1) & \cdots & k(\hat{x}, x_n)
\end{bmatrix} \in \mathbb{R}^{1 \times n}$

where $x_i$ is the $i$-th entry in the dataset $X$. Use $\hat{x}=0.8$ and the RBF kernel with $\sigma=0.5$.
",
)

# ╔═╡ f9906c93-f96d-45fd-b0ae-48794d82d54e
kxX = missing # Replace `missing` with your code

# ╔═╡ 58dd630a-ed1b-471a-94a3-fea43ec41d19
if !@isdefined(kxX)
    not_defined(:kxX)
else
    if ismissing(kxX)
        still_missing()
    elseif isnothing(kxX)
        keep_working(md"`kxX` is `nothing`.")
    elseif size(kxX) != (1, 10)
        keep_working(md"`kxX` should be of size (1, 10), got $(size(kxX)).")
    elseif !(sum(kxX) ≈ 6.966497082632841)
        keep_working(md"Did you use $\hat{x}=0.8$ and $\sigma=0.5$?")
    else
        correct()
    end
end

# ╔═╡ de0a1efb-77ae-45bd-83a5-77029e2b095d
hint(md"There are several viable approaches:
* broadcast over `x = 0.8` and `X'`
* use a comprehension
* pre-allocate a matrix and write into it in a for-loop
")

# ╔═╡ 60ebcfda-f28f-4aae-b1af-8e2a2313b3da
md"""### Interlude: Cholesky decomposition

As we've seen above, systems of equations involving **symmetric and positive-definite** matrices $A$ often arise in classic machine learning algorithms.

Using the Cholesky decomposition, a symmetric positive-definite matrix $A$ can be factorized into the product of a lower triangular matrix $L$ and its conjugate transpose:

$A = LL'$

Let's apply the Cholesky decomposition to a toy example.
By calling LinearAlgebra.jl's `cholesky`, we obtain a factorization `C`:
"""

# ╔═╡ aec673aa-fd15-46d6-85eb-4db54babfea8
A = [42 -37  52  25; -37  89 -89 -32; 52 -89 172 -22; 25 -32 -22  66]

# ╔═╡ 32d3a10a-bc5c-44a6-950c-8928936cd808
issymmetric(A) && isposdef(A)

# ╔═╡ 46ca52b7-3ec7-4c97-8a1e-0fadda4fc883
C = cholesky(A) # returns factorization

# ╔═╡ cf9d05d8-791a-4280-a160-d17992c25146
md"We can use this factorization to access $L$ and check whether $A = LL'$ holds:"

# ╔═╡ fc2d0d0b-a790-465b-93a6-0cf0c533b070
C.L

# ╔═╡ c2b1e609-8839-4788-8173-ede22c6dff19
C.L * C.L' ≈ A  # works!

# ╔═╡ 01053f0e-adcb-4fae-9f6b-9709056bb5a2
md"#### Solving linear systems
In the next exercise, we are going to use the Cholesky decomposition to solve a system of linear equations $Ax=b$ for $x$:

$x = A^{-1}b$

Let's compare three approaches on a random vector $b$:
"

# ╔═╡ 0bc1537f-dc1b-46a8-a270-4decee040e9a
b = rand(4)

# ╔═╡ 8d8657ee-17c3-4b31-a28e-f6eca4e98b83
inv(A) * b # Approach A: naive implementation using matrix inverse (never do this!)

# ╔═╡ 468d3484-b2c9-42e6-a9e4-753c3e4a57ac
A \ b # Approach B: left division operator

# ╔═╡ c4491060-fd42-4045-a8a6-8a2e6437984a
C \ b # Approach C: left division operator and Cholesky factorization

# ╔═╡ cb3a2a70-7a4c-4adb-9983-95614645971b
md"In this example, all three approaches compute the correct result. However, matrix inversion is often numerically unstable, which is why it should be avoided. 

The approach using the Cholesky factorization is numerically stable, fast and therefore well suited for the next exercise:"

# ╔═╡ 7d1a176a-5b5c-4ccb-b8d4-3ff8c9370776
@benchmark inv(A) * b  # slowest and unstable, never do this!

# ╔═╡ cb5a04e5-848d-4974-9667-73ab80d4a54b
@benchmark A \ b  # slow

# ╔═╡ 87459e6f-f147-44bb-a713-b75d0d2702e0
@benchmark C \ b # fast

# ╔═╡ b5937641-83df-4e64-b51f-84c988a1f9f5
md"### Exercise 3.4 – Kernel Ridge Regression"

# ╔═╡ 57829229-6fe8-4f30-bb10-49d763316864
task(
    md"Implement Kernel Ridge Regression in the function `kernel_ridge` below.

##### Step 1
Inside the function `kernel_ridge`, construct the training kernel matrix $K_{XX}$ using the function `kernel`. Add a regularization term $\lambda I$, where where $I$ is the identity matrix and $\lambda \in \mathbb{R}$ is a regularization term: 

$\tilde{K}_{XX} = K_{XX} + \lambda I$

Don't specify the kernel bandwidth $\sigma$.

##### Step 2
Use the Cholesky decomposition on $\tilde{K}_{XX}$ to compute 

$\alpha = (K_{XX} + \lambda I)^{-1}y \quad .$


##### Step 3
Inside the `kernel_ridge` function, write a prediction function `predict` that takes a point $x$, computes the test kernel matrix $K_{\hat{x}X}$ and returns a prediction

$\hat{y} = K_{\hat{x}X} \cdot \alpha \quad .$

",
    3,
)

# ╔═╡ 5561d5fa-74fa-430f-850b-8339ad3df433
md"### Interactive plot"

# ╔═╡ 272aeadc-773e-41a7-a112-80e814e4ac3d
@bind σ_slider Slider(0.01:0.01:1, default=1.0, show_value=true)

# ╔═╡ 74d0409d-8a10-4660-8a01-c75505f612e2
function rbf(xi, xj; σ=σ_slider) # Don't change this line
    return missing # Replace `missing` with your code
end

# ╔═╡ 05032f1b-ca1e-4fb0-ae21-060c06146871
if !@isdefined(rbf)
    not_defined(:rbf)
else
    let
        result1 = rbf(0.12, 0.32; σ=1.0)
        result2 = rbf(0.12, 0.32; σ=0.3)
        if ismissing(result1)
            still_missing()
        elseif isnothing(result1)
            keep_working(md"Did you forget to write `return`?")
        elseif !(result1 ≈ 0.9801986733067553)
            keep_working()
        elseif !(result2 ≈ 0.8007374029168081)
            keep_working(md"Did you forget $\sigma^2$?")
        else
            correct()
        end
    end
end

# ╔═╡ b5d7850d-dac2-482e-b0bc-273660d0646a
function kernel_ridge(X, y; kernel=rbf, λ=1e-8)  # Don't change this line
    # Write your code here

    function predict(xtest::Real)
        return missing # Replace `missing` with your code
    end

    return predict # Don't change this line
end

# ╔═╡ ea43cd35-b7f8-46e0-befb-d9b0248e0eb3
if !@isdefined(kernel_ridge)
    not_defined(:kernel_ridge)
else
    let
        k(x1, x2) = rbf(x1, x2; σ=0.2)
        pred = kernel_ridge(X, y; kernel=k, λ=10^8)
        result = pred(0.2)

        if ismissing(result)
            still_missing()
        elseif isnothing(result)
            keep_working(md"Did you forget to write `return`?")
        elseif result isa AbstractArray
            keep_working(
                md"""
The `predict` function should return a scalar prediction $\hat{y}$ for scalar inputs $\hat{x}$. 
Currently, an array of size $(size(result)) is returned.

If the size is (1,) or (1, 1), you can use the function `only` on your output to access the only element in it. Alternatively, use the dot product.
""",
            )
        elseif !(result ≈ 1.7946744507800904e-8)
            keep_working()
        else
            correct()
        end
    end
end

# ╔═╡ 725c19e3-2659-4f2d-8442-2bbc6010661b
md"""If you successfully implemented Kernel ridge regression, you can use the following sliders to interact with the RBF kernel bandwidth $\sigma=$ $(σ_slider)"""

# ╔═╡ 31056ca3-acd2-4457-bbd3-9ddd2c2ff641
@bind ex Slider(-10.0:2.0, default=-8, show_value=true)

# ╔═╡ 027c7870-1603-4aba-95eb-3d14b7a0829f
md"""and the exponent `ex` of the regularization term $\lambda =$ $(10^ex)"""

# ╔═╡ 2f57e6de-c874-4f90-8e71-70cd1d002359
predict = kernel_ridge(X, y; λ=10^ex);

# ╔═╡ 2000a153-4b4d-4aec-a503-eaf3cc9d89c3
begin
    p = scatter(X, y; label="Dataset", xlabel=L"x", ylabel=L"y", ylims=(-1, 1))
    plot!(p, predict, -0.1, 1.1; label="Prediction", title="Kernel ridge regression")
end

# ╔═╡ 0fe33d6c-d65d-4f29-857d-34ea792a1f48
md"How does a high/low bandwidth affect the prediction? How does regularization affect it?

You can also implement [more kernel functions](https://en.wikipedia.org/wiki/Positive-definite_kernel#Examples_of_p.d._kernels) and pass them to the `kernel_ridge` keyword-argument `kernel` to see how the prediction changes.
"

# ╔═╡ 41a7bd3b-56f5-45e7-ac8d-313bb3a46181
md"## Exercise 4: Principal Component Analysis
### Overview
Assume an input dataset $$X = [x_1, x_2, \ldots x_n] \in \mathbb{R}^{d\times n}$$, where
*  $d$ is the dimensionality of each data point: $x_i \in \mathbb{R}^d$
*  $n$ is the number of data points in $X$

Substracting the mean over all data points gives us the *mean-centered* data matrix $\hat{X}$.
	
**Idea:** PCA with $k$ principal components finds the projection $W_k = [w_1, w_2, \ldots, w_k]$ that maximizes the variance in the projected data $W_k^T\hat{X}$. 
	
![PCA Plot](https://i.imgur.com/FEyXwwX.png)

In the example above, this maximization of variance would correspond to a projection $W_1^T\hat{X} = w_1^T\hat{X}$ of all datapoints onto the red arrow, reducing the dimensionality from 2D to 1D. 
"

# ╔═╡ 067c7894-2e3f-43de-998f-4f1a250bc0f7
Markdown.MD(
    Markdown.Admonition(
        "warning",
        "Note",
        [
            md"This exercise does not provide automated feedback in order to get you to practice programming in Julia on your own!",
        ],
    ),
)

# ╔═╡ 4a9735f7-0d2b-4557-a293-f0e0c6c19179
md"### Exercise 4.1 – Implementation"

# ╔═╡ af5e47f0-010b-4e69-bed3-95fdf9fce3fe
task(
    md"Implement [Principal Component Analysis](https://en.wikipedia.org/wiki/Principal_component_analysis) (PCA) in the function `pca` below.

##### Step 1
Calculate the mean-centered data matrix $\hat{X}=[\hat{x}_1, \hat{x}_2, \ldots, \hat{x}_n]$ such that

$\hat{x}_i = x_i - \mu_x \quad ,$

where $\mu_x$ is the sample mean vector of the data $X$.
You can use the `mean` function for this purpose.

##### Step 2
Compute the sample covariance matrix $C = \hat{X}\hat{X}^T$.

##### Step 3
Compute an eigendecomposition of $C$ into eigenvectors $w_i$ and eigenvalues $\lambda_i$
using the function `eigen`. 

	
Select the eigenvectors $w_i$ corresponding to the $k$ largest eigenvalues $\lambda_i$,
such that $\lambda_1\ge\lambda_2\ge\ldots\ge\lambda_k$:

$W_k = [w_1, w_2, \ldots, w_k]$

##### Step 4
Calculate the projection $H = W_k^T \hat{X}$ of the mean-centered data $\hat{X}$ onto $W_k$.
",
    4,
)

# ╔═╡ 216dcbf9-91aa-40fe-bef2-6dea56a35be7
function pca(X, k=2)  # Don't change this line
    # Write your code here

    return Wk, H # Don't change this line
end

# ╔═╡ dda486b4-5838-429b-aec8-450d2f0c55be
hint(
    md"""
* The `mean` function allows you to compute the mean along an axis of an array. Refer to the documentation for examples.
* Read the documentation of `eigen` thoroughly. Eigenvectors are sorted by *increasing* eigenvalues. You can make use of clever indexing to obtain them in decreasing order.
* Accessing docstrings is described in the lecture *"Getting Help"*.
""",
)

# ╔═╡ df1540c4-d458-428c-b230-6c42557557e1
md"### Exercise 4.2 – Visualization"

# ╔═╡ a60e422c-e4e2-42d2-b490-54f3123aa11a
task(
    md"
Try to replicate the following plot as on the dataset `X_test` as close as you can.
	
![PCA Plot](https://i.imgur.com/FEyXwwX.png)


The plot doesn't have to be identical, but it should:
* visualize the sample mean $\mu_X$
* visualize the directions of the principal components $w_1$ and $w_2$ in $W_k$
* add axis labels
* add a legend
",
    2,
)

# ╔═╡ f3d0483f-ba78-4d3d-a23e-ec051923175d
n_samples = 100

# ╔═╡ 6bbaa57a-0b06-452c-8196-d204fe07beb9
hint(md"The principal components $w_1$ and $w_2$ need to be plotted starting from $\mu_x$.")

# ╔═╡ 4639b31c-9ef9-47a8-b9a9-b65b2e6d13fa
my_distribution = MixtureModel(
    [MvNormal([0.0, 10.0], [3.0 2.0; 2.0 3.0]), MvNormal([15.0, 20.0], [7.0 0.3; 0.3 4.0])],
    [0.5, 0.5],
);

# ╔═╡ 474cd2c3-b35b-4d01-b62a-e7171b4ee476
X_test = rand(my_distribution, n_samples)

# ╔═╡ 6fd61dac-2ab1-464a-a20c-c0e1d7d23e8b
begin
    # Plot dataset
    scatter(X_test[1, :], X_test[2, :]; ratio=1)

    # TODO: Plot principal components here!
end

# ╔═╡ edb7814a-eddf-4c87-8857-19bb0a0c0241
md"""# Feedback
This is the second iteration of the *"Julia programming for ML"* class. Please help us make the course better!

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
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
ImageMagick = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
TestImages = "5e47fb64-e119-507b-a336-dd2b206d9990"

[compat]
BenchmarkTools = "~1.3.2"
Distributions = "~0.25.103"
ImageMagick = "~1.3.0"
Images = "~0.25.2"
LaTeXStrings = "~1.3.1"
Plots = "~1.38.11"
PlutoTeachingTools = "~0.2.8"
PlutoUI = "~0.7.50"
TestImages = "~1.8.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "e64675d6583c1b41059fd140be0f12099763568d"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "02f731463748db57cc2ebfbd9fbc9ce8280d3433"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e0af648f0692ec1691b5d094b8724ba1346281cf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.18.0"

[[deps.ChangesOfVariables]]
deps = ["InverseFunctions", "LinearAlgebra", "Test"]
git-tree-sha1 = "2fba81a302a7be671aefe194f0525ef231104e7f"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.8"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "05f9816a77231b07e634ab8715ba50e5249d6f76"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.5"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5225c965635d8c21168e32a12954675e7bea1151"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.10"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "a6c00f894f24460379cb7136633cef54ac9f6f4a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.103"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "b4fbdd20c889804969571cc589900803edda16b7"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.7.1"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "35f0c0f345bff2c6d636f95fdb136323b5a796ef"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.7.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8e2d86e06ceb4580110d9e716be26658effc5bfd"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.8"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "da121cbdc95b065da07fbb93638367737969693f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.8+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "899050ace26649433ef1af25bc17a815b3db52b7"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.9.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "3447781d4c80dbe6d71d239f7cfb1f8049d4c84f"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.6"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "bca20b2f5d00c4fbc192c3212da8fa79f4688009"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.7"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils"]
git-tree-sha1 = "b0b765ff0b4c3ee20ce6740d843be8dfce48487c"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.3.0"

[[deps.ImageMagick_jll]]
deps = ["JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1c0a2295cca535fabaf2029062912591e9b61987"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.10-12+3"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "e7c68ab3df4a75511ba33fc5d8d9098007b579a8"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.2"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "44664eea5408828c03e5addb84fa4f916132fc26"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.1"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "8717482f4a2108c9358e5c3ca903d3a6113badc9"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.5"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "5fa9f92e1e2918d9d1243b1131abe623cdf98be7"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.3"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3d09a9f60edf77f8a4d99f9e015e8fbf9989605d"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.7+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ad37c091f7d7daf900963171600d7c1c5c3ede32"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2023.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "3d8866c029dd6b16e69e0d4a939c4dfcb98fac47"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.8"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "68772f49f54b479fa88ace904f6127f0a3bb2e46"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.12"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "4ced6667f9974fc5c5943fa5e2ef1ca43ea9e450"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.8.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "PrecompileTools", "Printf", "Reexport", "Requires", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "9bbb5130d3b4fa52846546bca4791ecbdfb52730"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.38"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "d65930fa2bc96b07d7691c652d701dcbe7d9cf0b"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "0592b1810613d1c95eeebcd22dc11fba186c2a57"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.26"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "eb006abbd7041c28e0d16260e50a24f8f9104913"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2023.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "2c3726ceb3388917602169bed973dbc97f1b51a8"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.13"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "a4ca623df1ae99d09bc9868b008262d0c0ac1e4f"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4e5be6bb265d33669f98eb55d2a57addd1eeb72c"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.30"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "5ded86ccaf0647349231ed6c0822c10886d4a1ee"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.1"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "9f8675a55b37a70aa23177ec110f6e3f4dd68466"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.17"

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
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "00099623ffee15972c16111bcf84c58a0051257c"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.9.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "9a46862d248ea548e340e30e2894118749dc7f51"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.5"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "a38e7d70267283888bc83911626961f0b8d5966f"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.9"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "792d8fd4ad770b6d517a13ebb8dadfcac79405b8"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.6.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "5ef59aea6f18c25168842bded46b16662141ab87"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.7.0"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

[[deps.StringDistances]]
deps = ["Distances", "StatsAPI"]
git-tree-sha1 = "ceeef74797d961aee825aabf71446d6aba898acb"
uuid = "88034a9c-02f8-509d-84a9-84ec65e18404"
version = "0.11.2"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TestImages]]
deps = ["AxisArrays", "ColorTypes", "FileIO", "ImageIO", "ImageMagick", "OffsetArrays", "Pkg", "StringDistances"]
git-tree-sha1 = "0567860ec35a94c087bd98f35de1dddf482d7c67"
uuid = "5e47fb64-e119-507b-a336-dd2b206d9990"
version = "1.8.0"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "34cc045dd0aaa59b8bbe86c644679bc57f1d5bd0"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.8"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "Random"]
git-tree-sha1 = "242982d62ff0d1671e9029b52743062739255c7e"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.18.0"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "5f24e158cf4cee437052371455fe361f526da062"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.6"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "da69178aacc095066bad1f69d2f59a60a1dd8ad1"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.0+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─ff5d316f-806c-4652-97d8-323462395c69
# ╟─f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
# ╟─bdcb27c5-0603-49ac-b831-d78c558b31f0
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
# ╠═a4bb8383-1238-411e-b697-ed258d3c0c6d
# ╠═cb871521-e3d8-4b87-a474-b45b5c8167a9
# ╟─5e70263e-6512-40ef-ad0a-38287dfba684
# ╠═11df83bc-cb8e-4782-89f4-8abb73803621
# ╟─b3d54500-daab-4360-943d-30997c90aa02
# ╠═fed6823a-bd16-4efd-804c-58dd5a2339ef
# ╟─e6db1935-af93-4850-acfe-92cec4de4fed
# ╟─17f681ef-f30f-41fa-af34-7f331d359518
# ╠═7d81c2cb-5ce2-4a25-96f4-66688863bb54
# ╟─7adeed1a-70d7-45c4-99e1-9be23bbbeb86
# ╟─0af1c0ee-9739-41be-833e-20b838d3e502
# ╠═09cf939d-88df-4c7e-b164-67bfa431aaa7
# ╟─337eeee7-d39a-4a0e-9988-3e8830ae3989
# ╠═23676fde-e080-4e78-9c22-a2f05178f0c1
# ╠═85717691-5103-4c6f-bf6f-f56bbdb67b43
# ╟─542df6a2-5e73-4eff-af6e-353e39861c6c
# ╠═bb555bee-b9d5-4b6e-95c2-2793c3a2820b
# ╟─effd9509-4ad7-4d1f-96a5-dd9b32b09daa
# ╠═110bb376-57b6-4957-8e99-b8f564090fc1
# ╟─d6dabb0b-c6bc-4581-bb20-5dc598f5d323
# ╠═15fe42c4-9262-4673-b1b8-f417de0271d9
# ╟─9f137e55-ff39-4b95-b501-78921c27f4db
# ╠═4c3b1036-f530-43de-83e2-91ef962a86d6
# ╟─377fa7fd-f4a0-46a3-9511-d52155981cb9
# ╟─7f8b9940-9ebf-4d93-a76c-1e055c733122
# ╠═d5ebd2a3-8067-479c-bd9d-6e9c7c55972e
# ╟─3e933ccb-a6f3-4c2c-99ae-7ff03ed3a786
# ╠═8d144b90-32de-4367-86aa-89dd897c66d5
# ╠═57a9a2a7-06cd-4d55-b7fd-2f6d86f938a7
# ╠═afc54444-091c-4d06-95d3-dc7f0cb127b5
# ╠═61895459-48df-419f-b884-5cb51e1038e9
# ╠═c467be45-d8ef-4f68-9794-0ee9f15acf5f
# ╟─5858a0b8-6ead-4f26-b7be-ec684bd4602d
# ╟─49c75eed-d1cc-47e0-884b-8c327f638250
# ╠═ec262620-a818-4f5c-b6b9-24a58b73a603
# ╟─81a85548-ccf0-4d09-9cdf-f6eefc08017a
# ╠═8789e280-9d06-4284-8f43-42824e06bb20
# ╠═3fe28b4d-4a7a-4ea9-9b60-7a50c8f6b1e3
# ╠═6112c7eb-b2fb-4f46-8601-bc5787577042
# ╠═bcb516cd-6bee-4cd8-b633-a872a2bc107f
# ╟─0585d514-9255-49c5-bf57-c408c71600c7
# ╟─ef2c3f94-5db0-4a49-8bb2-cd2380e6fd82
# ╟─8401a066-f5c0-4d86-8d0e-e9c287762252
# ╟─7e4268d1-54d9-429b-9ec2-c2ccab5a7eda
# ╠═f597829c-b0c7-4b7f-b58b-bac8e52030f5
# ╟─5bba64bc-1dd1-4a71-bfe0-86497c31d617
# ╠═f1846dfe-0718-49f9-9825-84256a871ac7
# ╠═a72971ae-b1de-4892-85d2-52cb8ff025ff
# ╟─dcba5dbb-1a3d-49e8-a301-68c6bcae13b7
# ╠═87236fbd-e09c-4b81-b065-5954b2057b9b
# ╟─4e1f60e5-77c1-467a-9500-69c00f74700c
# ╟─ef23ba30-3f81-4676-850f-1a65062753a6
# ╠═74d0409d-8a10-4660-8a01-c75505f612e2
# ╟─7f9afd24-fd1c-49cd-b6bf-598cea9758c7
# ╟─05032f1b-ca1e-4fb0-ae21-060c06146871
# ╟─3e0b27fc-1ccb-440b-a98f-ee6541f3282e
# ╟─e2a37317-171d-4c45-975e-2752daf88008
# ╠═45d51447-beb8-4682-8b09-f65de7cfb95a
# ╟─776d80f1-ea26-4aeb-8bd5-c230956fa724
# ╠═5774bd94-3c87-48b5-868e-73418afbb5c7
# ╠═23227a0e-413a-4e05-9bf2-109a499b12cb
# ╟─5eea7d2e-cfda-4b42-9697-31ef645a1a79
# ╟─ce97f41f-8b71-468f-bac3-39a66e440cd5
# ╟─45d61914-591c-48bb-a0ad-902028d61089
# ╟─cecb430c-0236-4a16-b74f-1809710fbdfe
# ╠═f9906c93-f96d-45fd-b0ae-48794d82d54e
# ╟─58dd630a-ed1b-471a-94a3-fea43ec41d19
# ╟─de0a1efb-77ae-45bd-83a5-77029e2b095d
# ╟─60ebcfda-f28f-4aae-b1af-8e2a2313b3da
# ╠═aec673aa-fd15-46d6-85eb-4db54babfea8
# ╠═32d3a10a-bc5c-44a6-950c-8928936cd808
# ╠═46ca52b7-3ec7-4c97-8a1e-0fadda4fc883
# ╟─cf9d05d8-791a-4280-a160-d17992c25146
# ╠═fc2d0d0b-a790-465b-93a6-0cf0c533b070
# ╠═c2b1e609-8839-4788-8173-ede22c6dff19
# ╟─01053f0e-adcb-4fae-9f6b-9709056bb5a2
# ╠═0bc1537f-dc1b-46a8-a270-4decee040e9a
# ╠═8d8657ee-17c3-4b31-a28e-f6eca4e98b83
# ╠═468d3484-b2c9-42e6-a9e4-753c3e4a57ac
# ╠═c4491060-fd42-4045-a8a6-8a2e6437984a
# ╟─cb3a2a70-7a4c-4adb-9983-95614645971b
# ╠═7d1a176a-5b5c-4ccb-b8d4-3ff8c9370776
# ╠═cb5a04e5-848d-4974-9667-73ab80d4a54b
# ╠═87459e6f-f147-44bb-a713-b75d0d2702e0
# ╟─b5937641-83df-4e64-b51f-84c988a1f9f5
# ╟─57829229-6fe8-4f30-bb10-49d763316864
# ╠═b5d7850d-dac2-482e-b0bc-273660d0646a
# ╟─ea43cd35-b7f8-46e0-befb-d9b0248e0eb3
# ╟─5561d5fa-74fa-430f-850b-8339ad3df433
# ╟─725c19e3-2659-4f2d-8442-2bbc6010661b
# ╟─272aeadc-773e-41a7-a112-80e814e4ac3d
# ╟─027c7870-1603-4aba-95eb-3d14b7a0829f
# ╟─31056ca3-acd2-4457-bbd3-9ddd2c2ff641
# ╠═2f57e6de-c874-4f90-8e71-70cd1d002359
# ╠═2000a153-4b4d-4aec-a503-eaf3cc9d89c3
# ╟─0fe33d6c-d65d-4f29-857d-34ea792a1f48
# ╟─41a7bd3b-56f5-45e7-ac8d-313bb3a46181
# ╟─067c7894-2e3f-43de-998f-4f1a250bc0f7
# ╟─4a9735f7-0d2b-4557-a293-f0e0c6c19179
# ╟─af5e47f0-010b-4e69-bed3-95fdf9fce3fe
# ╠═216dcbf9-91aa-40fe-bef2-6dea56a35be7
# ╟─dda486b4-5838-429b-aec8-450d2f0c55be
# ╟─df1540c4-d458-428c-b230-6c42557557e1
# ╟─a60e422c-e4e2-42d2-b490-54f3123aa11a
# ╠═f3d0483f-ba78-4d3d-a23e-ec051923175d
# ╠═474cd2c3-b35b-4d01-b62a-e7171b4ee476
# ╠═6fd61dac-2ab1-464a-a20c-c0e1d7d23e8b
# ╟─6bbaa57a-0b06-452c-8196-d204fe07beb9
# ╟─4639b31c-9ef9-47a8-b9a9-b65b2e6d13fa
# ╟─edb7814a-eddf-4c87-8857-19bb0a0c0241
# ╠═f60be2e0-9b43-46b5-96ef-7747ab56e164
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
