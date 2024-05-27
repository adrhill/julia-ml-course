@def title = "Julia Programming for Machine Learning"
@def tags = ["index", "workflows"]

# Workflow Overview

Learning a programming language isn't just about learning new syntax, 
it's also getting proficient with new tools and workflows, 
an aspect of programming education that is often overlooked.
Having only worked in Pluto notebooks so far, 
we will now take a look at alternative workflows.

We start out by looking at the Julia package manager **Pkg**,
which allows us to write reproducible code by defining [**environments**](/environments).
We then [**enhance our REPL**](/repl), since we will usually have an interactive REPL session running while working on our code.
We will then show how to [**set up**](/setup), [**write**](/write) and [**test a Julia package**](/test).

While writing your package, you will most likely see some of your package tests fail.
For non-trivial bugs, knowing how to use a [**debugger**](/debugging) is crucial.
And once your code is running correctly, you probably want to make it run fast.
Using a [**profiler**](/profiling) will tell you which parts of your code deserve your time and attention.

Finally, we take a short look at [**scripts and experiments**](/scripts).
This is useful for ML research, where you will most likely be launching jobs on remote compute clusters from the command-line.
We also demonstrate a template and "assistant" for scientific experiments.

These workflows should empower you to write and share your own Julia packages!

## Further reading
~~~
<div class="admonition tip">
  <p class="admonition-title">Tip</p>
  <p>As an alternative to this page, we highly recommend reading 
  <a href="https://modernjuliaworkflows.github.io/sharing/">Modern Julia Workflows</a>.</p>
  <p>The <i>"Sharing"</i> section can be considered a version of this page for advanced users.</p>
</div>
~~~

* [The Missing Semester of Your CS Education](https://missing.csail.mit.edu/): 
  MIT course covering general programming tools and worflows. Recommended reading:
  * [Using the shell](https://missing.csail.mit.edu/2020/course-shell/)
  * [Version control using Git](https://missing.csail.mit.edu/2020/version-control/)
* [JuliaNotes](https://m3g.github.io/JuliaNotes.jl/stable/):
  Collection of notes on everything from performance tips to package writing 
  