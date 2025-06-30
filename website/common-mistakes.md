@def title = "Julia for Machine Learning"
@def tags = ["index", "common mistakes"]

# Common Mistakes 

This page contains a short summary of common mistakes (⚠️), opinionated style suggestions (🧹) and miscellaneous tips (💡).
Keep in mind that all rules are meant to be broken in the right context!

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents


## Dependencies

### ⚠️ Remove unused dependencies

Dependencies like `Test.jl` and `Revise.jl` don't belong in the main `Project.toml`.

Refer to [_Environments_](/environments) and [_Enhancing the REPL_](/repl) respectively.

### 🧹 Use explicit imports

Explicitly import only the function you need from your dependencies.

```julia
# ❌ BAD:
using LinearAlgebra # import all of LinearAlgebra just to use `cholesky` and `det`

# ✅ GOOD:
using LinearAlgebra: cholesky, det # import only `cholesky` and `det`
```

Refer to [_Writing a Julia Package: Organizing dependencies, source files and exports_](/write/#organizing_dependencies_source_files_and_exports).
Advanced developers can test for this using [ExplicitImports.jl](https://github.com/JuliaTesting/ExplicitImports.jl).

### 🧹 Keep imports and exports in main file

Keep imports and exports in one place.
```julia
# ✅ GOOD:
module MyPackage

# 1.) Explicitly import the functions you need from your dependencies
using LinearAlgebra: cholesky, det

# 2.) Include source files
include("timestwo.jl")
include("timesthree.jl")

# 3.) Export functions you defined
export timestwo, timesthree

end # end module
```

Refer to [_Writing a Julia Package: Organizing dependencies, source files and exports_](/write/#organizing_dependencies_source_files_and_exports).

### 🧹 Avoid submodules

Julia programmers tend to not use use submodules for individual source files, unless necessary.

## Types

### 🧹 Avoid overly strict struct fields

There is rarely a reason to restrict field types to something more concrete than `Number`, `Real`, `AbstractFloat` or `Integer`.

```julia
# ❌ Restrictive:
struct MyComplexRestrictive
    x::Float32
    y::Float32
end

# ✅ Flexible:
struct MyComplex{T<:Real}
    x::T
    y::T
end
```

```julia
# ❌ Restrictive:
struct MyMatrixRestrictive
    mat::Matrix{Float32}
end

# ✅ Flexible:
struct MyMatrix{T<:Real}
    mat::Matrix{T}
end

# or even:
struct MyMatrix2{T<:Real,A<:AbstractMatrix{T}}
    mat::A
end
```

### ⚠️ Avoid mutable structs

Mutable struct are less performant than regular (non-mutable) structs, since they are generally allocated on the heap.
It is therefore often more performant to simply return a new struct.

```julia
# ❌ USUALLY BAD:
mutable struct PointMutable{T<:Real}
    x::T
    y::T
end
 
# ❌ Mutate field of point:
function addx_bad!(pt::PointMutable, x) 
    pt.x += x
    return pt
end

# ✅ GOOD:
struct PointGood{T<:Real}
    x::T
    y::T
end

# ✅ Simply create new immutable point
addx_good(pt::PointGood, x) = PointGood(pt.x + x, pt.y)
```

Refer to the section on _Mutable types_ in [_Lecture 4: Custom Types_](/L4_Basics_3/).


### ⚠️ Avoid structs with untyped fields

Julia can't infer types from structs with untyped fields, which will result in bad performance.
Use parametric types instead.

```julia
# ❌ BAD:
struct MyTypeBad
    x
end

# ✅ GOOD:
struct MyType{T}
    x::T
end
```

```julia
# ❌ BAD:
struct AnotherTypeBad{X}
    x::X
    y
end

# ✅ GOOD:
struct AnotherType{X,Y}
    x::X
    y::Y
end
```

Refer to the section _Performance_ in [_Lecture 4: Custom Types_](/L4_Basics_3/).

### 🧹 Avoid overly strict type annotations

Restrictive types usually remove functionality instead adding it.
If needed, use generic types like `Number`, `Real`, `AbstractFloat` or `Integer`.

```julia
# ❌ Restrictive:
timestwo(x::Float32) = 2 * x

# ✅ Flexible:
timestwo(x) = 2 * x
```

For arrays, use `AbstractArray`, `AbstractMatrix`, `AbstractVector`.
To prohibit array types that don't use 1-based indexing, call `Base.require_one_based_indexing` within your function.

```julia
# ❌ Restrictive:
sumrows(A::Matrix{Float64}) = sum(eachrow(A))

# A bit more flexible:
sumrows(A::Matrix{<:Real}) = sum(eachrow(A))

# ✅ Flexible:
sumrows(A::AbstractMatrix) = sum(eachrow(A))

# or lightly restrict element-type while keeping array-type flexible:
sumrows(A::AbstractMatrix{T}) where {T<:Real} = sum(eachrow(A))
```
### ⚠️ Avoid type instabilities

Type instabilities are discussed in [_Profiling: Type stabilty_](profiling/#type_stability)
and should be avoided, as they have a strong negative effect on performance.
However, type stability is not mandatory for the project work in this course.

For advanced developers (besides profiling), type instabilities can be uncovered using [JET.jl](https://github.com/aviatesk/JET.jl).

### ⚠️ Avoid output type annotations

If your code is type stable (see previous point), Julia will be able to infer output types without annotations.
Output type annotations can hurt performance by causing allocations via unwanted type conversions.  

```julia
# ❌ BAD: return type annotation is abstract
sumrows(A::AbstractMatrix)::AbstractVector = sum(eachrow(A))

# ❌ BAD: return type annotation is too specific.
# This will likely cause an unwanted and slow type conversion.
sumrows(A::AbstractMatrix)::Vector{Float32} = sum(eachrow(A))

# ✅ GOOD: Just let Julia figure it out
sumrows(A::AbstractMatrix) = sum(eachrow(A))
```

### ⚠️ Avoid accidental type promotions

Floating point numbers like `1.0` are of type `Float64`.
Multiplying an array of `Float32` by such a number will promote the output to an array of `Float64`.

The functions `typeof`, `eltype`, `one(T)`, `zero(T)` and `convert(T, x)` function are your friends.

```julia
# ❌ BAD:
function example_bad(A::AbstractArray)
    return 1 / sqrt(2) * A
end

# ✅ GOOD:
function example_good(A::AbstractArray)
    T = eltype(A)
    scale = convert(T, 1 / sqrt(2))
    return scale * A
end
```

## Code

### ⚠️ Don't assume 1-based indexing

We can't assume all arrays to use 1-based indexing (see e.g. [OffsetArrays.jl](https://github.com/JuliaArrays/OffsetArrays.jl)).
Use iterators like `eachrow`, `eachcol`, `eachslice` and `eachindex` when possible.
Otherwise, call `Base.require_one_based_indexing`.

Refer to the section _Iterating over arrays_ in [_Lecture 2: Arrays & Linear Algebra_](/L2_Basics_2/).

### 🧹 Avoid strings for configuration

In Python, it is common to configure functions via string arguments.
A 1-to-1 translation of this design pattern might look as follows:
```julia
# ❌ BAD:
function solve_bad(data, algorithm="default")
    if algorithm == "default"
        solve_default(data)
    elseif algorithm == "special"
        solve_special(data)
    else
        error("Unknown algorithm $algorithm")
    end
end    
```

In Julia, it is more idiomatic to introduce types and use multiple dispatch:

```julia
# ✅ GOOD:
abstract type AbstractSolver end

# Solver without arguments:
struct DefaultSolver <: AbstractSolver end

# Solver with arguments:
struct SpecialSolver <: AbstractSolver
    some_parameter::Int
    another_parameter::Bool
end

myfunction(data) = myfunction(data, DefaultSolver())
myfunction(data, algorithm::DefaultSolver) = myfunction_default(data)
myfunction(data, algorithm::SpecialSolver) = myfunction_special(data, algorithm) # pass arguments
myfunction(data, algorithm) = error("Unknown algorithm $algorithm")
```

(If for some reason, you want to avoid introducing types, at least use symbols (`:default`, `:special`) instead of strings (`"default"`, `"special"`).)

### 💡 Loops are perfectly fine

In NumPy and MATLAB, code is commonly vectorized.
This is done to internally run for-loops in C/C++ code instead of the much slower Python and MATLAB.
In Julia, for-loops are highly performant and don't need to be avoided -- both loops and vectorization can be used.

Refer to the lists of notheworthy differences from [Python](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-Python)
and [MATLAB](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-MATLAB).

### 💡 Allocations are slow

Allocating memory for a new array is slow.
Instead, we can allocate arrays once and afterwards update values via mutation.
By convention, Julia programmers indicate such functions with an `!` at the end of the name (see e.g. `sort` vs. `sort!`).

Use [_Profiling_](/profiling) to identify performance critical allocations.
Then refer to the section on _Views_ in [_Lecture 2: Arrays & Linear Algebra_](/L2_Basics_2/).

### 💡 Leverage the type system

Julia's type system is quite powerful. Parametric types can be used in methods:

```julia
# Function where both inputs have to have the same type:
add_or_error(a::T, b::T) where {T} = a + b
add_or_error(a, b) = error("Types of $a and $b don't match")

# Method where array element type is made accessible:
myeltype(A::AbstractArray{T}) where {T} = T
```

## Documentation

### ⚠️ Adhere to docstring conventions

The [Julia community has conventions](https://docs.julialang.org/en/v1/manual/documentation/#Writing-Documentation) in place when writing documentation.
LLM tend to ignore these.
Advanced developers can automate some of this work using [DocStringExtensions.jl](https://github.com/JuliaDocs/DocStringExtensions.jl).


### 💡 Run code in CI

See "Set environment variables"
