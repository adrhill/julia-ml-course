@def title = "Julia for Machine Learning"
@def tags = ["index", "common mistakes"]

# Common Mistakes 

This page contains a short summary of common mistakes (⚠️), opinionated style suggestions (🧹) and miscellaneous tips (💡).

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
using LinearAlgebra # imports all LinearAlgebra functions, including `cholesky`

# ✅ GOOD:
using LinearAlgebra: cholesky # imports only `cholesky`
```

Refer to [_Writing a Julia Package: Organizing dependencies, source files and exports_](/write/#organizing_dependencies_source_files_and_exports).
Advanced users can test for this using [ExplicitImports.jl](https://github.com/JuliaTesting/ExplicitImports.jl).

### 🧹 Keep imports and exports in main file

Keep imports and exports in one place.
```julia
# ✅ GOOD:
module MyPackage

# 1.) Explicitly import the functions you need from your dependencies
using LinearAlgebra: cholesky 

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

### 🧹 Avoid overly strict type fields

There is rarely a reason to restrict field types to something more concrete than `Number`, `Real`, `AbstractFloat` or `Integer`.

```julia
# ❌ BAD:
struct MyTypeRestrictive
    x::Float32
    y::Float32
end

# ✅ GOOD:
struct MyTypeGood{T<:Real}
    x::T
    y::T
end
```

```julia
# ❌ BAD:
struct MyMatrixRestrictive
    mat::Matrix{Float32}
end

# ✅ GOOD:
struct MyMatrixGood{T<:Real}
    mat::Matrix{T}
end

# or even:
struct MyMatrixGood2{T<:Real,A<:AbstractMatrix{T}}
    mat::A
end
```

### ⚠️ Avoid mutable structs

Mutable struct are less performant than regular (non-mutable) structs, since they are generally allocated on the heap.
It is therefore often more performant to simply return a new struct.

```julia
# ❌ BAD:
mutable struct PointMutable{T<:Real}
    x::T
    y::T
end
 
# Mutate field of `PointMutable`:
function addx_bad!(pt::PointMutable, x) 
    pt.x += x
    return pt
end

# ✅ GOOD:
struct PointGood{T<:Real}
    x::T
    y::T
end

# Simply create new immutable `PointGood`
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
struct MyTypeGood{T}
    x::T
end
```

```julia
# ❌ BAD:
struct AnotherTypeBad{TX}
    x::TX
    y
end

# ✅ GOOD:
struct AnotherTypeGood{TX,TY}
    x::TX
    y::TY
end
```

Refer to the section _Performance_ in [_Lecture 4: Custom Types_](/L4_Basics_3/).

### 🧹 Avoid overly strict type annotations

Restrictive types usually remove functionality instead adding it.
If really needed, use something more generic like `Number`, `Real`, `AbstractFloat` or `Integer`.


```julia
# ❌ BAD:
timestwo(x::Float32) = 2 * x

# ✅ GOOD:
timestwo(x) = 2 * x
```

For arrays, the same applies: use `AbstractArray`, `AbstractMatrix`, `AbstractVector`.
To prohibit array types that don't use 1-based indexing, call `Base.require_one_based_indexing` within your function.

```julia
# ❌ BAD:
sumrows(A::Matrix{Float64}) = sum(eachrow(A))

# ✅ GOOD:
sumrows(A::AbstractMatrix) = sum(eachrow(A))
```

### ⚠️ Avoid output type annotations

If your code is well written, Julia will be able to infer output types by itself.

```julia
# ❌ BAD:


# ✅ GOOD:

```

### ⚠️ Avoid accidental type promotions


## Code

### ⚠️ Don't assume 1-based indexing

We can't assume all arrays to use 1-based indexing (see e.g. [OffsetArrays.jl](https://github.com/JuliaArrays/OffsetArrays.jl)).
Use iterators like `eachrow`, `eachcol`, `eachslice` and `eachindex` when possible.
Otherwise, call `Base.require_one_based_indexing`.

Refer to the section _Iterating over arrays_ in [_Lecture 2: Arrays & Linear Algebra_](/L2_Basics_2/).


### 💡 Loops are perfectly fine

In NumPy and MATLAB, code is commonly vectorized.
This is done to call for-loops in C/C++ instead of the much slower high-level languages.
In Julia, for-loops are highly performant and don't need to be avoided -- both loops and vectorization can be used.

Refer to the lists of notheworthy differences from [Python](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-Python)
and [MATLAB](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-MATLAB).

### 💡 Mutate arrays for performance

Allocating memory on the heap for a new array is a slow operation.
Instead, we can allocate arrays once and update values via mutation.
By convention, Julia programmers indicate such functions with an `!` (see e.g. `sort` vs. `sort!`).

Use [_Profiling_](/profiling) to identify allocations which are performance critical.
Then refer to the section on _Views_ in [_Lecture 2: Arrays & Linear Algebra_](/L2_Basics_2/).

### 💡 Leverage the type system

### 🧹 Avoid strings for algorithm selection

## Tests

### ⚠️ Dry-run tests are not tests

### 💡 Set environment variables
Set global flag for e.g. MLDatasets

### 💡 Advanced: Use JET to test type inference

### 💡 Advanced: Use Aqua to test type inference

## Documentation

### ⚠️ Adhere to the recommended docstring style guide

- No empty line before docstring
- Four spaces before function name
- Markdown for 
- Examples
- automated docstrings  

### 💡 Run code in CI

See "Set environment variables"
