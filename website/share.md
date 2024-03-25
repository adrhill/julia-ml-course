# Sharing a Julia Package

In Julia, packages are the natural medium for code that doesn't fit in a simple script.
While this might sound excessive at first, it provides many conveniences.

This page serves as a guide for creating your first Julia package. 
It walks you through the process of the initial setup and the structure of a Julia package. 

~~~
<div class="admonition tip">
  <p class="admonition-title">Tip</p>
  <p>As an alternative to this page, we highly recommend reading 
  <a href="https://modernjuliaworkflows.github.io/sharing/">Modern Julia Workflows</a>. 
  The <i>"Sharing"</i> section can be considered a version of this page for advanced users.</p>
</div>
~~~

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

TODO: rewrite

### Semantic versioning
It is good practice (and required for package registration) 
to enter `[compat]` entries for all dependencies.
This allows us to update dependencies without having to worry about our code breaking.

By convention, Julia packages are expected to follow
[Semantic Versioning](https://semver.org/lang/de/) to specify version numbers:

> Given a version number MAJOR.MINOR.PATCH, increment the:
> 1. MAJOR version when you make incompatible API changes
> 1. MINOR version when you add functionality in a backward compatible manner
> 1. PATCH version when you make backward compatible bug fixes
> 1. Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

> Major version zero (0.y.z) is for initial development.
> Anything MAY change at any time. The public API SHOULD NOT be considered stable.

Let's add a compat entry for CSV.jl. Using `status` in Pkg-mode, we can inspect the current version:
```julia-repl
(MyPackage) pkg> status
Project MyPackage v1.0.0-DEV
Status `~/.julia/dev/MyPackage/Project.toml`
  [336ed68f] CSV v0.10.10
``` 

Let's declare in the `Project.toml` that only versions `0.10.X` of CSV.jl are permitted. 
This will allow us to get updates that patch bugs, but not updates with breaking changes.
```toml
[compat]
CSV = "0.10"
julia = "1"
```

### Continuous integration
The `.github/workflows/` folder contains three files, which specify 
[*GitHub actions*](https://github.com/features/actions):
- `CI.yml`: run tests, optionally build docs and determine code coverage.
- `CompatHelper.yml`: Check whether `[compat]` entries are up to date.
- `TagBot.yml`: tag new releases of your package.

These files contain instructions that will be run on GitHub's computers.
The most basic use-case is running package tests. 
GitHub Actions either run on a timed schedule or at specific events, 
for example when pushing commits and opening pull requests.

~~~
<div class="admonition note">
  <p class="admonition-title">Note</p>
  <p>GitHub Actions and CI will be showcased in the lecture.</p>
</div>
~~~



### Documentation
Documentation is crucial and we expect you to document your functions sufficiently. 
This includes both the docstrings accessible via `?myfunction` in the Julia-REPL 
as well as the doc pages which are formatted like a website that includes the docstrings as API reference. 
Within the next few subchapters we explain the process of setting this up.

#### Code Documentation
Document all exported functions with docstrings, placing them above function definitions. 
You can view the docstring output within a Julia environment by typing `?functionName`.

#### Documentation File Structure
##### `make.jl`
The `docs/make.jl` file contains the layout for your documentation pages. 

`makedocs` is used to generate the documentation. Add additional pages by modifying the `pages` attribute within.

`deploydocs` is used to deploy the generated documentation to your GitHub repository.

###### `docs/src/`
The `docs/src/` directory contains the `index.md` file and is the initial reference in `make.jl`. 
Add more markdown (.md) files as needed and update the `pages` attribute accordingly in `makedocs`.

##### Building Documentation Locally
Add the `docs/build` directory to your `.gitignore` file to prevent pushing it to your remote repository. 
To build your documentation, navigate to the `docs` directory in the terminal, execute `julia --project`, and run `include("make.jl")`. 
The generated files will be located in `docs/build`, and you can view `index.html` using a web browser.

## Using Git 
- [Git](https://git-scm.com/) is installed

- [GitHub](https://github.com) Account
If you are willing to use third-party platforms to setup your repository and continuous integration pipeline, then you will require:
- [CodeCov](https://about.codecov.io) Account (or login via GitHub)
Otherwise the GitLab Instance from the TUB can be used:
- [TUB GitLab](https://git.tu-berlin.de)


## CI / CD
We utilize GitHubActions, CodeCov, and Documenter.jl to automate testing, code coverage reporting, and documentation deployment.

### Automatic Documentation with Documenter.jl
#### Setup
If your package was set up using `PkgTemplates.jl`, no changes to the workflow file are necessary. 
Otherwise, follow the provided reference file.

Generate a `Deploy Key` and a `DOCUMENTER_KEY` by using the `DocumenterTools` Julia package. Execute 
```julia 
DocumenterTools.genkeys(user="Username", repo="MyPackage.jl")
```

Ensure accurate capitalization for the username and repository. 
Follow the provided instructions for adding the keys to GitHub, granting write access to the `Deploy Key`.

If this has been set up correctly, the next time a significant change is being pushed to your repository (according to your workflow-triggers), 
GitHub Actions should now additionally build the documentation in a new branch called `gh-pages`. 

Please refer to the [Documenter.jl](https://documenter.juliadocs.org/stable/man/hosting/) documentation for Hosting.

#### GitHub Pages (`gh-pages`)
Set up automatic deployment on GitHub Pages as follows:
- Navigate to the “Code and Automation” > “Pages” section within your repository settings. Find the section "Build and deployment"
- Confirm that the “Source” is set to `Deploy from branch` and the “Branch” is `gh-pages` `/(root)`.

Keep in mind that documentation updates may take a few minutes to become visible as the workflow has to run.

Please refer to the [gh-pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) documentation.

### CodeCov
To integrate CodeCov with your repository
1. Register on the [CodeCov website](https://about.codecov.io) or log in via you GitHub account
2. Locate your package on the repository overview page and select *"Setup repo"*
3. Follow the provided instructions to complete the setup. 
    * Note that *"Step 2: add Codecov to your GitHub Actions workflow yaml file"* 
      can be skipped: PkgTemplates already created this workflow for us

### Package registration
If you wrote a high quality, well tested package 
and want to make it available to all Julia users through the package manager, 
follow the [Registrator.jl instructions](https://github.com/JuliaRegistries/Registrator.jl). 

People will then be able to install your package by writing

```julia-repl
(@v1.8) pkg> add MyPackage
```

## References
- The [Modern Julia Workflows](https://modernjuliaworkflows.github.io/sharing/)
  page is a must read for every Julia user
- Documentation of used Julia packages:
  - [Documenter.jl](https://documenter.juliadocs.org/stable/)
  - [DocumenterTools.jl](https://documenter.juliadocs.org/stable/lib/internals/documentertools/)
- Documentation of CI / CD infrastructure:
  - [GitHub Actions](https://docs.github.com/en/actions)
  - [GitHub Pages](https://docs.github.com/en/pages/quickstart)
  - [CodeCov](https://about.codecov.io)
