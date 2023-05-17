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

# ╔═╡ 755b8685-0711-48a2-a3eb-f80af39f10e1
begin
    using PlutoUI
    using PlutoTeachingTools
    using HypertextLiteral
    using LaTeXStrings
    using Plots
end

# ╔═╡ 5754ef41-3835-40e3-a879-b071b4e12d5c
using Zygote

# ╔═╡ 031bc83b-8754-4586-83c8-08fbcbe80bda
using Enzyme

# ╔═╡ 44e0dc91-9f2a-4b1b-8ec2-dd6f8209558c
using FiniteDiff

# ╔═╡ efad4e11-75be-4081-8b32-7ddf600fb82a
using FiniteDifferences

# ╔═╡ ff9aa2fe-6984-4896-9437-f32ec2f385f7
using ForwardDiff

# ╔═╡ 83497498-2c14-49f4-bb5a-c252f655e006
ChooseDisplayMode()

# ╔═╡ 96b32c06-6136-4d44-be87-f2f67b374bbd
TableOfContents()

# ╔═╡ e56dbf8f-e0cb-4696-a8ed-e1e73d9e048b
PlutoTeachingTools.default_language[] = PlutoTeachingTools.PTTEnglish.EnglishUS();

# ╔═╡ 24871322-7513-4b19-a337-90b1d00a1747
example(md) = Markdown.MD(Markdown.Admonition("note", "Example", [md]));

# ╔═╡ 116c6f7e-eb6c-4c16-a4af-69a22eabd6d0
takeaways(md) = Markdown.MD(Markdown.Admonition("tip", "Takeaways", [md]));

# ╔═╡ f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
html"""
	<h1 style="text-align:center">
		Julia programming for ML
	</h1>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Lesson 6: Automatic differentiation
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Forward- & Reverse-Mode AD
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Adrian Hill
		</p>
		<p style="font-size: 20px;">
			TU Berlin, Summer Semester 2023
		</p>
	</div>
"""

