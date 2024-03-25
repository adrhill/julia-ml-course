@def title = "Julia programming for Machine Learning"
@def tags = ["index", "workflows"]

# Workflows
Learning a programming language doesn't only require learning new syntax, 
but also getting proficient with new tools, 
an aspect of programming education that is [often overlooked](https://missing.csail.mit.edu/).
After having only worked in Pluto notebooks so far, 
we will now take a look at alternative workflows. 

For this purpose, we will first cover the Julia package manager **Pkg**, 
which allows us to write reproducible code.
We will then move on to a REPL-based workflow that works with all editors.
Julia developers commonly have an interactive REPL session running while working on their code.

We will then introduce the structure of a Julia package by generating an empty package
with [PkgTemplates.jl](https://github.com/JuliaCI/PkgTemplates.jl)
and showcase the VSCode IDE with the [Julia extension](https://www.julia-vscode.org/).
Finally, we will demonstrate [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl),
a template and "assistant" for scientific experiments, 
and demonstrate how to run Julia programs from the command-line.

These workflows should empower you to write homework,  projects and even your thesis in Julia!

TODO: write better introduction

~~~
<div class="admonition note">
  <p class="admonition-title">Note</p>
  <p>These notes are designed to accompany project work in the 
  <i>JuML</i> class at TU Berlin.</p>
</div>
~~~

~~~
<div class="admonition tip">
  <p class="admonition-title">Tip</p>
  <p>As an alternative to this page, we highly recommend reading 
  <a href="https://modernjuliaworkflows.github.io/sharing/">Modern Julia Workflows</a>. 
  The <i>"Sharing"</i> section can be considered a version of this page for advanced users.</p>
</div>
~~~

## Further reading
Additional resources on workflows in Julia can be found in:
* [Modern Julia Workflows](https://modernjuliaworkflows.github.io)
* [JuliaNotes](https://m3g.github.io/JuliaNotes.jl/stable/)
