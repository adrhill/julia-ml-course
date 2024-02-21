# Prerequisites 
- [julia](https://julialang.org) is installed
- [git](https://git-scm.com/) is installed
If you are willing to use third-party platforms to setup your repository and continuous integration pipeline:
- [GitHub](https://github.com) Account
- [CodeCov](https://about.codecov.io) Account (or login via GitHub)
# Creating the initial Package

## Using PkgTemplates.jl
Utilizing PkgTemplates.jl involves the following steps:
1. Initiate the Julia REPL by opening your terminal and starting `julia`.
2. Transition to package mode using the `]` key, then execute `add PkgTemplates`.
3. Make sure your Packages are update. Type `update` while within the package mode.
4. Use the provided `Template` configuration, replacing `YourGitHubUsername` with your actual GitHub username and customizing the package name as needed:
```julia
template = Template(;
	# Meta information
    user="YourGitHubUsername",
    authors="Name <email>",
    julia=v"1.6",
	# Selected Plugins
    plugins=[
	    License(; name="MIT"),
        Git(; manifest=false),
        GitHubActions(; x64=true),
        Codecov(),
        Documenter{GitHubActions}(),
    ],
)
```
In the meta information section, ensure the `user` and `authors` fields reflect your GitHub identity and authorship details.`julia=v"1.6"` sets the minimum Julia version requirement to 1.6 for package compatibility.

Regarding the plugins within the `plugins` array:
- `License(name="MIT")` applies the MIT License for open-source distribution with minimal restrictions. It's a legal precaution.
- `Git(manifest=false)` configures the use of Git while opting out of tracking the `Manifest.toml` file.
- `GitHubActions()` sets up continuous integration (CI) via GitHub Actions with default parameters.
- `Codecov()` integrates Codecov for assessing code coverage, which quantifies the proportion of source code exercised by tests.
- `Documenter{GitHubActions}()` includes Documenter for generating package documentation, with the `GitHubActions` specifier indicating deployment to GitHub Pages via GitHubActions.

After you created the template you execute 
```julia
template("PackageName")
```
 Replace `"PackageName"` with the desired name for your package. This will initiate the creation of your package with the specified configuration, plugins, and license.
# Writing Your Code
## Source Directory (`src/`)
Create any required files within the `src/` directory. Ensure that the main file, named after your package (e.g., `MyPackage.jl`),  has an `include` statement for all necessary files while also `export`ing all functions that you develop. For further guidance, consult the lecture materials.
## Testing
### Test Cases (`test/MyPackage.jl`)
Create comprehensive test cases in `test/MyPackage.jl` to validate all functionalities of your package. The code coverage will be automatically calculated after every commit using CodeCov.
### Running Tests locally
To execute tests manually, open the terminal, navigate to your package directory, start Julia, enter package mode (by typing `]`), and execute the `test` command.
## Documentation
Documentation is crucial and we expect you to document your functions sufficiently. 
### Code Documentation
Document all exported functions with docstrings, placing them above function definitions. You can view the docstring output within a Julia environment by typing `?functionName`.
### Documentation File Structure
#### `make.jl`
The `docs/make.jl` file contains the layout for your documentation pages. Add additional pages by modifying the `pages` attribute within the `makedocs()` function.

Include your repository link (excluding the “https://”) in the `deploydocs()` function as shown below:
```julia
deploydocs(
    repo="github.com/Username/MyPackage.jl",
    devbranch = "main"
)
```
##### `docs/src/`
The `docs/src/` directory contains the `index.md` file and is the initial reference in `make.jl`. Add more markdown (.md) files as needed and update the `pages` attribute accordingly in `makedocs()`.
#### Building Documentation Locally
Add the `docs/build` directory to your `.gitignore` file to prevent pushing it to your remote repository. To build your documentation, navigate to the `docs` directory in the terminal, execute `julia --project`, and run `include("make.jl")`. The generated files will be located in `docs/build`, and you can view `index.html` using a web browser.
# CI / CD
We utilize GitHubActions, CodeCov, and Documenter.jl to automate testing, code coverage reporting, and documentation deployment.
## Automatic Documentation with Documenter.jl
### Setup
If your package was set up using `PkgTemplates.jl`, no changes to the workflow file are necessary. Otherwise, follow the provided reference file.

Generate a `Deploy Key` and a `Documenter-Key` by using the `DocumenterTools` Julia package. Execute 
```julia 
DocumenterTools.genkeys(user="Username", repo="MyPackage.jl")
```
 Ensure accurate capitalization for the username and repository. Follow the provided instructions for adding the keys to GitHub, granting write access to the `Deploy Key`.

If this has been set up correctly, the next time a significant change is being pushed to your repository (according to your workflow-triggers), GitHub Actions should now additionally build the documentation in a new branch called `gh-pages`. 

Please refer to the [Documenter.jl](https://documenter.juliadocs.org/stable/man/hosting/) documentation for Hosting.
### GitHub Pages (`gh-pages`)
Set up automatic deployment on GitHub Pages as follows:
- Navigate to the “Code and Automation” > “Pages” section within your repository settings. Find the section "Build and deployment"
- Confirm that the “Source” is set to `Deploy from branch` and the “Branch” is `gh-pages` `/(root)`.

Keep in mind that documentation updates may take a few minutes to become visible as the workflow has to run.

Please refer to the [gh-pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) documentation.
## CodeCov
To integrate CodeCov:
- Register or log in via GitHub at the [CodeCov website](https://about.codecov.io.
- Locate your package on the Repos-Overview page and select `Setup repo`.
- Follow the provided instructions to complete the setup. Note that "Step 2: add Codecov to your [GitHub Actions workflow yaml file](https://github.com/JeanAnNess/Covid_tracker/tree/main/.github/workflows)" is done by the specifying the `Codecov` plugin while creating your Template via `PkgTemplates`.
## Troubleshooting and Tips
If the documentation for a function is not appearing when using the `?help function` command:

- Ensure that you have executed `using MyPackage`.
- Verify that the docstring is placed directly above the function definition with no intervening spaces.

For more detailed guidance, refer to the relevant documentation for Documenter.jl, GitHub Actions, and gh-pages.
# References
- [julia](https://julialang.org)
- [git](https://git-scm.com/)
- [GitHub](https://github.com)
- [PkgTemplates.jl](https://juliaci.github.io/PkgTemplates.jl/stable/user/)
- [Documenter.jl](https://documenter.juliadocs.org/stable/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [CodeCov](https://about.codecov.io)
- [gh-pages](https://docs.github.com/en/pages/quickstart)