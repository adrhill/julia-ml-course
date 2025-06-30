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

Refer to [_Environments_](/environments) and to [_Enhancing the REPL_](/repl) respectively.

### 🧹 Keep imports and exports in main file

Refer to [_Writing a Julia Package: Organizing dependencies, source files and exports_](/write/#organizing_dependencies_source_files_and_exports).


### 🧹 Use explicit imports

Refer to [_Writing a Julia Package: Organizing dependencies, source files and exports_](/write/#organizing_dependencies_source_files_and_exports).

Advanced users can test for this using [ExplicitImports.jl](https://github.com/JuliaTesting/ExplicitImports.jl).

### 🧹 Avoid submodules

Julia programmers tend to not use use submodules for individual source files, unless necessary.

## Types

### ⚠️ Avoid mutable structs

Mutable struct are less performant than regular (non-mutable) structs, since they are generally allocated on the heap.
It is therefore often more performant to simply return a new struct.

Refer to the section on _Mutable types_ in [_Lecture 4: Custom Types_](/L4_Basics_3/).


### ⚠️ Avoid structs with untyped fields

Julia can't infer types from structs with untyped fields, which will result in bad performance.
Use parametric types instead.

Refer to the section _Performance_ in [_Lecture 4: Custom Types_](/L4_Basics_3/).

### ⚠️ Avoid overly strict type annotations

Scalars and arrays (`requires_one_based`).

### ⚠️ Avoid output type annotations

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
