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

# ╔═╡ 5cc54371-cf02-429e-b7ce-5fdf2ec8833a
using DifferentiationInterface

# ╔═╡ 8d4fea3c-01c3-4214-a5db-5c7c1c6bdb26
using DifferentiationInterfaceTest

# ╔═╡ 2180b726-4fc8-48cf-ae15-1c9caac44327
html"""<style>.dont-panic{ display: none }</style>"""

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
		Julia for Machine Learning
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
			TU Berlin, Summer Semester 2025
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
Linear maps, also called linear transformations (*lineare Abbildungen* in German) are functions $f$ with the following properties:

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

we obtain the $i$-th column in the Jacobian

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
Enzyme is highly performant and supports mutating functions.

Since the package is under rapid development and the API hasn't fully stabilized, note that this example uses Enzyme `v0.13`:
"""

# ╔═╡ 27d23099-202d-4224-8a8d-0020138235f3
pkgversion(Enzyme)

# ╔═╡ 4ea887d9-956a-4ca4-96be-be8c4b1ba330
md"For $\tilde{x}=(1,2)$ and

$g(x) = x_1^2 + 2 x_1 x_2 \quad ,$

we can use both reverse- and forward-mode AD to correctly compute the gradient $\nabla g\big|_\tilde{x} = (6, 2)$:"

# ╔═╡ 775bffca-9e9c-4188-b66d-78a50423377c
Enzyme.gradient(Reverse, g, x̃)

# ╔═╡ 2ce5077b-0955-4dd7-a11f-15c0771ad6ac
Enzyme.gradient(Forward, g, x̃)

# ╔═╡ 7491ba26-70dd-42af-8e1f-4b15cabb8844
Enzyme.jacobian(Forward, g, x̃)

# ╔═╡ c79fb7fc-653e-4f26-aa36-f7c2d8c65016
md"### Low-level API
Enzyme also exports `autodiff`, a lower-level API for VJPs and JVPs.
This function is a bit more advanced as it puts the user in control of allocations to maximize performance.

Enzyme's `autodiff` can be used with reverse-mode AD"

# ╔═╡ 14e464f7-d262-4d80-abd3-41d138895673
begin
    # Allocate array grad_rev for gradient
    grad_rev = similar(x̃)

    # Mutate grad_rev in place
    out_rev = Enzyme.autodiff(ReverseWithPrimal, g, Active, Duplicated(x̃, grad_rev))

    @info out_rev # contains primal output y = g(x̃)
    @info grad_rev
end

# ╔═╡ 334494c9-47d2-4679-bbde-5d629c5c7b1f
md"and forward-mode AD"

# ╔═╡ 46646317-7160-4a83-9468-009c12cd6691
begin
    v = ([1.0, 0.0], [0.0, 1.0]) # standard basis vectors e₁, e₂

    out_fwd = Enzyme.autodiff(Forward, g, BatchDuplicated, BatchDuplicated(x̃, v))

    @info out_fwd # contains primal output and gradient
end

# ╔═╡ 451a3386-064d-430a-8a0e-97b135d76f4b
tip(md"Since Enzyme differentiates at the LLVM level,
it can differentiate any LLVM-based language, e.g. C, C++, Swift, Julia and Rust.
More information can be found on the [Enzyme website](https://enzyme.mit.edu).
")

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

# ╔═╡ fd3e13e2-4417-446c-80b8-bacb71c03c6f
md"## DifferentiationInterface.jl
We just used five different packages with slightly different syntax and slightly different return types to compute a gradient.
Wouldn't it be great to have a common interface for all of these?

That's exactly what [DifferentiationInterface.jl](https://github.com/gdalle/DifferentiationInterface.jl) does:
"

# ╔═╡ c5bf7616-031d-401d-9f5d-ec45be67ad98
value_and_gradient(g, AutoZygote(), x̃)

# ╔═╡ 73887f4b-bcef-4ea5-b1e8-51dbd7c6f90f
value_and_gradient(g, AutoEnzyme(), x̃)

# ╔═╡ 05cbfe8c-7a5b-4469-9d5e-fd21e9c82bc6
value_and_gradient(g, AutoFiniteDiff(), x̃)

# ╔═╡ 7d97d2e2-4a55-419c-b864-7aaa2b9aeffa
value_and_gradient(g, AutoFiniteDifferences(; fdm=fdm_method), x̃)

# ╔═╡ f633c51b-1727-4d42-89d0-d5ef0f77506c
value_and_gradient(g, AutoForwardDiff(), x̃)

# ╔═╡ b35399ab-6ea9-4043-85fe-02ca0c63dd77
tip(md"As one of the authors, I am not neutral, but I recommend using all backends via DifferentiationInterface!")

# ╔═╡ b683a585-899e-4922-8164-732318248aa2
md"Features include:
- All the [first- and second-order operators](https://gdalle.github.io/DifferentiationInterface.jl/DifferentiationInterface/stable/explanation/operators/) you could ever want (gradients, Jacobians, Hessians...)
- In-place and out-of-place differentiation
- Preparation mechanisms (e.g. to pre-allocate a cache or record a tape)
- Built-in [sparsity handling](https://gdalle.github.io/DifferentiationInterface.jl/DifferentiationInterface/stable/explanation/advanced/#Sparsity)
- Testing and benchmarking utilities accessible via [DifferentiationInterfaceTest](https://github.com/gdalle/DifferentiationInterface.jl/tree/main/DifferentiationInterfaceTest)
"

# ╔═╡ d095e890-9ac8-4b05-ad98-3f8237402347
md"## DifferentiationInterfaceTest.jl
Let's use DifferentiationInterfaceTest to find out which AD backend is the most performant for our function `g`. 

We're interested in the `:gradient` operator, more specifically the `:out` of place version. 
We pass the function `g`, `x̃` and the first-order result:
"

# ╔═╡ 79f497bc-6f6c-49fe-8ff9-0cd3eb13000a
scenarios = [
	Scenario{:gradient,:out}(g, x̃; res1=[6.0, 2.0]),
]

# ╔═╡ 058d65c5-0c73-47c7-ab4e-bf3d5825f44a
backends = [
	AutoZygote(),
	AutoEnzyme(),
	AutoFiniteDiff(),
	AutoFiniteDifferences(; fdm=fdm_method), # some backends require configuration
	AutoForwardDiff(),
]

# ╔═╡ d7ef288b-590d-4b1b-a3f5-296b732166ed
md"Calling `benchmark_differentiation` gives us benchmark results for all backends in a useful `DataFrame`:"

# ╔═╡ eed69a85-2db6-42a9-9530-0e44d4848ba0
benchmark_differentiation(backends, scenarios)

# ╔═╡ 412d720f-ca38-4781-ae25-a6cebf32cae9
md"We can also use DifferentiationInterfaceTest.jl when developing our own Julia package:"

# ╔═╡ 104d6880-428e-4389-9a84-249cece8e8be
test_differentiation(
   backends,              # backends you want to test on
   scenarios,             # scenarios you want to test on
   correctness=true,      # compare values against the reference
   type_stability=:none,  # check type stability with JET.jl
   detailed=true,         # print a detailed test set
)

# ╔═╡ 65181eeb-f72c-47b2-9260-f6cf1de4760f
md"In this example, all tests passed, which is also the reason we were able to benchmark all backends.
You will learn more on [package testing](https://adrianhill.de/julia-ml-course/test/) during your project work.
"

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
DifferentiationInterface = "a0c0ee7d-e4b9-4e03-894e-1c5f64a51d63"
DifferentiationInterfaceTest = "a82114a7-5aa3-49a8-9643-716bb13727a3"
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
DifferentiationInterface = "~0.6.50"
DifferentiationInterfaceTest = "~0.9.6"
Enzyme = "~0.13.35"
FiniteDiff = "~2.27.0"
FiniteDifferences = "~0.12.32"
ForwardDiff = "~1.0.0"
HypertextLiteral = "~0.9.5"
LaTeXStrings = "~1.4.0"
Plots = "~1.40.11"
PlutoTeachingTools = "~0.3.1"
PlutoUI = "~0.7.62"
Zygote = "~0.7.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "9bb3e885d30617e2db8d966a11b388306f861e8b"

[[deps.ADTypes]]
git-tree-sha1 = "e2478490447631aedba0823d4d7a80b2cc8cdb32"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "1.14.0"
weakdeps = ["ChainRulesCore", "ConstructionBase", "EnzymeCore"]

    [deps.ADTypes.extensions]
    ADTypesChainRulesCoreExt = "ChainRulesCore"
    ADTypesConstructionBaseExt = "ConstructionBase"
    ADTypesEnzymeCoreExt = "EnzymeCore"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "f7817e2e585aa6d924fd714df1e2a84be7896c60"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.3.0"
weakdeps = ["SparseArrays", "StaticArrays"]

    [deps.Adapt.extensions]
    AdaptSparseArraysExt = "SparseArrays"
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.AllocCheck]]
deps = ["ExprTools", "GPUCompiler", "LLVM", "MacroTools"]
git-tree-sha1 = "7e53c22135cd9a3d91e6c56e2e962106dc3d57f2"
uuid = "9b6a8646-10ed-4001-bbdc-1d2f46dfbb1a"
version = "0.2.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra"]
git-tree-sha1 = "017fcb757f8e921fb44ee063a7aafe5f89b86dd1"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.18.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesCoreExt = "ChainRulesCore"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceSparseArraysExt = "SparseArrays"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "2ac646d71d0d24b44f3f8c84da8c9f4d70fb67df"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.4+0"

[[deps.ChainRules]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Distributed", "GPUArraysCore", "IrrationalConstants", "LinearAlgebra", "Random", "RealDot", "SparseArrays", "SparseInverseSubset", "Statistics", "StructArrays", "SuiteSparse"]
git-tree-sha1 = "a975ae558af61a2a48720a6271661bf2621e0f4e"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.72.3"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "1713c74e00545bfe14605d2a2be1712de8fbcb58"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.25.1"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.Chairmarks]]
deps = ["Printf", "Random"]
git-tree-sha1 = "9a49491e67e7a4d6f885c43d00bb101e6e5a434b"
uuid = "0ca39b1e-fe0b-4e98-acfc-b1656634c4de"
version = "1.3.1"
weakdeps = ["Statistics"]

    [deps.Chairmarks.extensions]
    StatisticsChairmarksExt = ["Statistics"]

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

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

[[deps.CommonSubexpressions]]
deps = ["MacroTools"]
git-tree-sha1 = "cda2cfaebb4be89c9084adaca7dd7333369715c5"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.1"

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

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[deps.ConstructionBase]]
git-tree-sha1 = "76219f1ed5771adbb096743bff43fb5fdd4c1157"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.8"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "fb61b4812c49343d7ef0b533ba982c46021938a6"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.7.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fc173b380865f70627d7dd1190dc2fce6cc105af"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.14.10+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DifferentiationInterface]]
deps = ["ADTypes", "LinearAlgebra"]
git-tree-sha1 = "70e500f6d5d50091d87859251de7b8cd060c1cce"
uuid = "a0c0ee7d-e4b9-4e03-894e-1c5f64a51d63"
version = "0.6.50"

    [deps.DifferentiationInterface.extensions]
    DifferentiationInterfaceChainRulesCoreExt = "ChainRulesCore"
    DifferentiationInterfaceDiffractorExt = "Diffractor"
    DifferentiationInterfaceEnzymeExt = ["EnzymeCore", "Enzyme"]
    DifferentiationInterfaceFastDifferentiationExt = "FastDifferentiation"
    DifferentiationInterfaceFiniteDiffExt = "FiniteDiff"
    DifferentiationInterfaceFiniteDifferencesExt = "FiniteDifferences"
    DifferentiationInterfaceForwardDiffExt = ["ForwardDiff", "DiffResults"]
    DifferentiationInterfaceGTPSAExt = "GTPSA"
    DifferentiationInterfaceMooncakeExt = "Mooncake"
    DifferentiationInterfacePolyesterForwardDiffExt = ["PolyesterForwardDiff", "ForwardDiff", "DiffResults"]
    DifferentiationInterfaceReverseDiffExt = ["ReverseDiff", "DiffResults"]
    DifferentiationInterfaceSparseArraysExt = "SparseArrays"
    DifferentiationInterfaceSparseConnectivityTracerExt = "SparseConnectivityTracer"
    DifferentiationInterfaceSparseMatrixColoringsExt = "SparseMatrixColorings"
    DifferentiationInterfaceStaticArraysExt = "StaticArrays"
    DifferentiationInterfaceSymbolicsExt = "Symbolics"
    DifferentiationInterfaceTrackerExt = "Tracker"
    DifferentiationInterfaceZygoteExt = ["Zygote", "ForwardDiff"]

    [deps.DifferentiationInterface.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DiffResults = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
    Diffractor = "9f5e2b26-1114-432f-b630-d3fe2085c51c"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    FastDifferentiation = "eb9bf01b-bf85-4b60-bf87-ee5de06c00be"
    FiniteDiff = "6a86dc24-6348-571c-b903-95158fe2bd41"
    FiniteDifferences = "26cc04aa-876d-5657-8c51-4c34ba976000"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    GTPSA = "b27dd330-f138-47c5-815b-40db9dd9b6e8"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    PolyesterForwardDiff = "98d1487c-24ca-40b6-b7ab-df2af84e126b"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SparseConnectivityTracer = "9f842d2f-2579-4b1d-911e-f412cf18a3f5"
    SparseMatrixColorings = "0a514795-09f3-496d-8182-132a7b665d35"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.DifferentiationInterfaceTest]]
deps = ["ADTypes", "AllocCheck", "Chairmarks", "DataFrames", "DifferentiationInterface", "DocStringExtensions", "JET", "LinearAlgebra", "ProgressMeter", "Random", "SparseArrays", "Statistics", "Test"]
git-tree-sha1 = "121538474e85f72dc40de8f88c26d832c3ae3e02"
uuid = "a82114a7-5aa3-49a8-9643-716bb13727a3"
version = "0.9.6"

    [deps.DifferentiationInterfaceTest.extensions]
    DifferentiationInterfaceTestComponentArraysExt = "ComponentArrays"
    DifferentiationInterfaceTestFluxExt = ["FiniteDifferences", "Flux", "Functors"]
    DifferentiationInterfaceTestJLArraysExt = "JLArrays"
    DifferentiationInterfaceTestLuxExt = ["ComponentArrays", "ForwardDiff", "Lux", "LuxTestUtils"]
    DifferentiationInterfaceTestStaticArraysExt = "StaticArrays"

    [deps.DifferentiationInterfaceTest.weakdeps]
    ComponentArrays = "b0b7db55-cfe3-40fc-9ded-d10e2dbeff66"
    FiniteDifferences = "26cc04aa-876d-5657-8c51-4c34ba976000"
    Flux = "587475ba-b771-5e3f-ad9e-33799f191a9c"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Functors = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
    JLArrays = "27aeb0d3-9eb9-45fb-866b-73c2ecf80fcb"
    Lux = "b2108857-7c20-44ae-9111-449ecde12c47"
    LuxTestUtils = "ac9de150-d08f-4546-94fb-7472b5760531"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Enzyme]]
deps = ["CEnum", "EnzymeCore", "Enzyme_jll", "GPUCompiler", "LLVM", "Libdl", "LinearAlgebra", "ObjectFile", "PrecompileTools", "Preferences", "Printf", "Random", "SparseArrays"]
git-tree-sha1 = "59c1db6e150d55f2df6a1383759931bf8571c6b8"
uuid = "7da242da-08ed-463a-9acd-ee780be4f1d9"
version = "0.13.35"

    [deps.Enzyme.extensions]
    EnzymeBFloat16sExt = "BFloat16s"
    EnzymeChainRulesCoreExt = "ChainRulesCore"
    EnzymeGPUArraysCoreExt = "GPUArraysCore"
    EnzymeLogExpFunctionsExt = "LogExpFunctions"
    EnzymeSpecialFunctionsExt = "SpecialFunctions"
    EnzymeStaticArraysExt = "StaticArrays"

    [deps.Enzyme.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    LogExpFunctions = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.EnzymeCore]]
git-tree-sha1 = "0cdb7af5c39e92d78a0ee8d0a447d32f7593137e"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.8.8"
weakdeps = ["Adapt"]

    [deps.EnzymeCore.extensions]
    AdaptExt = "Adapt"

[[deps.Enzyme_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "c29af735ddb2381732cdf5dd72fc32069315619d"
uuid = "7cc45869-7501-5eee-bdea-0790c847d4ef"
version = "0.0.173+0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d55dffd9ae73ff72f1c0482454dcf2ec6c6c4a63"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.5+0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

    [deps.FillArrays.weakdeps]
    PDMats = "90014a1f-27ba-587c-ab20-58faa44d9150"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Setfield"]
git-tree-sha1 = "f089ab1f834470c525562030c8cfde4025d5e915"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.27.0"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffSparseArraysExt = "SparseArrays"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FiniteDifferences]]
deps = ["ChainRulesCore", "LinearAlgebra", "Printf", "Random", "Richardson", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "06d76c780d657729cf20821fb5832c6cc4dfd0b5"
uuid = "26cc04aa-876d-5657-8c51-4c34ba976000"
version = "0.12.32"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "21fac3c77d7b5a9fc03b0ec503aa1a6392c34d2b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.15.0+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "f4244ab887f376f8a075b1b2097589e62ee667db"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "1.0.0"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "2c5512e11c791d1baed2049c5652441b28fc6a31"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "846f7026a9decf3679419122b49f8a1fdb48d2d5"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.16+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "83cf05ab16a73219e5f6bd1bdfa9848fa24ac627"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.2.0"

[[deps.GPUCompiler]]
deps = ["ExprTools", "InteractiveUtils", "LLVM", "Libdl", "Logging", "PrecompileTools", "Preferences", "Scratch", "Serialization", "TOML", "TimerOutputs", "UUIDs"]
git-tree-sha1 = "b08c164134dd0dbc76ff54e45e016cf7f30e16a4"
uuid = "61eb1bfa-7361-4325-ad38-22787b887f55"
version = "1.3.2"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "0ff136326605f8e06e9bcf085a356ab312eef18a"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.13"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "9cb62849057df859575fc1dda1e91b82f8609709"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.13+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "b0036b392358c80d2d2124746c2bf3d48d457938"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.82.4+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "01979f9b37367603e2848ea225918a3b3861b606"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "c67b33b085f6e2faf8bf79a61962e7339a81129c"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.15"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "55c53be97790242c29031e5cd45e8ac296dadda3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.0+0"

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

[[deps.IRTools]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "950c3717af761bc3ff906c2e8e52bd83390b6ec2"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.14"

[[deps.InlineStrings]]
git-tree-sha1 = "6a9fde685a7ac1eb3495f8e812c5a7c3711c2d5e"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.3"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.InvertedIndices]]
git-tree-sha1 = "6da3c4316095de0f5ee2ebd875df8721e7e0bdbe"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.1"

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JET]]
deps = ["CodeTracking", "InteractiveUtils", "JuliaInterpreter", "JuliaSyntax", "LoweredCodeUtils", "MacroTools", "Pkg", "PrecompileTools", "Preferences", "Test"]
git-tree-sha1 = "a453c9b3320dd73f5b05e8882446b6051cb254c4"
uuid = "c3a54625-cd67-489e-a8e7-0a5a0ff4e31b"
version = "0.9.18"

    [deps.JET.extensions]
    JETCthulhuExt = "Cthulhu"
    JETReviseExt = "Revise"

    [deps.JET.weakdeps]
    Cthulhu = "f68482b8-f384-11e8-15f7-abe071a5a75f"
    Revise = "295af30f-e4ad-537b-8983-00126c2a3abe"

[[deps.JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "1d4015b1eb6dc3be7e6c400fbd8042fe825a6bac"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.10"

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

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "a434e811d10e7cbf4f0674285542e697dca605d0"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.42"

[[deps.JuliaSyntax]]
git-tree-sha1 = "937da4713526b96ac9a178e2035019d3b78ead4a"
uuid = "70703baa-626e-46a2-a12c-08ffd08c73b4"
version = "0.4.10"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Preferences", "Printf", "Unicode"]
git-tree-sha1 = "5fcfea6df2ff3e4da708a40c969c3812162346df"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "9.2.0"

    [deps.LLVM.extensions]
    BFloat16sExt = "BFloat16s"

    [deps.LLVM.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "4b5ad6a4ffa91a00050a964492bc4f86bb48cea0"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.35+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

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

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "27ecae93dd25ee0909666e6835051dd684cc035e"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+2"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "8be878062e0ffa2c3f67bb58a595375eda5de80b"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.11.0+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "ff3b4b9d35de638936a525ecd36e86a8bb919d11"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "df37206100d39f79b3376afb6b9cee4970041c61"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.51.1+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "89211ea35d9df5831fca5d33552c02bd33878419"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.3+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e888ad02ce716b319e6bdb985d2ef300e7089889"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.3+0"

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

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

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

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

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

[[deps.ObjectFile]]
deps = ["Reexport", "StructIO"]
git-tree-sha1 = "09b1fe6ff16e6587fa240c165347474322e77cf1"
uuid = "d8793406-e978-5875-9003-1fc021f44a92"
version = "0.4.4"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+4"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a9697f1d06cc3eb3fb3ad49cc67f2cfabaac31ea"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.16+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3b31172c032a1def20c98dae3f2cdc9d10e3b561"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.1+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "24be21541580495368c35a6ccef1454e7b5015be"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.11"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

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

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "1101cd475833706e4d0e7b122218257178f48f34"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "8f6bc219586aef8baf0ff9a5fe16ee9c70cb65e4"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.2"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "e5dd466bf2569fe08c91a2cc29c1003f4797ac3b"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.7.1+2"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "1a180aeced866700d4bebc3120ea1451201f16bc"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.7.1+1"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "729927532d48cf79f49070341e1d918a65aba6b0"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.7.1+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

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

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

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
weakdeps = ["Distributed"]

    [deps.Revise.extensions]
    DistributedExt = "Distributed"

[[deps.Richardson]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "48f038bfd83344065434089c2a79417f38715c41"
uuid = "708f8203-808e-40c0-ba2d-98a6953ed40d"
version = "1.4.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "712fb0231ee6f9120e005ccd56297abbc053e7e0"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.8"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "c5391c6ace3bc430ca630251d02ea9687169ca68"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.2"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

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

[[deps.SparseInverseSubset]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "52962839426b75b3021296f7df242e40ecfc0852"
uuid = "dc90abb0-5640-4711-901d-7e5b23a2fada"
version = "0.1.2"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "64cca0c26b4f31ba18f13f6c12af7c85f478cfde"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.5.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "83e6cce8324d49dfaf9ef059227f91ed4441a8e5"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.2"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "0feb6b9031bd5c51f9072393eb5ab3efd31bf9e4"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.13"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

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

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "725421ae8e530ec29bcbdddbe91ff8053421d023"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.4.1"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "5a3a31c41e15a1e042d60f2f4942adccba05d3c9"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.7.0"

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = ["GPUArraysCore", "KernelAbstractions"]
    StructArraysLinearAlgebraExt = "LinearAlgebra"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

    [deps.StructArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.StructIO]]
git-tree-sha1 = "c581be48ae1cbf83e899b14c07a807e1787512cc"
uuid = "53d494c1-5632-5724-8f4c-31dff12d585f"
version = "0.3.1"

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

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

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

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f57facfd1be61c42321765d3551b3df50f7e09f6"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.28"

    [deps.TimerOutputs.extensions]
    FlameGraphsExt = "FlameGraphs"

    [deps.TimerOutputs.weakdeps]
    FlameGraphs = "08572546-2f56-4bcf-ba4e-bab62c3a3f89"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

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

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c0667a8e676c53d390a09dc6870b3d8d6650e2bf"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "85c7811eddec9e7f22615371c3cc81a504c508ee"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+2"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "5db3e9d307d32baba7067b13fc7b5aa6edd4a19a"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.36.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "b8b243e47228b4a3877f1dd6aee0c5d56db7fcf4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.6+1"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "7d1671acbe47ac88e981868a078bd6b4e27c5191"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.42+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "56c6604ec8b2d82cc4cfe01aa03b00426aac7e1f"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.6.4+1"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "9dafcee1d24c4f024e7edc92603cedba72118283"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+3"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e9216fdcd8514b7072b43653874fd688e4c6c003"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.12+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "807c226eaf3651e7b2c468f687ac788291f9a89b"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.3+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "89799ae67c17caa5b3b5a19b8469eeee474377db"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.5+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d7155fea91a4123ef59f42c4afb5ab3b4ca95058"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+3"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "6fcc21d5aea1a0b7cce6cab3e62246abd1949b86"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.0+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "984b313b049c89739075b8e2a94407076de17449"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.2+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "a1a7eaf6c3b5b05cb903e35e8372049b107ac729"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.5+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "b6f664b7b2f6a39689d822a6300b14df4668f0f4"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.4+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a490c6212a0e90d2d55111ac956f7c4fa9c277a6"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+1"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c57201109a9e4c0585b208bb408bc41d205ac4e9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.2+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "1a74296303b6524a0472a8cb12d3d87a78eb3612"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "dbc53e4cf7701c6c7047c51e17d6e64df55dca94"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+1"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
git-tree-sha1 = "ab2221d309eda71020cdda67a973aa582aa85d69"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+1"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6dba04dbfb72ae3ebe5418ba33d087ba8aa8cb00"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.1+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "GPUArraysCore", "IRTools", "InteractiveUtils", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "PrecompileTools", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "207d714f3514b0d564e3a08f9e9f753bf6566c2d"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.7.6"

    [deps.Zygote.extensions]
    ZygoteAtomExt = "Atom"
    ZygoteColorsExt = "Colors"
    ZygoteDistancesExt = "Distances"
    ZygoteTrackerExt = "Tracker"

    [deps.Zygote.weakdeps]
    Atom = "c52e3926-4ff0-5f6e-af25-54175e0327b1"
    Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
    Distances = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "434b3de333c75fc446aa0d19fc394edafd07ab08"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.7"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6e50f145003024df4f5cb96c7fce79466741d601"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.56.3+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0ba42241cb6809f1a278d0bcb976e0483c3f1f2d"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+1"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522c1df09d05a71785765d19c9524661234738e9"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.11.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "068dfe202b0a05b8332f1e8e6b4080684b9c7700"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.47+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

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
git-tree-sha1 = "63406453ed9b33a0df95d570816d5366c92b7809"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+2"
"""

