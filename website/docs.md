# Documenting a Julia Package

Now that you have [written a Julia package](/write), the next crucial step is to document it.
The documentation serves as a guide for users, explaining how to utilize your package's functionality.

The primary method of documenting Julia code is through docstrings,
which provide information about each function directly in the code.

To enhance your package's accessibility further, you can create a comprehensive documentation website using [Documenter.jl](https://documenter.juliadocs.org/stable/).
For packages [hosted on GitHub](/git), you can leverage [GitHub Actions](https://github.com/features/actions) to automatically build your documentation
and use [GitHub Pages](https://pages.github.com) to host the resulting website, making your package's documentation easily accessible on the internet.

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

## Docstrings

Let's enhance our `timestwo` function from [*"Writing a Julia package"*](/write) by adding a docstring.
First, let's review our current code:

```julia
# Contents of src/MyPackage.jl
module MyPackage

timestwo(x) = 2 * x

export timestwo  # only exported functions from a module are available without namespacing

end # end module
```

Docstrings in Julia are special comments that describe the functionality of a function, method, or type.
They are written directly above the object they're documenting and are enclosed in triple quotes (`"""`).

As shown in [*"Getting Help"*](/E2_Help), you can type `?` in a Julia REPL to enter *help mode*,
which changes the REPL prompt from `julia>` to `help?>`.
In help mode, typing the name of a function will print its documentation.
However, if we try this with our `timestwo` function, we'll see that it currently lacks a docstring:

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

Let's edit `src/MyPackage.jl` and add a docstring:

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
* We enclosed our docstring in triple quotes `"""` and added it directly above the `timestwo` method we want to document (**no empty line in between!**).
* Indented by four spaces, we added the function signature `timestwo(x)` to our docstring. If your function can be called in multiple ways due to multiple dispatch, you can add several such lines.

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
The structure of your documentation is defined in the `docs/make.jl` file.
Let's examine the `pages` argument in the `makedocs` function:

```julia
# Part of the `makedocs` call in `docs/make.jl`
pages=[
    "Home" => "index.md",
],
```

This configuration creates the structure of your documentation:
1. `"Home"` defines the title of the page as it will appear in the navigation.
2. `"index.md"` specifies the source file in the `docs/src/` directory.

To add new pages to your documentation:
1. Create a new Markdown file in the `docs/src/` directory (e.g., `example.md`).
2. Add a new entry to the `pages` array in `docs/make.jl`.

For instance, to add a "Getting Started" page:

```julia
pages=[
    "Home" => "index.md",
    "Getting Started" => "example.md", # <--- added page
],
```

This structure allows you to organize your documentation into logical sections, making it easier for users to navigate and find information about your package.

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

After following the [*Set-up guide*](/git/#setting_up_documenterjl) and adding the necessary keys using DocumenterTools,
you're ready to configure GitHub Pages for your documentation.
Here's a step-by-step process:

1. Navigate to your GitHub repository.
2. Go to `Settings > Pages > Build and deployment`.
3. Under *"Source"*, select *"Deploy from a branch"*.
4. In the drop-down menus below, choose `gh-pages` for the branch and `/(root)` for the folder.

Once configured, your development documentation will automatically update whenever you push changes to the `main` branch of your repository.
You can access this documentation by clicking the `docs | dev` badge in your README.

!!! note "Development vs. Stable Documentation"
    The `docs | dev` badge links to the latest development version of your documentation.

    The `docs | stable` badge, which may show an error initially, links to documentation for the most recent tagged release of your package.
    This badge will become functional once you create your first release (e.g., `v0.1.0`).
    For the purpose of the JuML project work at TU Berlin, you can either remove this badge from the README or leave it as is.

## Further reading
* [Julia Base Documentation on Documentation](https://docs.julialang.org/en/v1/manual/documentation/)
* [Documenter.jl documentation](https://documenter.juliadocs.org/stable/): this is a must read. Take a look at the [Showcase](https://documenter.juliadocs.org/stable/showcase/).
* [DocStringExtensions.jl](https://github.com/JuliaDocs/DocStringExtensions.jl): collection of tools to automatically generate some information in docstrings, e.g. method signatures and types of struct fields.
* [DocumenterCitations.jl](https://github.com/JuliaDocs/DocumenterCitations.jl): support for BibTeX citations.
* [*Modern Julia Workflows* on documentation](https://modernjuliaworkflows.github.io/sharing/#documentation)
