@def title = "Julia for Machine Learning"
@def tags = ["index"]

# Julia for Machine Learning
Welcome to the *Julia for Machine Learning* course (JuML)
offered by Prof. Klaus-Robert Müller's 
[Machine Learning Group](https://web.ml.tu-berlin.de) at TU Berlin.

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
The **first half of the course** is taught in five weekly sessions of three hours.
In each session, two lectures are taught:

| Week | Lecture | Content                                           |
|:----:|:-------:|:--------------------------------------------------|
| 1    | 0       | General Information, Installation & Getting Help  |
|      | 1       | Basics 1: Types, Control-flow & Multiple Dispatch |
| 2    | 2       | Basics 2: Arrays, Linear Algebra                  |
|      | 3       | Plotting & DataFrames                             |
| 3    | 4       | Basics 3: Data structures and custom types        |
|      | 5       | Classical Machine Learning                        |
| 4    | 6       | Automatic Differentiation                         |
|      | 7       | Deep Learning                                     |
| 5+   | Project | Workflows: Scripts, Experiments & Packages        |
|      | Project | Profiling & Debugging                             |

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

| Package              | Lecture |  Description                                           | Python equivalent |
|:-----------------    |:-------:|:-------------------------------------------------------|:------------------|
| LinearAlgebra.jl     |       2 | Linear algebra (standard library)                      | numpy             |
| Plots.jl             |       3 | Plotting & visualizations                              | matplotlib        |
| DataFrames.jl        |       3 | Working with and processing tabular data               | pandas            |
| MLJ.jl               |       5 | Classical Machine Learning methods                     | scikit-learn      |
| ChainRules.jl        |       6 | Forward- & reverse-rules for automatic differentiation |                   |
| Zygote.jl            |       6 | Reverse-mode automatic differentiation                 | JAX, PyTorch      |
| Enzyme.jl            |       6 | Forward- & reverse-mode automatic differentiation      | JAX               |
| ForwardDiff.jl       |       6 | Forward-mode automatic differentiation                 |                   |
| FiniteDiff.jl        |       6 | Finite differences                                     |                   |
| FiniteDifferences.jl |       6 | Finite differences                                     |                   |
| Flux.jl              |       7 | Deep Learning abstractions                             | PyTorch, Keras    |
| MLDatasets.jl        |       7 | Dataset loader                                         |                   |
| PkgTemplates.jl      | Project | Package template                                       |                   |
| DrWatson.jl          | Project | Workflow for scientific projects                       |                   |
| Debugger.jl          | Project | Debugger                                               |                   |
| Infiltrator.jl       | Project | Debugger                                               |                   |
| ProfileView.jl       | Project | Profiler                                               |                   |
| Cthulhu.jl           | Project | Type inference debugger                                |                   |

### Homework
When learning a programming language, it helps to write code.
The lectures from week 1 to 4 are accompanied by homework notebooks that test
your understanding of the contents. 
These notebooks contain automated feedback in the form of tests that need to be passed.

For TU Berlin students, the homework will also be evaluated on a second, 
slightly different test suite to avoid cheating and hard-coded answers. 

Designing homework exercises takes a lot of time, so 
**please don't upload any answers to the homework to the internet.**

### Project work
In the **second half of the course**, after passing the homework,
students work in groups on a small programming project of their choice, 
learning best practices for package development in Julia, such as:
* how to structure and develop a package
* how to write package tests
* how to write and host package documentation

During code review sessions, students give each other feedback on their projects 
before presenting their work in end-of-semester presentations.

## Information for TU Berlin students 

Homework assignments must be submitted every week. 
You must be enrolled on ISIS to submit homework. 
If you do not register on time, you cannot pass the course.

![JuML course timeline](/assets/timeline.png)

* **Course Period:**  October 14th 2025 - February 10th 2026
  * **Kick-off meeting:** Tuesday, October 14th, 16:15-17:45, MA 0.42
  * **Project meetings:** Tuesdays, 16:15-17:45, MAR 0.011
  * **Office hours:** TBA

Attendance is mandatory on the following dates:
* Tuesday, 14.10.25
* Tuesday, 18.11.25
* Tuesday, 16.12.25
* Tuesday, 20.01.25
* Tuesday, 03.02.26
* Tuesday, 10.02.26

The date of the final examination will be determined on a group-by-group basis.

More information can be found on [ISIS](https://isis.tu-berlin.de/course/view.php?id=40973).

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

Many thanks to 
- [Fons van der Plas](https://github.com/fonsp) for making Pluto and helping me build this website
- [Niklas Schmitz](https://github.com/niklasschmitz) for feedback on the AD lecture
- [Janes Sanne](https://github.com/JeanAnNess),
  [Dr. Andreas Ziehe](https://web.ml.tu-berlin.de/author/dr.-andreas-ziehe/) and
  [Philip Naumann](https://web.ml.tu-berlin.de/author/philip-naumann/) 
  for their help with teaching the course at TU Berlin
- [Théo Galy-Fajou](https://github.com/theogf) and [Johnny Chen](https://github.com/johnnychen94) for their mentorship
- everyone who contributed to the packages covered in this lecture