# ╔═╡ Cell order:
# ╟─2180b726-4fc8-48cf-ae15-1c9caac44327
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
# ╠═27d23099-202d-4224-8a8d-0020138235f3
# ╟─4ea887d9-956a-4ca4-96be-be8c4b1ba330
# ╠═775bffca-9e9c-4188-b66d-78a50423377c
# ╠═2ce5077b-0955-4dd7-a11f-15c0771ad6ac
# ╠═7491ba26-70dd-42af-8e1f-4b15cabb8844
# ╟─c79fb7fc-653e-4f26-aa36-f7c2d8c65016
# ╠═14e464f7-d262-4d80-abd3-41d138895673
# ╟─334494c9-47d2-4679-bbde-5d629c5c7b1f
# ╠═46646317-7160-4a83-9468-009c12cd6691
# ╟─451a3386-064d-430a-8a0e-97b135d76f4b
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
# ╟─fd3e13e2-4417-446c-80b8-bacb71c03c6f
# ╠═5cc54371-cf02-429e-b7ce-5fdf2ec8833a
# ╠═c5bf7616-031d-401d-9f5d-ec45be67ad98
# ╠═73887f4b-bcef-4ea5-b1e8-51dbd7c6f90f
# ╠═05cbfe8c-7a5b-4469-9d5e-fd21e9c82bc6
# ╠═7d97d2e2-4a55-419c-b864-7aaa2b9aeffa
# ╠═f633c51b-1727-4d42-89d0-d5ef0f77506c
# ╟─b35399ab-6ea9-4043-85fe-02ca0c63dd77
# ╟─b683a585-899e-4922-8164-732318248aa2
# ╟─d095e890-9ac8-4b05-ad98-3f8237402347
# ╠═8d4fea3c-01c3-4214-a5db-5c7c1c6bdb26
# ╠═79f497bc-6f6c-49fe-8ff9-0cd3eb13000a
# ╠═058d65c5-0c73-47c7-ab4e-bf3d5825f44a
# ╟─d7ef288b-590d-4b1b-a3f5-296b732166ed
# ╠═eed69a85-2db6-42a9-9530-0e44d4848ba0
# ╟─412d720f-ca38-4781-ae25-a6cebf32cae9
# ╠═104d6880-428e-4389-9a84-249cece8e8be
# ╟─65181eeb-f72c-47b2-9260-f6cf1de4760f
# ╟─ce2d9ef5-3835-4871-8744-18293c772133
# ╟─17a9dab3-46de-4c51-b16b-a0ce367bbcb3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
