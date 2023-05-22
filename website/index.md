@def title = "Julia programming for Machine Learning"
@def tags = ["index"]

# Julia programming for ML
Welcome to the website of the *Julia programming for Machine Learning* course
taught at the [TU Berlin Machine Learning Group](https://www.tu.berlin/ml).

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

## Goals
The goal of this course is to give you an introduction to the 
[Julia programming language](https://julialang.org) and its Machine Learning ecosystem.

After taking this class, you should be able to write reproducible, unit-tested Julia code 
and do Machine Learning research in Julia. 

## Prerequisites
No knowledge of the Julia programming language is required: this course only assumes knowledge of common programming concepts like for-loops and arrays.
Occasionally, differences and similarities to Python will be pointed out. If you don't know Python, you can safely ignore these.

## Contents
### Lectures
The course is taught in five weekly sessions of three hours.
In each session, two lectures are taught:

| Week | Lecture | Content                                           | Exam / Homework |
|:----:|:-------:|:--------------------------------------------------|:----------------|
| 1    |  0      | General Information, Installation & Getting Help  |                 |
|      |  1      | Basics 1: Types, Control-flow & Multiple Dispatch | ✅               |
| 2    |  2      | Basics 2: Arrays, Linear Algebra                  | ✅               |
|      |  3      | Plotting & DataFrames                             | ✅               |
| 3    |  4      | Basics 3: Data structures and custom types        | ✅               |
|      |  5      | Classical Machine Learning                        | ✅               |
| 4    |  6      | Automatic Differentiation                         | ✅               |
|      |  7      | Deep Learning                                     | ✅               |
| 5    |  8      | Workflows: Scripts, Experiments & Packages        |                 |
|      |  9      | Testing, Profiling & Debugging                    |                 |

The lectures and the homework cover the following packages:

| Package          | Description                              | Python equivalent |
|:-----------------|:-----------------------------------------|:------------------|
| LinearAlgebra.jl | Linear algebra (standard library)        | numpy             |
| Plots.jl         | Plotting & visualizations                | matplotlib        |
| DataFrames.jl    | Working with and processing tabular data | pandas            |
| MLJ.jl           | Classical Machine Learning methods       | scikit-learn      |
| ForwardDiff.jl   | Forward-mode automatic differentiation   |                   |
| Zygote.jl        | Reverse-mode automatic differentiation   | JAX               |
| MLDatasets.jl    | Dataset loader                           |                   |
| Flux.jl          | Higher-level Deep Learning abstractions  | PyTorch, Keras    |
| PkgTemplates.jl  | Package template                         |                   |
| DrWatson.jl      | Workflow for scientific projects         |                   |

### Homework
When learning a programming language, it helps to actually write code.
The lectures from week 1 to 4 are accompanied by homework notebooks that test
your understanding of the contents. 
These notebooks contain automated feedback in the form of tests that need to be passed.

For TU Berlin students, homework will be evaluated on a slightly different test suite
to avoid hard-coded answers. 

Designing homework exercises takes a lot of time, so 
**please don't upload any answers to the homework to the internet.**

## Information for TU Berlin students 
Julia Programming for Machine Learning (3 ECTS credits) is an optional course within one of the following modules:
- [Cognitive Algorithms](https://wiki.ml.tu-berlin.de/wiki/Main/WS22_KA) (summer & winter semester)
- [Machine Learning 1](https://wiki.ml.tu-berlin.de/wiki/Main/WS22_MaschinellesLernen1) (winter semester)
- [Machine Learning 2](http://wiki.ml.tu-berlin.de/wiki/Main/SS23_ML2) (summer semester)

It's **not** possible to take the class as a standalone, seminar, or free-choice module.

Homework assignments must be submitted every week. 
You must be enrolled on ISIS to submit homework. 
If you do not register on time, you cannot pass the course.

- **Course Period:**  April 26th - May 24th 2023
  - **Lectures:** Wednesday 09:15 - 11:45 (online)
  - **Office hours:** Monday 14:15 - 15:45 (online)

More information and links to the Zoom meetings can be found on [ISIS](https://isis.tu-berlin.de/course/view.php?id=34292).

## FAQ
#### Why should I learn Julia?
Paraphrasing the [official website](https://julialang.org), 
Julia is: 
- **Fast:** designed for high performance computing, compiles to LLVM
- **Dynamic:** dynamically typed, interactive REPL
- **Reproducible:** great package manager, reproducible environments and pre-built binaries
- **Composable:** uses multiple dispatch
- **General:** allows async I/O, metaprogramming, etc.
- **Open source:** open development, uses permissive MIT license

If these are features that sound appealing to you, you should learn Julia!

#### How can I run the notebooks?
Running notebooks is described in the *"Opening lectures & homework"* section of the *Installation* notebook.

Alternatively, you can open the notebook on Binder by clicking *"Edit or run this notebook"*.
However, Binder can take a prohibitively long time to load. 
Pluto notebooks show an estimate of the loading times above the *"Run in Binder"* button.

If you are familiar with Git, you can also clone the [GitHub repository of this course](https://github.com/adrhill/julia-ml-course/).
You can then open your local copy of the lectures and homework in Pluto.
Just make sure to regularly pull to keep your copy of the course up to date.

#### I found an error or typo. What should I do?
Please help make this course better! 

For small fixes, click the *"Edit Julia source code"* button on top of a notebook.
This will open the source on GitHub, where you can then click the *"Edit this file"* button (shown with a pencil icon).
This will [create a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request?tool=webui) on GitHub.

Alternatively, write me on [ISIS](https://isis.tu-berlin.de/) or open an issue on GitHub and tell me what needs to be fixed. Ideas and feedback are also more than welcome.

#### What does the symbol `⁽⁺⁾` in some slide titles mean?
This symbol indicates optional–often more advanced–content that can be skipped.


## Acknowledgements
The format of this website as well as the contents of this course are influenced by the following lectures:
- [*Introduction to Computational Thinking*](https://computationalthinking.mit.edu/Fall22/) 
  at MIT by Alan Edelman, David P. Sanders, Charles E. Leiserson and Fons van der Plas
- [*Scientific Computing*](https://www.wias-berlin.de/people/fuhrmann/SciComp-WS2122/) 
  at TU Berlin by Jürgen Fuhrmann

Many thanks to Fons van der Plas for helping me build this website!