@def title = "Julia Programming for Machine Learning"
@def tags = ["index", "workflows"]

# Enhancing the Julia REPL

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

## Loading code on startup
If you have code that you want to be run every time you start Julia, 
add it to your [startup file](https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file)
that is located at `~/.julia/config/startup.jl`.
Note that you might have to first create the config folder.

A common use-case for the `startup.jl` to load packages that are crucial for your workflow.
Don't add too many packages, as they will increase the loading time of your REPL and might pollute the global namespace.
There are however two packages I personally consider essential additions: *Revise.jl* and *OhMyRepl.jl*.

!!! warning "Warning: First install packages"
    Before adding a package to your `startup.jl`, first add it to your global `(@v1.10)` environment!

## How does this work?

Julia makes use of something called [*stacked environments*](https://docs.julialang.org/en/v1/manual/code-loading/#Environments):

> Stacked environments allow for adding tools to the primary environment. You can push an environment of development tools onto the end of the stack to make them available from the REPL and scripts, but not from inside packages.

Before the environment of a package or project is activated, Julia first loads your global `(@v1.10)` environment and evaluates the code in your `startup.jl`.

## Enhancing the REPL experience
### Revise.jl
[Revise.jl](https://github.com/timholy/Revise.jl) will keep track of changes in loaded files 
and reload modified Julia code without having to start a new REPL session.

To load Revise automatically, add the following code to your `startup.jl`:

```julia
# Add to ~/.julia/config/startup.jl
try
    using Revise
catch e
    @warn "Error initializing Revise in startup.jl" exception=(e, catch_backtrace())
end
```

It is enough to add `using Revise`, 
but the `try-catch` statement will return a helpful error message in case something goes wrong.


!!! tip "VSCode"
    Revise is loaded as part of the [Julia VSCode plugin](https://www.julia-vscode.org).
    If you are using VSCode, adding Revise to your `startup.jl` isn't necessary.

### OhMyRepl.jl
[OhMyRepl](https://github.com/KristofferC/OhMyREPL.jl) adds many features to your REPL,
amongst other things:
- syntax highlighting
- (rainbow) bracket highlighting
- fuzzy history search
- stripping prompts when pasting code

```julia
# Add to ~/.julia/config/startup.jl
atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "Error initializing OhMyRepl in startup.jl" exception=(e, catch_backtrace())
    end
end
```

## Other suggestions

You can also add the following to your `startup.jl`:

* [TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl): Quickly activate your test environment using `TestEnv.activate()`
* [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl): Measure the performance of your code using the `@benchmark` macro. 
* [BasicAutoloads.jl](https://github.com/LilithHafner/BasicAutoloads.jl): "whenever I type this in the REPL, run that for me".
* environment variables via the [`ENV` dictionary](https://docs.julialang.org/en/v1/base/base/#Base.ENV)
* custom functions that you commonly use
