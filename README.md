<div align="center">
  <a href="https://adrhill.github.io/julia-ml-course/">
    <img
      src="website/_assets/logo/logo.svg"
      alt="JuML Logo"
      height="100"
    />
  </a>
  <br />
  <p>
    <h1>
      <b>
        Julia programming for Machine Learning
      </b>
    </h1>
    
[![Go to course website][goto-badge]][site-url]
[![TU Berlin ISIS page][isis-badge]][isis-url]
    
  </p>
</div>

Course material and website for the [Julia programming for Machine Learning][site-url] course (JuML) at the [TU Berlin Machine Learning group][ml-group-url].

## Installation
Follow the [installation instructions](https://adrhill.github.io/julia-ml-course/E1_Installation/)
on the course website.

## Contents
The course is taught in five weekly sessions of three hours.
In each session, two lectures are taught:

| Week | Lecture | Content                                           |
|:----:|:-------:|:--------------------------------------------------|
| 1    |  0      | General Information, Installation & Getting Help  |
|      |  1      | Basics 1: Types, Control-flow & Multiple Dispatch |
| 2    |  2      | Basics 2: Arrays, Linear Algebra                  |
|      |  3      | Plotting & DataFrames                             |
| 3    |  4      | Basics 3: Data structures and custom types        |
|      |  5      | Classical Machine Learning                        |
| 4    |  6      | Automatic Differentiation                         |
|      |  7      | Deep Learning                                     |
| 5    |  8      | Workflows: Scripts, Experiments & Packages        |
|      |  9      | Profiling & Debugging                             |

The first three weeks focus on teaching the fundamentals of the Julia programming language. 
These weeks consist of longer lectures, followed up by shorter, "guided tours" of the Julia ecosystem,
including plotting, data-frames and classical machine learning algorithms.

Week four is all about Deep Learning:
A comprehensive lecture on automatic differentiation (AD) 
sheds light on differences between Julia's various AD packages,
before giving a brief overview of Flux's Deep Learning ecosystem.

Finally, week five is all about starting your own Julia project,
taking a look at the structure of Julia packages and different workflows 
for reproducible machine learning research. 
This is followed up by a demonstration of Julia's debugging and profiling utilities.

The lectures and the homework cover the following packages:

| Package              | Lecture |  Description                                           |
|:-----------------    |:-------:|:-------------------------------------------------------|
| LinearAlgebra.jl     |       2 | Linear algebra (standard library)                      |
| Plots.jl             |       3 | Plotting & visualizations                              |
| DataFrames.jl        |       3 | Working with and processing tabular data               |
| MLJ.jl               |       5 | Classical Machine Learning methods                     |
| ChainRules.jl        |       6 | Forward- & reverse-rules for automatic differentiation |
| Zygote.jl            |       6 | Reverse-mode automatic differentiation                 |
| Enzyme.jl            |       6 | Forward- & reverse-mode automatic differentiation      |
| ForwardDiff.jl       |       6 | Forward-mode automatic differentiation                 |
| FiniteDiff.jl        |       6 | Finite differences                                     |
| FiniteDifferences.jl |       6 | Finite differences                                     |
| Flux.jl              |       7 | Deep Learning abstractions                             |
| MLDatasets.jl        |       7 | Dataset loader                                         |
| PkgTemplates.jl      |       8 | Package template                                       |
| DrWatson.jl          |       8 | Workflow for scientific projects                       |
| Debugger.jl          |       9 | Debugger                                               |
| Infiltrator.jl       |       9 | Debugger                                               |
| ProfileView.jl       |       9 | Profiler                                               |
| Cthulhu.jl           |       9 | Type inference debugger                                |

[site-url]: https://adrhill.github.io/julia-ml-course/
[ml-group-url]: https://www.tu.berlin/ml
[isis-url]: https://isis.tu-berlin.de/course/view.php?id=34292

[goto-badge]: https://img.shields.io/badge/-Go%20to%20course%20website-informational
[isis-badge]: https://img.shields.io/badge/TU%20Berlin-ISIS%20page-red