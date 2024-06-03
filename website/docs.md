# Documenting a Julia Package

Now that you have [written](/write) a Julia package, you need to tell people how to use it.
For this purpose, you need to add docstrings to your functions.

In addition to these docstrings, you can build a website that documents your package using [Documenter.jl](https://documenter.juliadocs.org/stable/).
If you [host your package on GitHub](/git), 
you can use [GitHub Actions](https://github.com/features/actions) to build your documentation
and [GitHub Pages](https://pages.github.com) to host the resulting website.

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

## Docstrings

Let's add a docstring to the `timestwo` function we added in [*"Writing a Julia package"*](/write).
For this purpose, we assume that our source code includes the following:

```julia
# Contents of src/MyPackage.jl
module MyPackage

timestwo(x) = 2 * x

export timestwo  # only exported functions from a module are available without namespacing

end # end module
```

As shown in [*"Getting Help"*](/E2_Help), you can type `?` in a Julia REPL to enter *help mode*, 
which changes the REPL prompt from `julia>` to `help?>`.
In help mode, typing the name of a function will print its documentation, however `timestwo` doesn't have a docstring yet: 

```julia-repl
julia> using MyPackage # all exported functions are available

help?> timestwo
search: timestwo

  No documentation found.

  MyPackage.timestwo is a Function.

  # 1 method for generic function "timestwo" from MyPackage:
   [1] timestwo(x)
       @ ~/.julia/dev/MyPackage/src/MyPackage.jl:3
```

Let's add one by editing `src/MyPackage.jl`:

```julia
# New contents of src/MyPackage.jl
module MyPackage

"""
    timestwo(x)

Multiply the input `x` by two.
"""
timestwo(x) = 2 * x

export timestwo  # only exported functions from a module are available without namespacing

end # end module
```

Let's go through this in detail:
* We enclosed our docstring in triple quotes `"""` and added it directly **in front of** the `timestwo` method we want to document.
* Indented by four spaces, we added the function signature `timestwo(x)`. If your function can be called in multiple ways due to multiple dispatch, you can add several such lines. 

!!! tip "Must read!"
    The Julia Documentation has an [in-depth guide](https://docs.julialang.org/en/v1/manual/documentation/#Writing-Documentation)  on how to write a good docstring.

You can now view your docstring in help mode!

```julia-repl
help?> timestwo
search: timestwo

  timestwo(x)


  Multiply the input x by two.

```

## Documentation using Documenter.jl

### Building documentation locally

When building your first documentation page with Documenter.jl, it is annoying to have to wait for GitHub Actions to pass or fail.
In this section, you will therefore learn how to build your docs locally.
This is entirely optional, but can be helpful to debug failing GitHub Actions.  

In [*"Setting up a Julia package"*](/setup), PkgTemplates already set up a `/docs` folder for us.
This folder contains an [environment](/environments), which we need to activate to build our docs locally:

```julia-repl
(MyPackage) pkg> activate docs
  Activating project at `~/.julia/dev/MyPackage/docs`

(docs) pkg> 
```

This environment is also where we can add additional dependencies to our docs. 
Now we can run the *"main"* file of our documentation, which is called `docs/make.jl`.
Simply `include` the file:

```julia-repl
julia> include("docs/make.jl");
[ Info: SetupBuildDirectory: setting up build directory.
[ Info: Doctest: running doctests.
[ Info: ExpandTemplates: expanding markdown templates.
[ Info: CrossReferences: building cross-references.
[ Info: CheckDocument: running document checks.
[ Info: Populate: populating indices.
[ Info: RenderDocument: rendering document.
[ Info: HTMLWriter: rendering HTML pages.
[ Info: Automatic `version="1.0.0-DEV"` for inventory from ../Project.toml
┌ Warning: Documenter could not auto-detect the building environment. Skipping deployment.
└ @ Documenter ~/.julia/packages/Documenter/CJeWX/src/deployconfig.jl:76
```

The command above successfully built your documentation into the folder `docs/build`!

The warning at the end is normal: the `docs/make.jl` is primarily intended to be run by your CI workflow.
It calls Documenter.jl's function `deploydocs`, which tries to deploy your documentation to a branch of your GitHub repository called `gh-pages`, which fails outside of CI and prints the warning above.

### Looking at your documentation

In a separate terminal (you can open one by clicking the `+` in the upper right corner of your VSCode terminal), 
use LiveServer to serve the `docs/build` folder: 

```julia-repl
julia> using LiveServer

julia> serve(; dir="docs/build", launch_browser=true)
✓ LiveServer listening on http://localhost:8000/ ...
  (use CTRL+C to shut down)
```

**Leave this second terminal open in the background.**
You can now update your documentation, re-run `include("docs/make.jl")` in your **first** terminal, and instantly view the changes to your docs.

### Writing documentation

#### Adding pages
Let's take a look at the `docs/make.jl` file we previously ran,
and focus on the `pages` argument in the call to `makedocs`:

```julia
# Part of the `makedocs` call in `docs/make.jl`
pages=[
    "Home" => "index.md",
],
```

This line adds the file `docs/src/index.md` as your *"Home"* page.
You can create new pages by adding `.md` Markdown files to the `docs/src/` folder and including them here.
For example, you could add a file called `docs/src/example.md` and include it as

```julia
pages=[
    "Home" => "index.md",
    "Getting Started" => "example.md", # <--- added page
],
```

#### Writing Markdown content

Now that you can build your docs locally, try to modify them.
Documenter.jl uses [Julia's Markdown syntax](https://docs.julialang.org/en/v1/stdlib/Markdown/):

* to add a headings of decreasing sizes, use `#`, `##`, `###` etc.
* surround words in two asterisks `**some words**` to display them as bold text: **some words**
* surround words in asterisks `*some words*` to display them as italic text: *some words*
* surround words in backticks to display them as code: `some words`
* surround LaTeX math in double backticks to render it

!!! tip
    Take a look at the [Documenter.jl showcase](https://documenter.juliadocs.org/stable/showcase/)
    and [Julia's Markdown reference](https://docs.julialang.org/en/v1/stdlib/Markdown/).

#### Generated contents

Let's take a look at the `docs/src/index.md` that was added by PkgTemplates.

* the `@index` block is used to generate a table of contents for all docstrings in the current page
* the `@autodocs` block automatically includes all docstrings exported by your package
* the `@meta` block on top is used to define the metadata used by blocks like `@autodocs` and `@docs`

There are [more types of blocks](https://documenter.juliadocs.org/stable/man/syntax/):
* `@docs` can be used to include docstrings in a more manual fashion
* `@contents` can be used to generate a table of contents for all sections in the current page
* `@example` can be used to run Julia code and show its outputs
* `@repl` can be used to run Julia REPL code and show its outputs

!!! tip "Write your first doc page!"
    Use `@example` or `@repl` blocks to write your *"Getting started"* page in `docs/src/example.md`! 

### Setting up GitHub Pages

If you followed the [*Set-up guide*](http://localhost:8000/git/#setting_up_documenterjl) and added keys using DocumenterTools, your documentation is almost ready.
In your GitHub repository, go to `Settings > Pages > Build and deployment`. 
For the *"Source"*, select *"Deploy from a branch"* and select `gh-pages` and `/(root)` in the drop-down menus below.

Your dev docs should now automatically update every time you update the `main` branch of your repository.
You can read them by clicking on the `docs | dev` badge in your README.

!!! tip "Stable documentation isn't available"
    The `docs | stable` badge in your README most likely returns an error when clicking on it.
    This is due to the fact that stable doc pages are connected to "tagged releases" of your repository, e.g. a future `v1.0.0` release.
    Since you haven't tagged a release yet, stable docs aren't available. 

    For the purpose of the JuML project work at TU Berlin, simply ignore the badge or remove it from the README.

## Further reading
* [Julia Base Documentation on Documentation](https://docs.julialang.org/en/v1/manual/documentation/)
* [Documenter.jl documentation](https://documenter.juliadocs.org/stable/): this is a must read. Take a look at the [Showcase](https://documenter.juliadocs.org/stable/showcase/).
* [DocStringExtensions.jl](https://github.com/JuliaDocs/DocStringExtensions.jl): collection of tools to automatically generate some information in docstrings, e.g. method signatures and types of struct fields.
* [DocumenterCitations.jl](https://github.com/JuliaDocs/DocumenterCitations.jl): support for BibTeX citations.
* [*Modern Julia Workflows* on documentation](https://modernjuliaworkflows.github.io/sharing/#documentation)
