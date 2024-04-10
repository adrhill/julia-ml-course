@def title = "Julia Programming for Machine Learning"
@def tags = ["index", "profiling", "debugging"]

# Debugging & Logging

In this lesson, we are going to take a look at debugging and profiling.
Since type inference is central to writing performant Julia code,
we will also take a look at how to fix inference problems.

We will demonstrate both the Julia VSCode extension and editor-agnostic packages.

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

Let's assume we want to compute the sum of 
[proper divisors](https://mathworld.wolfram.com/ProperDivisor.html) of some integer $n$.

As an example, the proper divisors of 4 are the numbers 1 and 2, but not 4 itself.
The sum of the proper divisors of 4 is therefore 1 + 2 = 3.

Assume you want to debug the following implementation

```julia
function sum_of_divisors(n)
    proper_divisors = filter(x -> n % x == 0, 1:n)
    return sum(proper_divisors)
end
```

which currently returns the wrong result for $n = 4$:

```julia-repl
sum_of_divisors(4) # ⚠️ should return 3, but returns 7
7
```

### VSCode extension
Using the Julia VSCode extension, we can click on the left on the left-most column 
of an editor pane to add a *breakpoint*, which is visualized by a red circle. 
This can be seen under point 1 in the following screenshot:

![VSCode debugging](/assets/vscode_debug.png)

By going into the Debugging pane of the Julia VSCode extension (point 2),
we can click *Run and Debug* to start the debugger.

The program will automatically pause at the first breakpoint.
Using the toolbar (point 3) at the top of the editor, we can 
*continue*, *step over*, *step into* and *step out* of our code.

On the left pane, we can see the local variables inside of the current function
as well as their current values (point 4). 
Not shown on the screenshot is additional information like the call stack of the function.

Using the information from the variables viewer, we can see that 
`sum_of_divisors(4)` incorrectly computes the list of proper divisors `[1, 2, 4]` instead of the expected `[1, 2]`.
This might help us figure out that 
the bug is in the range of our for-loop:
inside `filter`, we should iterate over `1:(n-1)` instead of `1:n`.


~~~
<div class="admonition tip">
  <p class="admonition-title">Tip</p>
  <p>Check out the 
  <a href="https://www.julia-vscode.org/docs/stable/userguide/debugging/">debugging documentation</a>
  of the Julia VSCode extension for more information.</p>
</div>
~~~

### Debugger.jl
If you prefer to work with other editors, 
[Debugger.jl](https://github.com/JuliaDebug/Debugger.jl)
is one of several alternative debuggers in Julia.

Using the `@enter` macro, we can enter a function call and step through it.
The prompt changes to `1|debug>`, indicating Debugger-mode, 
and we can use 
[Debugger.jl's custom commands](https://github.com/JuliaDebug/Debugger.jl#debugger-commands) to move through our code.
The list of commands can be also be shown by typing `help` in Debugger-mode.

```julia-repl
julia> using Debugger 

julia> @enter sum_of_divisors(4)
In sum_of_divisors(n) at REPL[11]:1
 1  function sum_of_divisors(n)
>2      proper_divisors = filter(x -> n % x == 0, 1:n)
 3      return sum(proper_divisors)
 4  end

1|debug> u 3 # step (u)ntil line 3
In sum_of_divisors(n) at REPL[2]:1
 1  function sum_of_divisors(n)
 2      divisors = filter(x -> n % x == 0, 1:n)
>3      return sum(divisors)
 4  end

About to run: (sum)([1, 2, 4])
```

Once again, we find out that `sum_of_divisors(4)` incorrectly returned included the number 4 in the list of proper divisors.

### Infiltrator.jl
[Infiltrator.jl](https://github.com/JuliaDebug/Infiltrator.jl) is an alternative to
Debugger.jl which allows you to set breakpoints in your code using the `@infiltrate` macro.
Calling a function which hits a breakpoint will activate the Infiltrator REPL-mode
and change the prompt to `infil>`.

Similar to Debugger.jl, Infilitrator provides its own set of commands,
which can be shown by typing `?` in Infiltrator-mode.
In the following example, we use the `@locals` command to print all local variables:

```julia-repl
julia> using Infiltrator

julia> function sum_of_divisors(n)
           proper_divisors = filter(x -> n % x == 0, 1:n)
           @infiltrate
           return sum(proper_divisors)
       end
sum_of_divisors (generic function with 1 method)

julia> sum_of_divisors(4)
Infiltrating (on thread 1) sum_of_divisors(n::Int64)
  at REPL[14]:3

infil> @locals
- n::Int64 = 4
- proper_divisors::Vector{Int64} = [1, 2, 4]
```

Again, we find out that `sum_of_divisors(4)` incorrectly included the number 4 in `proper_divisors`.

## Logging
We've been using the logging macro `@info` frequently in this lecture.
Three other logging macros exist: `@warn`, `@error` and `@debug`.
We will demonstrate the use of the `@debug` macro on the example from the previous section:

```julia
# Content of logging.jl

function sum_of_divisors(n)
    proper_divisors = filter(x -> n % x == 0, 1:n)
    @debug "sum_of_divisors" n proper_divisors
    return sum(proper_divisors)
end

sum_of_divisors(4) # function call
``` 

### Enabling `@debug` messages
By default, `@debug` messages are suppressed.
Running the `logging.jl` file from the command line therefore doesn't output anything:

```bash
$ julia logging.jl
# No output!
```

Debug logging can be enabled through the `JULIA_DEBUG` environment variable
by specifying the module name, e.g. `Main`. 
We can either do this by setting an environment variable 
or by prefixing our command-line call to `julia`. 


```bash
$ JULIA_DEBUG=Main julia logging.jl
┌ Debug: sum_of_divisors
│   n = 4
│   proper_divisors =
│    3-element Vector{Int64}:
│     1
│     2
│     4
└ @ Main ~/logging.jl:9
```

This correctly logged our debug message 
as well as the source file and line of code on which it was called.

Environment variables can also be set inside of your Julia source code,
e.g. by adding the following line to the top of the `logging.jl` file:

```julia
ENV["JULIA_DEBUG"] = Main
```

### Saving logs to a file
Using the Logging.jl module from Julia base, we can create a 
[`SimpleLogger`](https://docs.julialang.org/en/v1/stdlib/Logging/#Logging.SimpleLogger)
which writes logging messages to an IO object, which can be a text file.
```julia
using Logging

io = open("log.txt", "w+") # open text file for writing
logger = SimpleLogger(io)  # simplistic logger that writes into IO-Stream (e.g. our file)

function sum_of_divisors(n)
    proper_divisors = filter(x -> n % x == 0, 1:n)
    @debug "sum_of_divisors" n proper_divisors
    return sum(proper_divisors)
end

# Call function with logger
with_logger(logger) do
    sum_of_divisors(4)
end

# Write buffered messages to file
flush(io)
close(io)
```

Calling this with the `JULIA_DEBUG=Main` environment variable successfully creates a `log.txt` file:
```bash
$ cat log.txt
┌ Debug: sum_of_divisors
│   n = 4
│   proper_divisors =
│    3-element Vector{Int64}:
│     1
│     2
│     4
└ @ Main /Users/funks/.julia/dev/DebugTestPackage/src/logging.jl:14
```

If we don't just want to log a single function call, we can also create a `global_logger`:

```julia
using Logging

io = open("log.txt", "w+") # open text file for writing
logger = SimpleLogger(io)  # simplistic logger that writes into IO-Stream (e.g. our file)
global_logger(logger)      # use `logger` as global logger

function sum_of_divisors(n)
    proper_divisors = filter(x -> n % x == 0, 1:n)
    @debug "sum_of_divisors" n proper_divisors
    return sum(proper_divisors)
end

sum_of_divisors(4) # all function calls are logged

# Write buffered messages to file
flush(io)
close(io)
```

~~~
<div class="admonition warning">
  <p class="admonition-title">Logging debug messages</p>
  <p>Logging messages from the <code>@debug</code> macro always requires
  setting the <code>JULIA_DEBUG</code> environment variable.</p>
</div>
~~~

## Acknowledgements
The code snippet was adapted from Ole Kröger's blog post 
[*"Debugging in Julia - Two different ways"*](https://opensourc.es/blog/basics-debugging/).
