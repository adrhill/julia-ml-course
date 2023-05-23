<h1 align="center">
    Julia programming for Machine Learning
</h1>
<p align="center">
    <a href="https://adrhill.github.io/julia-ml-course/">
        <img src="https://img.shields.io/badge/-Go%20to%20course%20website-informational" />
    </a>
    <a href="https://isis.tu-berlin.de/course/view.php?id=34292">
        <img src="https://img.shields.io/badge/TU%20Berlin-ISIS%20page-red" />
    </a>
</p>

Course material and website for the [Julia programming for Machine Learning][site-url] course (JuML) at the [TU Berlin Machine Learning group][ml-group-url].

## Installation
Follow the [installation instructions](https://adrhill.github.io/julia-ml-course/E1_Installation/)
on the course website.

## Contents
The course is taught in five weekly sessions of three hours.
In each session, two lectures are taught:

| Lecture | Content                                           |
|:-------:|:--------------------------------------------------|
|  0      | General Information, Installation & Getting Help  |
|  1      | Basics 1: Types, Control-flow & Multiple Dispatch |
|  2      | Basics 2: Arrays & Linear Algebra                 |
|  3      | Plotting & DataFrames                             |
|  4      | Basics 3: Data structures and custom types        |
|  5      | Classical Machine Learning                        |
|  6      | Automatic Differentiation                         |
|  7      | Deep Learning                                     |
|  8      | Workflows: Scripts, Experiments & Packages        |
|  9      | Testing, Profiling & Debugging                    |

The lectures are accompanied by four homework notebooks.
The following packages are covered by the lectures and homework:

| Package              | Lecture |  Description                                           |
|:-----------------    |:-------:|:-------------------------------------------------------|
| LinearAlgebra.jl     |       2 | Linear algebra (standard library)                      |
| Plots.jl             |       3 | Plotting & visualizations                              |
| DataFrames.jl        |       3 | Working with and processing tabular data               |
| MLJ.jl               |       5 | Classical Machine Learning methods                     |
| ChainRules.jl        |       6 | Forward- & reverse-rules for automatic differentiation |
| Zygote.jl            |       6 | Reverse-mode automatic differentiation                 |
| Enzyme.jl            |       6 | Forwards- & reverse-mode automatic differentiation     |
| ForwardDiff.jl       |       6 | Forward-mode automatic differentiation                 |
| FiniteDiff.jl        |       6 | Finite differences                                     |
| FiniteDifferences.jl |       6 | Finite differences                                     |
| Flux.jl              |       7 | Deep Learning abstractions                             |
| MLDatasets.jl        |       7 | Dataset loader                                         |
| PkgTemplates.jl      |       8 | Package template                                       |
| DrWatson.jl          |       8 | Workflow for scientific projects                       |
| Infiltrator.jl       |       9 | Debugger                                               |
| Cthulu.jl            |       9 | Debugger for type inference                            |
| ProfileView.jl       |       9 | Profiler                                               |

[site-url]: https://adrhill.github.io/julia-ml-course/
[ml-group-url]: https://www.tu.berlin/ml
