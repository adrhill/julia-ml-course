@def title = "Julia Programming for Machine Learning"
@def tags = ["index", "workflows"]

# The Julia REPL

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

## Enhancing the REPL experience
### Loading packages on startup
If you have code that you want to be run every time you start Julia, 
add it to your [startup file](https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file)
that is located at `~/.julia/config/startup.jl`.
Note that you might have to first create this config folder.

A common use-case for the `startup.jl` to load packages that are crucial for your workflow.
Don't add too many packages: 
they will increase the loading time of your REPL and might pollute the global namespace.
There are however two packages I personally consider essential additions: 
*Revise.jl* and *OhMyRepl.jl*.

### Revise.jl
[Revise.jl](https://github.com/timholy/Revise.jl) will keep track of changes in loaded files 
and reload modified Julia code without having to start a new REPL session.

To load Revise automatically, add the following code to your `startup.jl`:

```julia
# First lines of ~/.julia/config/startup.jl
try
    using Revise
catch e
    @warn "Error initializing Revise in startup.jl" exception=(e, catch_backtrace())
end
```

It is enough to add `using Revise`, 
but the `try-catch` statement will return a helpful error message in case something goes wrong.

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
## REPL-based workflows
The most basic workflow uses the Julia REPL in combination with your favorite editor.

### Loading Julia source code
To load a source file, use the command `include`.
To test this, I have created two almost identical files: 
- a file `foo.jl`, which contains a function `foo`
- a file `bar.jl`, which contains a function `bar` inside a module `Bar`

```julia
# Contents of foo.jl
foo(x) = x
```

```julia
# Contents of bar.jl
module Bar

  bar(x) = x

  export bar # export function

end # end module
```

Let's compare the two approaches.
The first one loads all contents of the file into the global namespace

```julia-repl
julia> include("foo.jl")
foo (generic function with 1 method)

julia> foo(2)
2
```

whereas the second approach encapsulates everything inside the module `Bar`.
Via `using .Bar`, we make all functions that are exported in `Bar` available:

```julia-repl
julia> include("bar.jl") # load module Bar
Main.Bar

julia> Bar.bar(2)  # we can access the function in the module...
2

julia> bar(2)      # ...but not directly
ERROR: UndefVarError: bar not defined
Stacktrace:
 [1] top-level scope
   @ REPL[4]:1

julia> using .Bar  # import everything that is exported in module Bar...

julia> bar(2)      # ...so we can use exports without name-spacing Bar
2
```