# ╔═╡ 3cffee7c-7394-445f-b00d-bb32e5e63783
md"## Motivation
To apply gradient-based optimization methods such as [stochastic gradient descent](https://en.wikipedia.org/wiki/Stochastic_gradient_descent) to a neural network,
we need to compute the gradient of its loss function with respect to its parameters.

Since deep learning models can get large and complicated, it would be nice to have **machinery that can take an arbitrary function
$f: \mathbb{R}^n \rightarrow \mathbb{R}^m$ and return its derivative**.
This is called automatic differentiation (AD).

---
**Note:** This lecture demonstrates multiple automatic differentiation packages.
Loading it for the first time can take several minutes.
"

# ╔═╡ 748b0576-7e95-4199-918e-acd6a19adf84
md"""## The Julia AD ecosystem
Julia has more than a dozen AD systems.
A summary of available packages can be found at [juliadiff.org](https://juliadiff.org/).
The list is sorted by type:
1. *Reverse-mode*
1. *Forward-mode*
1. *Symbolic*
1. *Finite differencing*

and other more exotic approaches. These are already abstract sounding terms, but within these categories, there are further differences:

> Is the AD system *operator overloading* or *source-to-source*?
> Which *representation* level does it operate on?
> Does it only work on *scalar* functions?
> Does it allow *higher-order* AD?


As you may not be familiar with these terms, **the goal of this lecture is to explain differences in approaches between various AD packages and outline their pros and cons.**

For this purpose, we will take a step back and start with a recapitulation of two fundamental mathematical concepts: *linear maps* and *derivatives*.
"""

# ╔═╡ 0ca06dac-6e62-4ba5-bbe6-89ec8f0e8a26
md"# Linear maps"

# ╔═╡ 26727cec-1565-4a7d-b19d-1184a3749d4f
md"## Properties
Linear maps, also called linear transformations (*lineare Abbildungen* in German) are functions with the following properties:

| Property    | Equation                       | property satisfied                                                                                                                                                                                  | property not satisfied                                                                                                                                                                              |
|:------------|:-------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Additivity  | $f(v_1+v_2) = f(v_1) + f(v_2)$ | ![](https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Compatibility_of_linear_map_with_addition_1.svg/1280px-Compatibility_of_linear_map_with_addition_1.svg.png)                           | ![](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Compatibility_of_linear_map_with_addition_2.svg/1280px-Compatibility_of_linear_map_with_addition_2.svg.png)                           |
| Homogeneity | $f(\lambda v) = \lambda f(v)$  | ![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Compatibility_of_linear_map_with_scalar_multiplication_1.svg/1280px-Compatibility_of_linear_map_with_scalar_multiplication_1.svg.png) | ![](https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Compatibility_of_linear_map_with_scalar_multiplication_2.svg/1280px-Compatibility_of_linear_map_with_scalar_multiplication_2.svg.png) |

*Visualizations curtesy of [Stephan Kulla](https://commons.wikimedia.org/wiki/User:Stephan_Kulla) under CC0 license.*
"

# ╔═╡ f2dc6efc-c31d-4191-92a6-fa6cb3ea80f5
Foldable(
    "Mathematically more rigorous definition",
    md"""
    > Assuming two arbitrary vector spaces $V, W$ over the field $K$,
    > a function $f:V\rightarrow W$ is called a linear map
    > if additivity and homogeneity are satisfied for any vectors $v_1, v_2 \in V$ and $\lambda \in K$.
    """,
)

# ╔═╡ ae1c7dc7-6e0f-48c7-851b-dc6f0c0ad60e
md"""## Connection to matrices
> Every linear map $f$ between two finite-dimensional vector spaces $V, W$ **can be represented as a matrix**,
> given a basis for each vector space (e.g. the [standard basis](https://en.wikipedia.org/wiki/Standard_basis)).

A linear map $f: \mathbb{R}^n \rightarrow \mathbb{R}^m$ can be represented as

$f(x) = Ax$

where $A$ is a $m \times n$ matrix and $x \in \mathbb{R}^{n}$.
"""

# ╔═╡ 5106b16e-6cae-4b48-a0a7-5aca8eb81245
example(
    md"Linear maps $f: \mathbb{R}^2 \rightarrow \mathbb{R}^2$ can be represented as $2 \times 2$ matrices.

Many common geometric transformations are linear maps, for example

| Transformation                | Matrix representation                                                               |
|:------------------------------|:------------------------------------------------------------------------------------|
| Rotations by angle $\theta$   | $\begin{pmatrix} \cos\theta & -\sin\theta \\ \sin\theta & \cos\theta \end{pmatrix}$ |
| Projection on $y$-axis        | $\begin{pmatrix} 0 & 0 \\ 0 & 1 \end{pmatrix}$                                      |
| Reflection through $y$-axis   | $\begin{pmatrix} -1 & 0 \\ 0 & 1 \end{pmatrix}$                                     |
| Stretching along $y$-axis     | $\begin{pmatrix} 1 & 0 \\ 0 & k \end{pmatrix}$                                      |
| Shearing parallel to $y$-axis | $\begin{pmatrix} 1 & 0 \\ k & 1 \end{pmatrix}$                                      |
| Squeezing                     | $\begin{pmatrix} k & 0 \\ 0 & \frac{1}{k} \end{pmatrix}$                            |

for the basis $e_x = (1, 0)$, $e_y = (0, 1)$.
",
)

# ╔═╡ c1f8dc1e-52d4-4172-9e5b-c988d6cadcf7
md"## Composition
#### Connection to matrix multiplication
> The composition $h(x) = g(f(x))$ of two linear maps $f: V \rightarrow W$, $g: W \rightarrow Z$ is also a linear map $h: V \rightarrow Z$.

In finite-dimensional vector spaces, the composition of linear maps corresponds to matrix multiplication:

$\begin{align}
	f(x) &= Fx
		&,\;
		&f: \mathbb{R}^m \rightarrow \mathbb{R}^n
		&,\;
		&F \in \mathbb{R}^{n \times m} \\
	g(x) &= Gx
		&,\;
		&g: \mathbb{R}^n \rightarrow \mathbb{R}^p
		&,\;
		&G \in \mathbb{R}^{p \times n} \\
	h(x) = (g \circ f)(x) &= (G \cdot F) x = Hx
		&,\;
		&h: \mathbb{R}^m \rightarrow \mathbb{R}^p
		&,\;
		&H \in \mathbb{R}^{p \times m} \\
\end{align}$

#### Connection to matrix addition
> The sum of two linear maps $f_1: V \rightarrow W$, $f_2: V \rightarrow W$ is also a linear map:
>
> $(f_1 + f_2)(x) = f_1(x) + f_2(x) \quad$

In finite-dimensional vector spaces, the addition of linear maps corresponds to matrix addition.

For $f_1$ and $f_2: \mathbb{R}^n \rightarrow \mathbb{R}^m$ and $A, B \in \mathbb{R}^{m \times n}$

$\begin{align}
	f_1(x) &= Ax \\
	f_2(x) &= Bx \\
	(f_1 + f_2)(x) &= (A+B)x \quad .
\end{align}$
"

# ╔═╡ b3e9e95a-cd70-4dfb-b5a3-7d8cbdaabc75
takeaways(md"
- for our practical purposes, we can look at linear maps as functions or as matrices
- linear maps are composable, corresponding to matrix multiplication and addition
")

# ╔═╡ 78536125-8abc-4dfe-b84e-e22c4c6c19ed
md"# Derivatives"

# ╔═╡ 68e1e6e9-5e39-4156-9f66-494e16fbe7ca
md"""## What is a derivative?
The ([total](https://en.wikipedia.org/wiki/Total_derivative)) derivative of a function $f: \mathbb{R}^n \rightarrow \mathbb{R}^m$
at a point $\tilde{x} \in \mathbb{R}^n$ is the **linear approximation of $f$ near the point $\tilde{x}$**.

We give the derivative the symbol $\mathcal{D}f_\tilde{x}$. You can read this as "$\mathcal{D}$erivative of $f$ at $\tilde{x}$".


Most importantly, **the derivative is a linear map**

$\mathcal{D}f_\tilde{x}: \mathbb{R}^n \rightarrow \mathbb{R}^m \quad .$

Let's visualize this on a simple scalar function:
"""

# ╔═╡ 29ab341a-6049-4b68-81f2-6e1562f72d49
f(x) = x^2 - 5 * sin(x) - 10 # you can change this function!

# ╔═╡ b4f622c9-18bf-4eec-b5bc-66511c082808
md"You can play with this slider to select the point of linearization $\tilde{x}$:"

# ╔═╡ e078cb31-46de-43a5-a76a-8504891a870c
@bind x̂ Slider(-5:0.2:5, default=-1.5, show_value=true)

# ╔═╡ d4e8f116-62a7-42c8-9288-252e7326bcdd
begin
    # Plot function
    xs = range(-5, 5, 50)
    ymin, ymax = extrema(f.(xs))
    p = plot(
        xs,
        f;
        label=L"Function $f(x)$",
        xlabel=L"x",
        legend=:top,
        ylims=(ymin - 5, ymax + 5),
        legendfontsize=9,
    )

    # Obtain the function 𝒟fₓ̃ᵀ
    ŷ, 𝒟fₓ̂ᵀ = Zygote.pullback(f, x̂)

    # Plot Dfₓ̃(x)
    plot!(p, xs, w -> 𝒟fₓ̂ᵀ(w)[1]; label=L"Derivative $\mathcal{D}f_\tilde{x}(x)$")

    # Plot 1st order Taylor series approximation
    taylor_approx(x) = f(x̂) + 𝒟fₓ̂ᵀ(x - x̂)[1] # f(x) ≈ f(x̃) + 𝒟f(x̃)(x-x̃)
    plot!(p, xs, taylor_approx; label=L"Taylor approx. around $\tilde{x}$")

    # Show point of linearization
    vline!(p, [x̂]; style=:dash, c=:gray, label=L"\tilde{x}")
end

# ╔═╡ e966986c-d113-43cf-96f5-a89cd7427978
md"The orange line $\mathcal{D}f_\tilde{x}$ is of biggest interest to us.
Notice how the derivative fulfills *homogeneity*:
it always goes through the origin $(x,y)=(0,0).$


Using $\mathcal{D}f_\tilde{x}$, we can construct the first order Taylor series approximation of $f$ around $\tilde{x}$ (shown in green). For points close to $\tilde{x},$

$f(x) \approx f(\tilde{x}) + \mathcal{D}f_\tilde{x}(x-\tilde{x}) \quad .$
"

# ╔═╡ 430941d0-2f83-4af0-ab48-25d67da3e675
md"## Differentiability
From your calculus classes, you might recall that a function $f: \mathbb{R} \rightarrow \mathbb{R}$
is differentiable at $\tilde{x}$ if there is a number $f'(\tilde{x})$ such that

$\lim_{h \rightarrow 0} \frac{f(\tilde{x} + h) - f(\tilde{x})}{h}
= f'(\tilde{x}) \quad .$

This number $f'(\tilde{x})$ is called the derivative of $f$ at $\tilde{x}$.

We can now extend this notion to multivariate functions:
A function $f: \mathbb{R}^n \rightarrow \mathbb{R}^m$ is *totally* differentiable at a point $\tilde{x}$
if there exists a linear map $\mathcal{D}f_\tilde{x}$ such that

$\lim_{h \rightarrow 0} \frac{|f(\tilde{x} + h) - f(\tilde{x}) - \mathcal{D}f_\tilde{x}(h)|}{|h|}
= 0 \quad .$
"

# ╔═╡ 7aaa4294-97e7-4708-8047-f34c31bdd0d0
md"## Jacobians
Linear maps $f: \mathbb{R}^n \rightarrow \mathbb{R}^m$ can be represented as a $m \times n$ matrices.

In the [standard basis](https://en.wikipedia.org/wiki/Standard_basis), the matrix corresponding to $\mathcal{D}f$ is called the Jacobian:

$J_f = \begin{bmatrix}
    \dfrac{\partial f_1}{\partial x_1} & \cdots &
	\dfrac{\partial f_1}{\partial x_n}\\
    \vdots                             & \ddots & \vdots\\
    \dfrac{\partial f_m}{\partial x_1} & \cdots &
	\dfrac{\partial f_m}{\partial x_n}
\end{bmatrix}$

Note that every entry $[J_f]_{ij}=\frac{\partial f_i}{\partial x_j}$ in this matrix is a scalar function $\mathbb{R} \rightarrow \mathbb{R}$.



If we evaluate the Jacobian at a specific point $\tilde{x}$, we get the matrix corresponding to $\mathcal{D}f_\tilde{x}$:

$J_f\big|_\tilde{x} = \begin{bmatrix}
    \dfrac{\partial f_1}{\partial x_1}\Bigg|_\tilde{x} & \cdots &
	\dfrac{\partial f_1}{\partial x_n}\Bigg|_\tilde{x}\\
    \vdots                             & \ddots & \vdots\\
    \dfrac{\partial f_m}{\partial x_1}\Bigg|_\tilde{x} & \cdots &
	\dfrac{\partial f_m}{\partial x_n}\Bigg|_\tilde{x}
\end{bmatrix} \in \mathbb{R}^{m \times n}$
"

# ╔═╡ 1ccfec42-64e7-46d6-abe7-f4dbf84a51ab
example(
    md"Given the function $f: \mathbb{R}^2 \rightarrow \mathbb{R}^2$

$f\left(\begin{bmatrix} x_1\\x_2\end{bmatrix}\right)
= \begin{bmatrix}  x_1^2 x_2 \\5 x_1 + \sin x_2 \end{bmatrix} \quad ,$

we obtain the $2 \times 2\,$ Jacobian

$J_f = \begin{bmatrix}
  \dfrac{\partial f_1}{\partial x_1} & \dfrac{\partial f_1}{\partial x_2} \\
  \dfrac{\partial f_2}{\partial x_1} & \dfrac{\partial f_2}{\partial x_2} \end{bmatrix}
= \begin{bmatrix}
  2 x_1 x_2 & x_1^2    \\
  5     & \cos x_2
\end{bmatrix} \quad .$

At the point $\tilde{x} = (2, 0)$, the Jacobian is

$J_f\big|_\tilde{x} = \begin{bmatrix} 0 & 4 \\ 5 & 1 \end{bmatrix} \quad .$

In the standard basis, our linear map $\mathcal{D}f_\tilde{x}: \mathbb{R}^2 \rightarrow \mathbb{R}^2$ therefore corresponds to

$\mathcal{D}f_\tilde{x}(v)
= J_f\big|_\tilde{x} \cdot v
= \begin{bmatrix} 0 & 4 \\ 5 & 1 \end{bmatrix}
\begin{bmatrix} v_1 \\ v_2 \end{bmatrix} \quad ,$

for some input vector $v \in \mathbb{R}^2$.
",
)

# ╔═╡ ff39d133-eff4-4abc-b04e-360832d4dd2a
md"""## Jacobian-Vector products
As we have seen in the example on the previous slide, the total derivative

$\mathcal{D}f_\tilde{x}(v) = J_f\big|_\tilde{x} \cdot v$

computes a **Jacobian-Vector product**. It is also called the *"pushforward"* and is one of the two core primitives behind AD systems:

1. *Jacobian-Vector products* (JVPs) computed by the *pushforward*, used in forward-mode AD
2. *Vector-Jacobian products* (VJPs) computed by the *pullback*, used in reverse-mode AD

**Note:** In our notation, all vectors $v$ are column vectors and row vectors are written as transposed $v^T$.
"""

# ╔═╡ f324744a-aae8-4ee3-9498-9bdab9a942e8
tip(md"Jacobians can get very large for functions with high input and/or output dimensions.
When implementing AD, they therefore usually aren't allocated in memory.
Instead, linear maps $\mathcal{D}f$ are used.
")

# ╔═╡ 8ec1c1c3-5254-4678-8d63-2fa7487057d5
md"## Chain rule
Let's look at a function $h(x)=g(f(x))$ composed from two differentiable functions
$f: \mathbb{R}^n \rightarrow \mathbb{R}^m$ and $g: \mathbb{R}^m \rightarrow \mathbb{R}^p$.

$h = g \circ f\,$

Since derivatives are linear maps, we can obtain the derivate of $h$ by composing the derivatives of $g$ and $f$ using the **chain rule**:

$\mathcal{D}h_\tilde{x}
= \mathcal{D}(g \circ f)_\tilde{x}
= \mathcal{D}g_{f(\tilde{x})} \circ \mathcal{D}f_\tilde{x}$

As we have seen in the section on linear maps, this composition of linear maps is also a linear map.
It corresponds to simple matrix multiplication.

A proof of the chain rule can be found on page 19 of Spivak's *Calculus on manifolds*.
"

# ╔═╡ ec1bee51-c2b4-47b1-a78a-51d444943787
example(
    md"""We just introduced a form of the **chain rule** that works on arbitrary input and output dimensions $n$, $m$ and $p$.
**Let's show that we can recover the product rule**

$(uv)'=u'v+uv'$

of two scalar functions $u(t)$, $v(t)$.
We start out by defining

$g(u, v) = u \cdot v \qquad f(t) = \begin{bmatrix} u(t) \\ v(t) \end{bmatrix}$

such that

$h(t) = (g \circ f)(t) = u(t) \cdot v(t) \quad .$

The derivatives of $f$ and $g\,$ are

$\mathcal{D}g
= \begin{bmatrix}
	\frac{\partial g}{\partial u} &
	\frac{\partial g}{\partial v}
  \end{bmatrix}
= \begin{bmatrix} v & u \end{bmatrix}$

$\mathcal{D}f
= \begin{bmatrix}
	\frac{\partial f_1}{\partial t} \\
	\frac{\partial f_2}{\partial t}
  \end{bmatrix}
= \begin{bmatrix} u' \\ v' \end{bmatrix}$


Using the chain rule, we can compose these derivatives to obtain the derivative of $h$:

$\begin{align} (uv)'
	= \mathcal{D}h
	&= \mathcal{D}(g \circ f) \\
	&= \mathcal{D}g \circ \mathcal{D}f \\
	&= \begin{bmatrix} v & u \end{bmatrix}
		\cdot \begin{bmatrix} u' \\ v' \end{bmatrix} \\
	&= vu' + uv'
\end{align}$

As you can see, the product rule follows from the chain rule. Instead of memorizing several different rules,
the chain rule reduces everything to the composition of linear maps, which corresponds to matrix multiplication.
""",
)

# ╔═╡ eeef4f94-570a-4b1d-8f23-01dee37124ce
takeaways(
    md"""
* the derivative $\mathcal{D}f_\tilde{x}$ is a linear approximation of $f$ near the point $\tilde{x}$
* derivatives are linear maps, therefore nicely composable
* viewing linear maps as matrices, derivatives compute Jacobian-Vector products
* The chain-rule allows us to obtain the derivative of a function by composing  derivatives of its parts. This corresponds to matrix multiplication.
""",
)

# ╔═╡ 0fb53e78-06f9-4e5c-a782-ba8744a70c8d
md"# Forward-mode AD"

# ╔═╡ f9699004-6655-4e08-8596-d9067b773d89
md"## Function composition
In Deep Learning, we often need to compute derivatives over deeply nested functions.
Assume we want to differentiate over a neural network $f$ with $N$ layers

$f(x) = f^N(f^{N-1}(\ldots f^2(f^1(x)))) \quad ,$

where $f^i$ is the $i$-th layer of the neural network.

Applying the chain rule to compute the derivative of $f$ at $\tilde{x}$, we get

$\begin{align}
	\mathcal{D}f_\tilde{x}
	&= \mathcal{D}(f^N \circ f^{N-1} \circ \ldots \circ f^2 \circ f^1)_\tilde{x} \\[1em]
	&= 	\mathcal{D}f^{N}_{h_{N-1}} \circ
		\mathcal{D}f^{N-1}_{h_{N-2}} \circ \ldots \circ
		\mathcal{D}f^2_{h_1}  \circ
		\mathcal{D}f^1_{\tilde{x}}
\end{align}$

where $h_i$ is the output of the $i$-th layer given the input $\tilde{x}$:

$\begin{align}
	h_1 &= f^1(\tilde{x}) \\
	h_2 &= f^2(f^1(\tilde{x}))\\
		&\,\,\,\vdots \\
	h_{N-1} &= f^{N-1}(f^{N-2}(\ldots f^2(f^1(x))))
\end{align}$
"

# ╔═╡ 4afb6a1c-a0ff-4719-828e-4989bf472465
md"""## Forward accumulation
Let's visualize the compositional structure from the previous slide as a computational graph:
"""

# ╔═╡ 34c93a06-58e9-4c61-be87-9ec43a855e9a
forward_accumulation = @htl("""
<article class="diagram">
<pre><code>
     x̃    ┌─────┐  h₁  ┌─────┐ h₂      hₙ₋₂ ┌───────┐  hₙ₋₁ ┌─────┐   y
──────┬──►│  f¹ ├──┬──►│  f² ├───► .. ──┬──►│  fⁿ⁻¹ ├───┬──►│  fⁿ ├───────►
      │   └─────┘  │   └─────┘          │   └───────┘   │   └─────┘
      │   ┌─────┐  │   ┌─────┐          │   ┌───────┐   │   ┌─────┐
      └──►│ 𝒟f¹ │  └──►│ 𝒟f² │          └──►│ 𝒟fⁿ⁻¹ │   └──►│ 𝒟fⁿ │
─────────►│     ├─────►│     ├───► .. ─────►│       ├──────►│     ├───────►
     v    └─────┘      └─────┘              └───────┘       └─────┘ 𝒟fₓ̃(v)
</code></pre>
</article>

<style>
	article.diagram code {
		width: 800px;
		display: block;
	}
</style>
""")

# ╔═╡ 112a6344-070e-4d1b-b821-65c5723ebb99
md"""
We can see that the computation of both $y=f(\tilde{x})$ and a Jacobian-Vector product $\mathcal{D}f_\tilde{x}(v)$
takes a single forward-pass through the compositional structure of $f$.

This is called forward accumulation and is the basis for **forward-mode AD**.
"""

# ╔═╡ 1b34590a-8754-439c-a5e7-eb96c097f6fd
md"""## Computing Jacobians
We've seen that Jacobian-vector products (JVPs) can be computed using the chain rule.
It is important to emphasize that **this only computes JVPs, not full Jacobians**:

$\mathcal{D}f_\tilde{x}(v) = J_f\big|_\tilde{x} \cdot v$

However, by computing the JVP with the $i$-th standard basis column vector $e_i$, where

$\begin{align}
	e_1 &= (1, 0, 0, \ldots, 0) \\
	e_2 &= (0, 1, 0, \ldots, 0) \\
		&\;\;\vdots \\
	e_n &= (0, 0, 0, \ldots, 1) \quad ,
\end{align}$

we obtain the $i$-th column in the Jacobian / Gradient

$\begin{align}
\mathcal{D}f_\tilde{x}(e_i)
&= J_f\big|_\tilde{x} \cdot e_i \\[0.5em]
&= \begin{bmatrix}
    \dfrac{\partial f_1}{\partial x_1}\Bigg|_\tilde{x} & \cdots &
	\dfrac{\partial f_1}{\partial x_n}\Bigg|_\tilde{x}\\
    \vdots                             & \ddots & \vdots\\
    \dfrac{\partial f_m}{\partial x_1}\Bigg|_\tilde{x} & \cdots &
	\dfrac{\partial f_m}{\partial x_n}\Bigg|_\tilde{x}
\end{bmatrix} \cdot e_i \\[0.5em]
&= \begin{bmatrix}
    \dfrac{\partial f_1}{\partial x_i}\Bigg|_\tilde{x} \\
    \vdots \\
    \dfrac{\partial f_m}{\partial x_i}\Bigg|_\tilde{x} \\
\end{bmatrix} \quad .
\end{align}$


> For $f: \mathbb{R}^n \rightarrow \mathbb{R}^m$, computing the full $m \times n$ Jacobian therefore requires computing $n\,$ JVPs:
> one for each column, as many as the **input dimensionality** of $f$.
"""

# ╔═╡ 1effbb3e-067b-4166-a39d-efa8e1d38f31
md"""# Reverse-mode AD
## Computing Jacobians
In the previous slide, we've seen that for functions  $f: \mathbb{R}^n \rightarrow \mathbb{R}^m$,
we can construct a $m \times n$ Jacobian by computing $n$ JVPs, one for each column.

There is an alternative way: instead of right-multiplying standard basis vectors,
we could also obtain the Jacobian by left-multiplying row basis vectors $e_1^T$ to $e_m^T$.

We obtain the $i$-th *row* of the Jacobian as

$\begin{align}
e_i^T \cdot J_f\big|_\tilde{x}
&= e_i^T \cdot \begin{bmatrix}
    \dfrac{\partial f_1}{\partial x_1}\Bigg|_\tilde{x} & \cdots &
	\dfrac{\partial f_1}{\partial x_n}\Bigg|_\tilde{x}\\
    \vdots                             & \ddots & \vdots\\
    \dfrac{\partial f_m}{\partial x_1}\Bigg|_\tilde{x} & \cdots &
	\dfrac{\partial f_m}{\partial x_n}\Bigg|_\tilde{x}
\end{bmatrix} \\[0.5em]
&= \hspace{1.8em}\begin{bmatrix}
    \dfrac{\partial f_i}{\partial x_1}\Bigg|_\tilde{x} & \cdots &
	\dfrac{\partial f_i}{\partial x_n}\Bigg|_\tilde{x}
\end{bmatrix} \quad .
\end{align}$

> Computing the full $m \times n$ Jacobian requires computing $m\,$ VJPs: one for each row, as many as the **output dimensionality** of $f$.
"""

# ╔═╡ 9d035fb4-5ae2-4d8e-973c-c72d5cb77a44
md"## Function composition
For forward accumulation on a function $f(x) = f^N(f^{N-1}(\ldots f^2(f^1(x))))$, we saw that

$\mathcal{D}f_\tilde{x}(v)
= \big(
	\mathcal{D}f^{N}_{h_{N-1}} \circ \ldots \circ
	\mathcal{D}f^2_{h_1}  \circ
	\mathcal{D}f^1_{\tilde{x}}\big)(v)$

or in terms of Jacobians

$\begin{align}
\mathcal{D}f_\tilde{x}(v)
&= J_f\big|_\tilde{x} \cdot v \\[0.5em]
&= 	J_{f^{N  }}\big|_{h_{N-1}} \cdot \ldots \cdot
	J_{f^{2  }}\big|_{h_{1  }} \cdot
	J_{f^{1  }}\big|_{h_{\tilde{X}}} \cdot v \\[0.5em]
&= 	J_{f^{N  }}\big|_{h_{N-1}} \cdot
	\Big( \ldots \cdot
	\Big( J_{f^{2  }}\big|_{h_{1  }} \cdot
	\Big( J_{f^{1  }}\big|_{\tilde{x}} \cdot v \Big)\Big)\Big)
\end{align}$

where brackets are added to emphasize that the compositional structure can be seen as a series of nested JVPs.
"

# ╔═╡ ab09259f-51d9-47d9-93c8-34af8bbf71f9
md"""---
Let's use the same notation to write down the Vector-Jacobian product:

$\begin{align}
w^T \cdot J_f\big|_\tilde{x}
&= 	w^T \cdot
	J_{f^{N  }}\big|_{h_{N-1}} \cdot
	J_{f^{N-1}}\big|_{h_{N-2}} \cdot \ldots \cdot
	J_{f^{1  }}\big|_{h_{\tilde{X}}} \\[0.5em]
&= \Big(\Big(\Big( w^T \cdot
	J_{f^{N  }}\big|_{h_{N-1}} \Big) \cdot
	J_{f^{N-1}}\big|_{h_{N-2}} \Big) \cdot \ldots \Big)  \cdot
	J_{f^{1  }}\big|_{h_{\tilde{X}}}
\end{align}$

once again, parentheses have been added to emphasize the compositional structure of a series of nested VJPs.

Introducing the **transpose of the derivative**

$\big(\mathcal{D}f_\tilde{x}\big)^T(w)
= \Big(w^T \cdot J_f\big|_\tilde{x}\Big) ^ T
= J_f\big|_\tilde{x}^T \cdot w  \quad ,$

which is also a linear map, we obtain the compositional structure

$\begin{align}
\big(\mathcal{D}f_\tilde{x}\big)^T(w)
&= 	\Big(
	\big(\mathcal{D}f^{1  }_\tilde{x}\big)^T  \circ \ldots \circ
	\big(\mathcal{D}f^{N-1}_{h_{N-2}}\big)^T \circ
	\big(\mathcal{D}f^{N  }_{h_{N-1}}\big)^T \Big) (w) \quad .
\end{align}$

This linear map is also called the *"pullback"*
"""

# ╔═╡ d89c4e9b-c804-4dec-9add-cab1ff44719b
md"## Reverse accumulation
Let's visualize the compositional structure from the previous slide as a computational graph
"

# ╔═╡ b8867e98-345b-4e6c-9f69-5c081d38aaf7
reverse_accumulation = @htl("""
<article class="diagram">
<pre><code>
      x̃    ┌──────┐  h₁  ┌──────┐ h₂      hₙ₋₂ ┌────────┐  hₙ₋₁ ┌──────┐ y
───────┬──►│  f¹  ├──┬──►│  f²  ├───► .. ──┬──►│  fⁿ⁻¹  ├───┬──►│  fⁿ  ├───►
       │   └──────┘  │   └──────┘          │   └────────┘   │   └──────┘
       │   ┌──────┐  │   ┌──────┐          │   ┌────────┐   │   ┌──────┐
       └──►│(𝒟f¹)ᵀ│  └──►│(𝒟f²)ᵀ│          └──►│(𝒟fⁿ⁻¹)ᵀ│   └──►│(𝒟fⁿ)ᵀ│
◄──────────┤      │◄─────┤      │◄─── .. ──────┤        │◄──────┤      │◄───
 (𝒟fₓ̃)ᵀ(w) └──────┘      └──────┘              └────────┘       └──────┘ w
</code></pre>
</article>

<style>
	article.diagram code {
		width: 800px;
		display: block;
	}
</style>
""")

# ╔═╡ b5dcbc38-d816-41b8-85d4-c0e5a9fefb39
md"""
We can see that the computation of both $y=f(\tilde{x})$ and the intermediate outputs $h_i$ first takes a forward-pass through $f$.
Keeping track of all $h_i$, we can follow this forward-pass up by a reverse-pass, computing a VJP $(\mathcal{D}f_\tilde{x})^T(w)$.

This is called reverse accumulation and is the basis for **reverse-mode AD**.

You might want to compare this to the graph of forward accumulation:
"""

# ╔═╡ 53705d41-36dd-4868-9193-8ee80aa94a07
forward_accumulation

# ╔═╡ cebd8f5c-a72c-436d-a870-a1a64fde16ab
md"""## Computing gradients
For scalar-valued functions $f: \mathbb{R}^n \rightarrow \mathbb{R}$ (such as neural networks with scalar loss functions),
the gradient $\nabla f\big|_\tilde{x}$ is equivalent to the transpose of the $1 \times n\,$ Jacobian:

$\Big(\nabla f\big|_\tilde{x}\Big)^T
= \begin{bmatrix}
    \dfrac{\partial f}{\partial x_1}\Bigg|_\tilde{x} &
    \dots &
    \dfrac{\partial f}{\partial x_n}\Bigg|_\tilde{x}
\end{bmatrix}
= J_f\big|_\tilde{x}$

### Computing gradients using JVPs
Compute the $i$-th entry of the Jacobian by evaluating the *pushforward* with the standard basis vector $e_i$:

$\begin{align}
\mathcal{D}f_\tilde{x}(e_i)
&= J_f\big|_\tilde{x} \cdot e_i \\[0.5em]
&= \begin{bmatrix}
    \dfrac{\partial f}{\partial x_1}\Bigg|_\tilde{x} &
    \dots &
    \dfrac{\partial f}{\partial x_n}\Bigg|_\tilde{x}
\end{bmatrix} \cdot e_i \\[0.5em]
&= \dfrac{\partial f}{\partial x_i}\Bigg|_\tilde{x}
\end{align}$

Obtaining the full gradient requires computing $n$ JVPs with $e_1$ to $e_n$.

> **Computing gradients with forward-mode AD is expensive**: we need to evaluate $n\,$ JVPs, where $n$ corresponds to the input dimensionality.

### Computing gradients using VJPs
Since our function is scalar-valued, we only need to compute a single VJP by evaluating the *pullback* with $e_1=1$:

$\begin{align}\big(\mathcal{D}f_\tilde{x}\big)^T(1)
= \Big(1 \cdot J_f\big|_\tilde{x}\Big) ^ T
= J_f\big|_\tilde{x}^T
= \nabla f\big|_\tilde{x}
\end{align}$

> **Computing gradients with reverse-mode AD is cheap**: we only need to evaluate a single VJP since the output dimensionality of $f$ is $m=1$.
"""

# ╔═╡ c365c5a2-43b7-4ddc-82f1-3ca0670117ba
takeaways(
    md"
- JVPs and VJPs are the building blocks of automatic differentiation
- Jacobians and gradients are computed using JVPs (forward-mode) or VJPs (reverse-mode AD)
- Given a function $f: \mathbb{R}^n \rightarrow \mathbb{R}^m$
  - if $n \ll m$, forward-mode AD is more efficient
  - if $n \gg m$, reverse-mode AD is more efficient
- In Deep Learning, $n$ is usually very large and $m=1$, making reverse-mode more efficient than forward-mode AD.
",
)

# ╔═╡ d690349c-b4a1-4310-a237-622e0614a24c
md"# Automatic differentiation in Julia"

# ╔═╡ 98b0ac01-3a8c-4124-b470-7529bd136c0f
md"""## Rule-based AD
Looking at the computational graphs of forward- and reverse-mode AD gives us an idea on how to implement a *"rule-based"* AD system in Julia:
"""

# ╔═╡ fd5f0258-8d14-4200-9c49-d88656ec6c75
forward_accumulation

# ╔═╡ 52d897f3-c877-4b92-a482-dd748d404d97
reverse_accumulation

# ╔═╡ 344a0531-60fa-436b-bdc5-0aaa98df0463
md"""
For every function `fⁱ(x)`, we need to match either
- a *"forward rule"* that returns the *pushforward*: `forward_rule(f, x̃) = v -> 𝒟fₓ̃(v)`
- a *"reverse rule"* that returns the *pullback*: `reverse_rule(f, x̃) = w -> (𝒟fₓ̃)ᵀ(w)`.

Since in Julia, a function `f` is of type `typeof(f)`, we could use multiple dispatch to automatically match functions and their rules!

Then,
- for forward-mode AD, we can then simply iterate through all `fⁱ` and `𝒟fⁱₓ̃`, simultaneously computing `y` and a JVP `𝒟fₓ̃(v)`.
- for reverse-mode AD, we first need to iterate through all `fⁱ` and store all intermediate activations `hⁱ` and pullback functions `(𝒟fⁱₓ̃)ᵀ`.
  Data structures that save these are commonly called *tape* or *Wengert lists*.
  We then have all the ingredients needed to compute a VJP `(𝒟fₓ̃)ᵀ(w)` in a second backward pass.
"""

# ╔═╡ 92def6ee-965c-42f9-acd3-176ac6e8c242
md"""## ChainRules.jl
[ChainRules.jl](https://github.com/JuliaDiff/ChainRules.jl) is a package that implements forward- and reverse-mode AD rules for many different functions,
allowing downstream Julia AD packages to re-use them instead of having to reimplement all rules.

Instead of explaining the API in detail, we are take a look at how forward and backward rules are implemented for the `sin` function.
To avoid confusion, we are going to stick with our notation instead of the one used in the [ChainRules documentation](https://juliadiff.org/ChainRulesCore.jl/dev/).
"""

# ╔═╡ 73d8aa52-b494-44dc-9594-c6e10d741981
tip(
    md"The [ChainRules.jl documentation](https://juliadiff.org/ChainRulesCore.jl/dev/) has a well written
    [math primer](https://juliadiff.org/ChainRulesCore.jl/dev/maths/propagators.html) introducing their nomenclature and notation.",
)

# ╔═╡ 8ed56f12-a076-4cff-bf7e-8e1e99674f34
md"""### Forward-mode AD rule
ChainRules.jl calls forward rules `frule`.

 $\mathcal{D}f_\tilde{x}(v)$, the derivative of $f(x) = \sin(x)$ at $\tilde{x}$, evaluated at $v$,  is implemented as:

```julia
function frule((_, v), ::typeof(sin), x̃)
    return sin(x̃), cos(x̃) * v
end
```

We can observe that:
- `frule` dispatches on the type of `sin`
- `frule` returns $y = \sin(\tilde{x})$. This is often called the *primal output*
- `frule` directly returns the result of the JVP computation $\mathcal{D}f_\tilde{x}(v) = \cos(\tilde{x})\cdot v$
"""

# ╔═╡ 69b448a1-99a2-4336-bb95-1adb0863943b
md"""### Reverse-mode AD rule
ChainRules.jl calls reverse rules `rrule`.

 $(\mathcal{D}f_\tilde{x})^T(w)$ is implemented as

```julia
function rrule(::typeof(sin), x̃)
    sin_pullback(w) = (NoTangent(), cos(x̃)' * w)
    return sin(x̃), sin_pullback
end
```

We can observe that:
- `rrule` dispatches on the type of `sin`
- `rrule` also returns the primal output $y = \sin(\tilde{x})$
- instead of directly returning the result of the VJP computation $(\mathcal{D}f_\tilde{x})^T(w)$,
  `rrule` returns a closure that implements the pullback function $(\mathcal{D}f_\tilde{x})^T$.
"""

# ╔═╡ c9e073b7-038e-4357-b3f0-669c63413387
md"### ChainRulesCore.jl
If you develop your own package, you can make use of [ChainRulesCore.jl](https://github.com/JuliaDiff/ChainRulesCore.jl),
a light-weight dependency that allows you to define forward- and/or reverse-rules for your package without having to depend on specific AD implementations.
"

# ╔═╡ 2abcf211-5ffd-464e-8948-83860fe186db
md"""## Code introspection ⁽⁺⁾
Many AD packages perform *source to source* transformations to generate pullback functions $(\mathcal{D}f_\tilde{x})^T$ from functions $f$ and $\tilde{x}$.  

For this purpose, Julia code needs to look at its own compositional structure. This is called *reflection* or *introspection* and gives Julia its metaprogramming powers.
Introspection can be applied at several levels: AST, IR, LLVM or native code. Let's demonstrate this on a simple test function:
"""

# ╔═╡ 32f6945a-d918-4cdc-8c4d-8d3cd898392d
foo(x) = sqrt(x + 2)

# ╔═╡ 3c02c7dc-064e-4b11-8750-e01ac0c090c7
md"### Depth 1: AST representation
Using Julia's metaprogramming capabilities, the structure of source code can be represented as an *abstract syntax tree* (AST)."

# ╔═╡ effe7e5e-a5e9-472d-ad4a-7ec7a9022b03
ast = Meta.parse("foo(x) = sqrt(x + 2)")

# ╔═╡ 2037447c-d916-4c13-b620-5d27bf5debe6
ast.head

# ╔═╡ 9218e2f5-722e-4559-b4e6-bb3fcee6e0ea
ast.args

# ╔═╡ 25634d4c-1346-4678-a4c5-84e18a95f8d6
md"### Depth 2: Julia IR
Using the `@code_lowered` macro, we can view the *intermediate representation* (IR) of our code."

# ╔═╡ b953c179-3802-4ac9-a831-ffeac8e6746a
@code_lowered foo(1)

# ╔═╡ 9a71568d-2ebf-4f0f-86f7-71d0d51c0bef
md"### Depth 3: LLVM representation
Using the `@code_llvm` macro, we can view the LLVM IR that is compiled from our code."

# ╔═╡ 9eaa6fd1-d2a6-4603-a7a1-e128e38eeb73
@code_llvm foo(1)

# ╔═╡ 7a168cc7-0615-4f1c-8c2d-6d3ad831c2b9
md"""### Depth 4: Native code
Using the `@code_native` macro, we can view specific assembly instructions that are compiled from our code.

This is specific to each CPU architecture and therefore **"too deep" of a representation to implement AD systems in**.
"""

# ╔═╡ 665fc505-3ccc-4b1a-b4d5-5124ff08bbe9
@code_native foo(1)

# ╔═╡ 7fa49c99-fad0-4cbc-9207-940570676906
md"""## Zygote.jl
[Zygote.jl](https://github.com/FluxML/Zygote.jl) is a widely used reverse-mode AD system.
It uses ChainRules.jl and performs *"IR-level source to source"* transformation,
meaning that is looks at the Julia IR to analyze the structure of the function it differentiates.
It then constructs a function that computes the VJP.
"""

# ╔═╡ 40bc8112-371b-4401-b393-d4fe0578089e
md"Given a function $g(x) = x_1^2 + 2 x_1 x_2$"

# ╔═╡ 65d5b76b-cfda-4aac-ba54-733f578c6622
g(x) = x[1]^2 + 2 * x[1] * x[2]

# ╔═╡ 3de239d4-40e3-42b1-946d-dbc328510d29
md"and $\tilde{x} = (1, 2)$"

# ╔═╡ 61ddd27b-2c90-4a6c-a8ad-cf8cf5fa4301
x̃ = [1.0, 2.0]

# ╔═╡ 8bfa9912-71f2-4eff-a8c5-b6df81b3bf7e
md"we can compute the primal $y=g(\tilde{x})$ and the pullback $\big(\mathcal{D}g_\tilde{x}\big)^T$ using the function `pullback`:"

# ╔═╡ 5b59b307-c864-4775-95ca-30ea12feb16d
y, 𝒟gₓ̃ᵀ = Zygote.pullback(g, x̃)

# ╔═╡ b24d757b-cbbb-4ff4-a11d-5bc55320be64
md"""
For $\tilde{x}=(1 , 2)$, the gradient is

$\nabla g\big|_\tilde{x}
= \begin{bmatrix}
		\frac{\partial g}{\partial x_1}\Big|_\tilde{x} \\
		\frac{\partial g}{\partial x_2}\Big|_\tilde{x}
	\end{bmatrix}
= \begin{bmatrix}
		2\tilde{x}_1 + 2\tilde{x}_2 \\
		2\tilde{x}_1
	\end{bmatrix}
= \begin{bmatrix} 6 \\ 2 \end{bmatrix} \quad .$

As we have learned in the slide *"Reverse-mode AD: Computing gradients"*,
the gradient corresponds to the transpose of the Jacobian, which we obtain by computing a VJP with $e_1=1$:

$\begin{align}\big(\mathcal{D}g_\tilde{x}\big)^T(1)
= \Big(1 \cdot J_g\big|_\tilde{x}\Big) ^ T
= J_g\big|_\tilde{x}^T
= \nabla g\big|_\tilde{x}
\end{align}$
"""

# ╔═╡ 6211048c-71a6-488e-a549-b50934823c36
grad = 𝒟gₓ̃ᵀ(1)

# ╔═╡ 520d017e-a94d-4d81-b99c-90714578bd8f
md"If we are only interested in the gradient, Zygote also offers the convenience function `gradient`,
which does exactly what we did: compute the *pullback* $\big(\mathcal{D}g_\tilde{x}\big)^T$
and evaluate $\big(\mathcal{D}g_\tilde{x}\big)^T(1)$:"

# ╔═╡ 86f443be-7a41-49c6-9792-86e6908028a3
Zygote.gradient(g, x̃)

# ╔═╡ 5aacbeaf-8085-4787-8475-9989881e070b
md"To also return the primal output, call `withgradient`:"

# ╔═╡ f1a10f5c-d96c-475c-9ef1-90e827b6d670
Zygote.withgradient(g, x̃)

# ╔═╡ a7396ce9-62bc-4be7-8db3-3801b23f028b
md"""### Caveats
As we have learned, Zygote's reverse-mode AD applies the chain rule to a function that is composed of several other functions:
"""

# ╔═╡ faf4aef3-133b-44ef-b4fe-8223de4ca86b
reverse_accumulation

# ╔═╡ 67215844-1c32-49eb-8d01-cc8c81f5e37d
md"""The computational graph assumes that all functions `fⁱ` are *"pure"* and have *no side effects*,
which allows us to store intermediate activations `hⁱ` for a later backward-pass.

This motivates a problem: **If a function $f$ in-place modifies the activation $h$ from the previous layer to $\hat{h}$,
Zygote will compute $\big(\mathcal{D}f_\hat{h}\big)^T$
instead of $\big(\mathcal{D}f_h\big)^T$** and return the wrong VJP / gradient.

In the best case, an error will be thrown when Zygote catches a mutating function:

```julia
Mutating arrays is not supported -- called `copyto!(Vector{Int64}, ...)`.

This error occurs when you ask Zygote to differentiate operations that change
the elements of arrays in place (e.g. setting values with `x .= ...`)

Possible fixes:
- avoid mutating operations (preferred)
- or read the documentation and solutions for this error
  https://fluxml.ai/Zygote.jl/latest/limitations
```

In the worst case scenario, an incorrect gradient will be silently returned.

This can be dangerous when trying to differentiate through a function `foo` from an external package.
Even non-mutating functions `foo` might call a mutating function `bar!` under the hood.
Make sure the package developer advertises compatibility with Zygote
or check the source code and run some sanity tests.
"""

# ╔═╡ 513990ce-d7e5-4ca6-a079-e0b3197571ee
tip(
    md"Always read the section on limitations / gotchas / sharp bits in AD package documentation.",
)

# ╔═╡ a2c9b337-7381-4d46-9981-5fad6043f76f
md"""## Enzyme.jl
[Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) is a new, experimental AD system that does *LLVM source to source* transformations, supporting both forward- and reverse-mode AD.
It currently doesn't support ChainRules.jl, instead using its own [EnzymeRules](https://enzyme.mit.edu/index.fcgi/julia/stable/generated/custom_rule/).

Since the package is under rapid development and the API hasn't fully stabilized, note that this example uses Enzyme `v0.11`.
"""

# ╔═╡ 4ea887d9-956a-4ca4-96be-be8c4b1ba330
md"For $\tilde{x}=(1,2)$ and

$g(x) = x_1^2 + 2 x_1 x_2 \quad ,$

we can use reverse-mode AD to correctly obtain the primal output $y=5$ and the gradient $\nabla g\big|_\tilde{x} = (6, 2)$:"

# ╔═╡ 14e464f7-d262-4d80-abd3-41d138895673
begin
    # Allocate array grad_rev for gradient
    grad_rev = similar(x̃)

    # Mutate grad_rev in place
    out_rev = Enzyme.autodiff(ReverseWithPrimal, g, Active, Duplicated(x̃, grad_rev))

    @info out_rev # contains primal output y = g(x̃)
    @info grad_rev
end

# ╔═╡ 3e2bdfbf-dc0a-40d6-b67c-d97dae8a67f3
md"We can also use forward-mode AD:"

# ╔═╡ 46646317-7160-4a83-9468-009c12cd6691
begin
    v = ([1.0, 0.0], [0.0, 1.0]) # standard basis vectors e₁, e₂

    out_fwd = Enzyme.autodiff(Forward, g, BatchDuplicated, BatchDuplicated(x̃, v))

    @info out_fwd # contains primal output and gradient
end

# ╔═╡ 06f2a81a-97bd-4e03-a470-5c3be869d61c
md"**Personal opinion:**
Enzyme is very promising, but still in early development. The API still needs some polish."

# ╔═╡ 1ec36193-87cc-40a6-8dbf-69ad88c5f034
md"""## Finite differences
In this lecture, we jumped directly into linear maps and total derivatives to motivate forward- and reverse-mode AD.
By doing so, we skipped the simplest method of all: *finite differences*.

Going back to the definition of a derivative we introduced in the slide on *Differentiability*,
for $f: \mathbb{R} \rightarrow \mathbb{R}$, we can compute the derivative as

$f'(\tilde{x}) = \lim_{h \rightarrow 0} \frac{f(\tilde{x} + h) - f(\tilde{x})}{h} \quad .$

Using a very small number $\varepsilon$, we can **approximate** the derivative as

$f'(\tilde{x}) \approx \frac{f(\tilde{x} + \varepsilon) - f(\tilde{x})}{\varepsilon} \quad .$

Without going into too much detail, this idea generalizes to functions
$f: \mathbb{R}^n \rightarrow \mathbb{R}^m$.
Similar to forward-mode AD, we can use finite differences to recover one column of the Jacobian of $J_f\big|_\tilde{x}$ at a time.
Using a perturbation "in direction" $e_i$, we **approximate** the $i$-th column ot the Jacobian as

$J_f\big|_\tilde{x} \cdot e_i
\approx \frac{f(\tilde{x} + \varepsilon e_i) - f(\tilde{x})}{\varepsilon} \quad .$


### Caveats
Computing a Jacobian or Gradient using finite differences requires $n+1$ evaluations of $f$
and therefore gets expensive for functions with large input dimensionality $n$.

Additionally, selecting $\varepsilon$ can be tricky: If it is too large, our approximation of the derivative is inaccurate.
If it is too small, we run into numerical problems due to rounding errors in floating point arithmetic.

However, finite differences are easy to implement and can be applied to almost any function.
"""

# ╔═╡ 2a166f56-e179-4986-857a-dcd6d577fb6b
md"### FiniteDiff.jl and FiniteDifferences.jl
[FiniteDiff.jl](https://github.com/JuliaDiff/FiniteDiff.jl) and [FiniteDifferences.jl](https://github.com/JuliaDiff/FiniteDifferences.jl)
are two similar packages that implement finite differences.
The [documentation](https://docs.sciml.ai/FiniteDiff/stable/#FiniteDiff.jl-vs-FiniteDifferences.jl) lists differences between the two packages:
> - FiniteDifferences.jl supports basically any type, where as FiniteDiff.jl supports only array-ish types
> - FiniteDifferences.jl supports higher order approximation
> - FiniteDiff.jl is carefully optimized to minimize allocations
> - FiniteDiff.jl supports coloring vectors for efficient calculation of sparse Jacobians
"

# ╔═╡ f5253b44-981e-4fd2-bac8-094238c29ef1
md"#### FiniteDiff.jl"

# ╔═╡ 7a9c76e8-31a6-48cf-a7bc-5e6384d278e6
md"Using FiniteDiff.jl to approximate the Jacobian of $g(x) = x_1^2 + 2 x_1 x_2\,$
at $\tilde{x}=(1,2)$, we obtain the correct gradient $\nabla g\big|_\tilde{x} = (6, 2)$:"

# ╔═╡ 39434efc-4638-4660-b871-b27ca8a85474
FiniteDiff.finite_difference_jacobian(g, x̃)

# ╔═╡ 80a19e18-3721-42de-82ea-9e394375d0cb
FiniteDiff.finite_difference_gradient(g, x̃)

# ╔═╡ 1c953bd3-7d70-45ba-aae6-df7a98625093
md"#### FiniteDifferences.jl"

# ╔═╡ e30c170d-fd6d-439f-bb30-b702b0f29502
md"FiniteDifferences.jl requires the definition of a finite difference method (FDM), e.g. the *5th order central method*.
Applying this method to $g$, we obtain the correct gradient:"

# ╔═╡ 33d3d6e5-473c-4599-8335-34b45bc64167
fdm_method = central_fdm(5, 1)

# ╔═╡ 31913258-b867-437c-bc7b-fcdcbf9c1e86
FiniteDifferences.jacobian(fdm_method, g, x̃)

# ╔═╡ 53c3cf1e-61bc-46cb-99b7-3dd8e52a7903
FiniteDifferences.grad(fdm_method, g, x̃)

# ╔═╡ a4e1e575-14d7-4b0b-9f58-1fb34b0e78fd
md"## ForwardDiff.jl
Finally, we will take a look at
[ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl), which implements forward-mode AD using *operator overloading*.
ForwardDiff introduces a *Dual number* type

```julia
struct Dual{T}
    val::T  # value
    der::T  # derivative
end
```
and overloads Julia Base functions such as addition and multiplication on this `Dual` type to implement e.g. the product rule $(uv)'=u'v+uv'$:

```julia
Base.:*(f::Dual, g::Dual) = Dual(f.val * g.val, f.der * g.val + f.val * g.der)
```

Since you are going to learn more about dual numbers in the **homework, where you will implement your own version of ForwardDiff**,
we will skip details and take a look at the API:
"

# ╔═╡ 15a3167e-f9c2-4516-a6fb-e737958fbdfe
md"As expected, for $g(x) = x_1^2 + 2 x_1 x_2\,$ and $\tilde{x}=(1,2)$, we obtain $\nabla g\big|_\tilde{x} = (6, 2)$"

# ╔═╡ bafd8dc3-7666-4d5e-a07f-d4e35b26a777
ForwardDiff.gradient(g, x̃)

# ╔═╡ 8aa5cd8a-ae0d-4c5c-a52b-6c00930b63cc
tip(md"ForwardDiff.jl is considered one of the most stable and reliable Julia AD packages.")

# ╔═╡ ce2d9ef5-3835-4871-8744-18293c772133
md"## Other AD packages
Now that you are equipped with knowledge about AD, take a look at the list of Julia AD packages at [juliadiff.org](https://juliadiff.org)!
"

# ╔═╡ 17a9dab3-46de-4c51-b16b-a0ce367bbcb3
md"""# Acknowledgements
Many thanks to [Niklas Schmitz](https://twitter.com/niklasschmitz_) for many insightful conversations about AD systems and feedback on this lecture.
This lecture wouldn't exist in this form without him.

Further inspiration for this lecture came from
- Prof. Robert Ghrist's [lecture on the chain rule](https://twitter.com/robertghrist/status/1627627577652269056)
- SciML book chapter on [forward-mode AD](https://book.sciml.ai/notes/08-Forward-Mode_Automatic_Differentiation_(AD)_via_High_Dimensional_Algebras/)
- Mike Innes' [Differentiation for Hackers](https://github.com/MikeInnes/diff-zoo),  [rendered here](https://aviatesk.github.io/diff-zoo/dev/)

##### Further references
- Griewand & Walther, *Evaluating Derivatives: Principles and Techniques of Algorithmic Differentiation*
- Spivak, *Calculus on manifolds*
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
FiniteDiff = "6a86dc24-6348-571c-b903-95158fe2bd41"
FiniteDifferences = "26cc04aa-876d-5657-8c51-4c34ba976000"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[compat]
Enzyme = "~0.11.1"
FiniteDiff = "~2.20.0"
FiniteDifferences = "~0.12.26"
ForwardDiff = "~0.10.35"
HypertextLiteral = "~0.9.4"
LaTeXStrings = "~1.3.0"
Plots = "~1.38.10"
PlutoTeachingTools = "~0.2.8"
PlutoUI = "~0.7.50"
Zygote = "~0.6.61"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "b73829ebf3108cf9b4fe384a1b87131476af59c5"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "16b6dbc4cf7caee4e1e75c49485ec67b667098a0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.3.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "c4d9efe93662757bca4cc24df50df5f75e659a2d"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.4.4"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

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

[[deps.ChainRules]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Distributed", "GPUArraysCore", "IrrationalConstants", "LinearAlgebra", "Random", "RealDot", "SparseArrays", "Statistics", "StructArrays"]
git-tree-sha1 = "8bae903893aeeb429cf732cf1888490b93ecf265"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.49.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "485193efd2176b88e6622a39a246f8c5b600e74e"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.6"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "d57c99cc7e637165c81b30eb268eabe156a45c49"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.2.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

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

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "738fec4d684a9a6ee9598a8bfee305b26831f28c"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.2"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "a4ad7ef19d2cdc2eff57abbbe68032b1cd0bd8f8"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.13.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Enzyme]]
deps = ["CEnum", "EnzymeCore", "Enzyme_jll", "GPUCompiler", "LLVM", "Libdl", "LinearAlgebra", "ObjectFile", "Printf", "Random"]
git-tree-sha1 = "4478f8bf24785d9eabe09044549b0e81b9e12d68"
uuid = "7da242da-08ed-463a-9acd-ee780be4f1d9"
version = "0.11.1"

[[deps.EnzymeCore]]
deps = ["Adapt"]
git-tree-sha1 = "d0840cfff51e34729d20fd7d0a13938dc983878b"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.3.0"

[[deps.Enzyme_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "b0f72433c4679db4df05c999f200d60cb78d1a27"
uuid = "7cc45869-7501-5eee-bdea-0790c847d4ef"
version = "0.0.57+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExprTools]]
git-tree-sha1 = "c1d06d129da9f55715c6c212866f5b1bddc5fa00"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.9"

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

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "fc86b4fd3eff76c3ce4f5e96e2fdfa6282722885"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.0.0"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "6604e18a0220650dbbea7854938768f15955dd8e"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.20.0"

[[deps.FiniteDifferences]]
deps = ["ChainRulesCore", "LinearAlgebra", "Printf", "Random", "Richardson", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "3f605dd6db5640c5278f2551afc9427656439f42"
uuid = "26cc04aa-876d-5657-8c51-4c34ba976000"
version = "0.12.26"

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

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "00e252f4d706b3d55a8863432e742bf5717b498d"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.35"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "9ade6983c3dbbd492cf5729f865fe030d1541463"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "8.6.6"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "1cd7f0af1aa58abc02ea1d872953a97359cb87fa"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.4"

[[deps.GPUCompiler]]
deps = ["ExprTools", "InteractiveUtils", "LLVM", "Libdl", "Logging", "Scratch", "TimerOutputs", "UUIDs"]
git-tree-sha1 = "5737dc242dadd392d934ee330c69ceff47f0259c"
uuid = "61eb1bfa-7361-4325-ad38-22787b887f55"
version = "0.19.4"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "0635807d28a496bb60bc15f465da0107fb29649c"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "99e248f643b052a77d2766fe1a16fb32b661afd4"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.0+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[deps.IRTools]]
deps = ["InteractiveUtils", "MacroTools", "Test"]
git-tree-sha1 = "eac00994ce3229a464c2847e956d77a2c64ad3a5"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.10"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "d9ae7a9081d9b1a3b2a5c1d3dac5e2fdaafbd538"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.22"

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

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "26a31cdd9f1f4ea74f649a7bf249703c687a953d"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "5.1.0"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "09b7505cc0b1cee87e5d4a26eea61d2e1b0dcd35"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.21+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

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
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

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

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.ObjectFile]]
deps = ["Reexport", "StructIO"]
git-tree-sha1 = "55ce61d43409b1fb0279d1781bf3b0f22c83ab3b"
uuid = "d8793406-e978-5875-9003-1fc021f44a92"
version = "0.3.7"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "5b3e170ea0724f1e3ed6018c5b006c190f80e87d"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.5"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

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
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "c95373e73290cf50a8a22c3375e4625ded5c5280"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "5434b0ee344eaf2854de251f326df8720f6a7b55"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.10"

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

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "259e206946c293698122f63e2b513a7c99a244e8"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

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

[[deps.Richardson]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "e03ca566bec93f8a3aeb059c8ef102f268a38949"
uuid = "708f8203-808e-40c0-ba2d-98a6953ed40d"
version = "1.4.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "63e84b7fdf5021026d0f17f76af7c57772313d99"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.21"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "521a0e828e98bb69042fec1809c1b5a680eb7389"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.15"

[[deps.StructIO]]
deps = ["Test"]
git-tree-sha1 = "010dc73c7146869c042b49adcdb6bf528c12e859"
uuid = "53d494c1-5632-5724-8f4c-31dff12d585f"
version = "0.3.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

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

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f548a9e9c490030e545f72074a41edfd0e5bcdd7"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.23"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "0b829474fed270a4b0ab07117dce9b9a2fa7581a"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.12"

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

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "GPUArrays", "GPUArraysCore", "IRTools", "InteractiveUtils", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "PrecompileTools", "Random", "Requires", "SparseArrays", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "ebac1ae9f048c669317ad48c9bed815790a468d8"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.6.61"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "977aed5d006b840e2e40c0b48984f7463109046d"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.3"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

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
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╠═755b8685-0711-48a2-a3eb-f80af39f10e1
# ╟─83497498-2c14-49f4-bb5a-c252f655e006
# ╟─96b32c06-6136-4d44-be87-f2f67b374bbd
# ╟─e56dbf8f-e0cb-4696-a8ed-e1e73d9e048b
# ╟─24871322-7513-4b19-a337-90b1d00a1747
# ╟─116c6f7e-eb6c-4c16-a4af-69a22eabd6d0
# ╟─f7347c06-c1b7-11ed-3b8e-fbf167ce9cba
# ╟─3cffee7c-7394-445f-b00d-bb32e5e63783
# ╟─748b0576-7e95-4199-918e-acd6a19adf84
# ╟─0ca06dac-6e62-4ba5-bbe6-89ec8f0e8a26
# ╟─26727cec-1565-4a7d-b19d-1184a3749d4f
# ╟─f2dc6efc-c31d-4191-92a6-fa6cb3ea80f5
# ╟─ae1c7dc7-6e0f-48c7-851b-dc6f0c0ad60e
# ╟─5106b16e-6cae-4b48-a0a7-5aca8eb81245
# ╟─c1f8dc1e-52d4-4172-9e5b-c988d6cadcf7
# ╟─b3e9e95a-cd70-4dfb-b5a3-7d8cbdaabc75
# ╟─78536125-8abc-4dfe-b84e-e22c4c6c19ed
# ╟─68e1e6e9-5e39-4156-9f66-494e16fbe7ca
# ╠═29ab341a-6049-4b68-81f2-6e1562f72d49
# ╟─b4f622c9-18bf-4eec-b5bc-66511c082808
# ╟─e078cb31-46de-43a5-a76a-8504891a870c
# ╟─d4e8f116-62a7-42c8-9288-252e7326bcdd
# ╟─e966986c-d113-43cf-96f5-a89cd7427978
# ╟─430941d0-2f83-4af0-ab48-25d67da3e675
# ╟─7aaa4294-97e7-4708-8047-f34c31bdd0d0
# ╟─1ccfec42-64e7-46d6-abe7-f4dbf84a51ab
# ╟─ff39d133-eff4-4abc-b04e-360832d4dd2a
# ╟─f324744a-aae8-4ee3-9498-9bdab9a942e8
# ╟─8ec1c1c3-5254-4678-8d63-2fa7487057d5
# ╟─ec1bee51-c2b4-47b1-a78a-51d444943787
# ╟─eeef4f94-570a-4b1d-8f23-01dee37124ce
# ╟─0fb53e78-06f9-4e5c-a782-ba8744a70c8d
# ╟─f9699004-6655-4e08-8596-d9067b773d89
# ╟─4afb6a1c-a0ff-4719-828e-4989bf472465
# ╟─34c93a06-58e9-4c61-be87-9ec43a855e9a
# ╟─112a6344-070e-4d1b-b821-65c5723ebb99
# ╟─1b34590a-8754-439c-a5e7-eb96c097f6fd
# ╟─1effbb3e-067b-4166-a39d-efa8e1d38f31
# ╟─9d035fb4-5ae2-4d8e-973c-c72d5cb77a44
# ╟─ab09259f-51d9-47d9-93c8-34af8bbf71f9
# ╟─d89c4e9b-c804-4dec-9add-cab1ff44719b
# ╟─b8867e98-345b-4e6c-9f69-5c081d38aaf7
# ╟─b5dcbc38-d816-41b8-85d4-c0e5a9fefb39
# ╟─53705d41-36dd-4868-9193-8ee80aa94a07
# ╟─cebd8f5c-a72c-436d-a870-a1a64fde16ab
# ╟─c365c5a2-43b7-4ddc-82f1-3ca0670117ba
# ╟─d690349c-b4a1-4310-a237-622e0614a24c
# ╟─98b0ac01-3a8c-4124-b470-7529bd136c0f
# ╠═fd5f0258-8d14-4200-9c49-d88656ec6c75
# ╠═52d897f3-c877-4b92-a482-dd748d404d97
# ╟─344a0531-60fa-436b-bdc5-0aaa98df0463
# ╟─92def6ee-965c-42f9-acd3-176ac6e8c242
# ╟─73d8aa52-b494-44dc-9594-c6e10d741981
# ╟─8ed56f12-a076-4cff-bf7e-8e1e99674f34
# ╟─69b448a1-99a2-4336-bb95-1adb0863943b
# ╟─c9e073b7-038e-4357-b3f0-669c63413387
# ╟─2abcf211-5ffd-464e-8948-83860fe186db
# ╠═32f6945a-d918-4cdc-8c4d-8d3cd898392d
# ╟─3c02c7dc-064e-4b11-8750-e01ac0c090c7
# ╠═effe7e5e-a5e9-472d-ad4a-7ec7a9022b03
# ╠═2037447c-d916-4c13-b620-5d27bf5debe6
# ╠═9218e2f5-722e-4559-b4e6-bb3fcee6e0ea
# ╟─25634d4c-1346-4678-a4c5-84e18a95f8d6
# ╠═b953c179-3802-4ac9-a831-ffeac8e6746a
# ╟─9a71568d-2ebf-4f0f-86f7-71d0d51c0bef
# ╠═9eaa6fd1-d2a6-4603-a7a1-e128e38eeb73
# ╟─7a168cc7-0615-4f1c-8c2d-6d3ad831c2b9
# ╠═665fc505-3ccc-4b1a-b4d5-5124ff08bbe9
# ╟─7fa49c99-fad0-4cbc-9207-940570676906
# ╠═5754ef41-3835-40e3-a879-b071b4e12d5c
# ╟─40bc8112-371b-4401-b393-d4fe0578089e
# ╠═65d5b76b-cfda-4aac-ba54-733f578c6622
# ╟─3de239d4-40e3-42b1-946d-dbc328510d29
# ╠═61ddd27b-2c90-4a6c-a8ad-cf8cf5fa4301
# ╟─8bfa9912-71f2-4eff-a8c5-b6df81b3bf7e
# ╠═5b59b307-c864-4775-95ca-30ea12feb16d
# ╟─b24d757b-cbbb-4ff4-a11d-5bc55320be64
# ╠═6211048c-71a6-488e-a549-b50934823c36
# ╟─520d017e-a94d-4d81-b99c-90714578bd8f
# ╠═86f443be-7a41-49c6-9792-86e6908028a3
# ╟─5aacbeaf-8085-4787-8475-9989881e070b
# ╠═f1a10f5c-d96c-475c-9ef1-90e827b6d670
# ╟─a7396ce9-62bc-4be7-8db3-3801b23f028b
# ╠═faf4aef3-133b-44ef-b4fe-8223de4ca86b
# ╟─67215844-1c32-49eb-8d01-cc8c81f5e37d
# ╟─513990ce-d7e5-4ca6-a079-e0b3197571ee
# ╟─a2c9b337-7381-4d46-9981-5fad6043f76f
# ╠═031bc83b-8754-4586-83c8-08fbcbe80bda
# ╟─4ea887d9-956a-4ca4-96be-be8c4b1ba330
# ╠═14e464f7-d262-4d80-abd3-41d138895673
# ╟─3e2bdfbf-dc0a-40d6-b67c-d97dae8a67f3
# ╠═46646317-7160-4a83-9468-009c12cd6691
# ╟─06f2a81a-97bd-4e03-a470-5c3be869d61c
# ╟─1ec36193-87cc-40a6-8dbf-69ad88c5f034
# ╟─2a166f56-e179-4986-857a-dcd6d577fb6b
# ╟─f5253b44-981e-4fd2-bac8-094238c29ef1
# ╠═44e0dc91-9f2a-4b1b-8ec2-dd6f8209558c
# ╟─7a9c76e8-31a6-48cf-a7bc-5e6384d278e6
# ╠═39434efc-4638-4660-b871-b27ca8a85474
# ╠═80a19e18-3721-42de-82ea-9e394375d0cb
# ╟─1c953bd3-7d70-45ba-aae6-df7a98625093
# ╠═efad4e11-75be-4081-8b32-7ddf600fb82a
# ╟─e30c170d-fd6d-439f-bb30-b702b0f29502
# ╠═33d3d6e5-473c-4599-8335-34b45bc64167
# ╠═31913258-b867-437c-bc7b-fcdcbf9c1e86
# ╠═53c3cf1e-61bc-46cb-99b7-3dd8e52a7903
# ╟─a4e1e575-14d7-4b0b-9f58-1fb34b0e78fd
# ╠═ff9aa2fe-6984-4896-9437-f32ec2f385f7
# ╟─15a3167e-f9c2-4516-a6fb-e737958fbdfe
# ╠═bafd8dc3-7666-4d5e-a07f-d4e35b26a777
# ╟─8aa5cd8a-ae0d-4c5c-a52b-6c00930b63cc
# ╟─ce2d9ef5-3835-4871-8744-18293c772133
# ╟─17a9dab3-46de-4c51-b16b-a0ce367bbcb3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
