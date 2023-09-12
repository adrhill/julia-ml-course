@def title = "Julia programming for Machine Learning"
@def tags = ["index", "profiling", "debugging"]

# Lesson 9: Profiling and Debugging

In this lesson, we are going to take a look at debugging and profiling.
Since type inference is central to writing performant Julia code,
we will also take a look at how to fix inference problems.

We will demonstrate both the Julia VSCode extension and editor-agnostic packages.

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

~~~
<div class="admonition note">
  <p class="admonition-title">Note</p>
  <p>These notes are designed to accompany a live demonstration in the 
  <i>Julia programming for Machine Learning</i> class at TU Berlin.</p>
</div>
~~~


## Debugging
To demonstrate the debugger, we are going to borrow an example from 
Ole Kröger's blog-post [*Debugging in Julia - Two different ways*](https://opensourc.es/blog/basics-debugging/).

The following code is supposed to compute whether two numbers $a$ and $b$ are *amicable*,
meaning that the sum of divisors of $a$ is $b$ and vice-versa.

Knowing that 220 and 284 are amicable numbers, the following script should return `true`:

```julia
function is_amicable(a, b)
    return sum_divisors(a) == b && sum_divisors(b) == a
end

function sum_divisors(a)
    result = 0
    for i = 1:a
        if a % i == 0
            result += i
        end
    end
    return result
end

# We know that 220 and 284 are amicable numbers
is_amicable(220, 284)
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
`sum_divisors(220)` incorrectly returned `504` instead of the expected `284`.
Since `504 - 284 = 220`, this might help us figure out that 
the bug is in the range of our for-loop:
we should iterate over `1:(a-1)` instead of `1:a`.


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

Using the `@enter` macro, we can enter a function call and step through it:

![Debugger.jl](/assets/debugger.png)

The prompt changes to `1|debug>` and allows us to step through code using
[Debugger.jl's commands](https://github.com/JuliaDebug/Debugger.jl#debugger-commands).
The screenshot above demonstrates two of these: 
* `s` to step into the next call
* `sr` to step until the next `return`

Once again, we find out that `sum_divisors(220)` incorrectly returned `504`.

### Infiltrator.jl
[Infiltrator.jl](https://github.com/JuliaDebug/Infiltrator.jl) is an alternative to
Debugger.jl which allows you to set breakpoints in your code using the `@infiltrate` macro.

Calling a function which hits a breakpoint will activate the Infiltrator REPL-mode
and change the prompt to `infil>`. 
Typing `?` in this mode will bring up help.

![Infiltrator.jl](/assets/infiltrator.png)

In this example, we use `@locals` to print local variables,
and find out that `sum_divisors(220)` incorrectly returned `504`.

## Logging
We've been using the logging macro `@info` frequently in this lecture.
Three other logging macros exist: `@warn`, `@error` and `@debug`.
We will demonstrate the use of the `@debug` macro on the example from the previous section:

```julia
# Content of logging.jl

function is_amicable(a, b)
    return sum_divisors(a) == b && sum_divisors(b) == a
end

function sum_divisors(a)
    result = 0
    for i = 1:a
        if a % i == 0
            result += i
        end
    end
    @debug "Got sum of divisors $result for input $a"  # add debug message logging
    return result
end

is_amicable(220, 284) # function call
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
┌ Debug: Got sum of divisors 504 for input 220
└ @ Main ~/logging.jl:14
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

function is_amicable(a, b)
    return sum_divisors(a) == b && sum_divisors(b) == a
end

function sum_divisors(a)
    result = 0
    for i = 1:a
        if a % i == 0
            result += i
        end
    end
    @debug "Got sum of divisors $result for input $a"
    return result
end

# Call function with logger
with_logger(logger) do
    is_amicable(220, 284)
end

# Write buffered messages to file
flush(io)
close(io)
```

Calling this with the `JULIA_DEBUG=Main` environment variable successfully creates a `log.txt` file:
```bash
$ cat log.txt
┌ Debug: Got sum of divisors 504 for input 220
└ @ Main /Users/funks/.julia/dev/DebugTestPackage/src/logging.jl:17
```

If we don't just want to log a single function call, we can also create a `global_logger`:

```julia
using Logging

io = open("log.txt", "w+") # open text file for writing
logger = SimpleLogger(io)  # simplistic logger that writes into IO-Stream (e.g. our file)
global_logger(logger)      # use `logger` as global logger

function is_amicable(a, b)
    return sum_divisors(a) == b && sum_divisors(b) == a
end

function sum_divisors(a)
    result = 0
    for i = 1:a
        if a % i == 0
            result += i
        end
    end
    @debug "Got sum of divisors $result for input $a"
    return result
end

is_amicable(220, 284) # all function calls are logged

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

## Profiling 
To demonstrate profiling, we are going to use an example from the 
[ProfileView.jl](https://github.com/timholy/ProfileView.jl) documentation:

```julia
function profile_test(n)
    for i = 1:n
        A = randn(100,100,20)
        m = maximum(A)
        Am = mapslices(sum, A; dims=2)
        B = A[:,:,5]
        Bsort = mapslices(sort, B; dims=1)
        b = rand(100)
        C = B.*b
    end
end
```

Note that this function runs the inner computation `n`-times 
to obtain a more accurate profile.

### VSCode extension
To run the profiler from the Julia VSCode extension, 
simply call your code using the `@profview` macro.
It is recommended to call this twice: 
once to trigger compilation and once to obtain the actual profile:

```julia
@profview profile_test(1)  # run once to trigger compilation (ignore this one)
@profview profile_test(10) # measure runtime
```

![VSCode profiling](/assets/vscode_profile.png)

After calling the macro (point 1), our code is highlighted by a bar plot, 
indicating how much time is spent in each line of code (point 2).

A more detailed view on this can be found in the profiler window.
After selecting the relevant thread (point 3), we can inspect the flame graph 
of our function call (point 4).

Vertically, this graph visualizes the call stack of our function, 
with the "root" function call at the top and "leaves" at the bottom.
Hovering your mouse over a block will indicate the function name, 
as well as its source file and corresponding line number.

The duration of each function call is visualized by the horizontal space 
each block takes up in the graph. On this machine, most time was spent allocating 
the large random matrix `A`.

The color of the blocks also contains information:
* Yellow indicates calls to the garbage collector. 
  If you see many of these, you might want to use `@views` instead of allocating memory.
* Red indicates *run-time dispatch*: the Julia compiler can't infer which types
  a function is going to encounter before actually running the code.
  We will see how to fix these using Cthulhu.jl at the end of this lecture.

#### Importance of type inference
Let's take a look at a [second example from ProfileView.jl](https://github.com/timholy/ProfileView.jl) 
to highlight the importance of type inference:

```julia
function profile_test_sort(n, len=100000)
    for i = 1:n
        list = []
        for _ in 1:len
            push!(list, rand())
        end
        sort!(list)
    end
end

@profview profile_test_sort(1)  # run once to trigger compilation (ignore this one)
@profview profile_test_sort(10) # measure runtime
```

Since `list = []` is of type `Vector{Any}`, Julia can't infer its type.
This is also visible in the profile, which looks fragmented and contains many red blocks:

![VSCode type inference 1](/assets/vscode_profile_stab_1.png)

As expected, the function is quite slow:

```julia-repl 
julia> @time profile_test_sort(10)
  0.442308 seconds (1.00 M allocations: 41.165 MiB, 1.31% gc time)
```

By changing the third line to `list = Float64[]`, the Julia compiler can infer that 
it is working with a `Vector{Float64}` and generate more performant code.
We can see in the profiler that the generated code is much simpler and type stable: 

![VSCode type inference 2](/assets/vscode_profile_stab_2.png)

```julia-repl 
julia> @time profile_test_sort(10)
  0.034384 seconds (140 allocations: 25.986 MiB, 14.58% gc time)
```

This corresponds to a 10x increase in performance!

### ProfileView.jl
Instead of using VSCode, we can make use of 
[ProfileView.jl](https://github.com/timholy/ProfileView.jl) to profile our code,
which uses the same `@profview` macro:

```julia-repl
julia> using ProfileView

julia> function profile_test_sort(n, len=100000)
           for i = 1:n
               list = []
               for _ in 1:len
                   push!(list, rand())
               end
               sort!(list)
           end
       end
profile_test_sort (generic function with 1 method)

julia> @profview profile_test_sort(1)
Gtk.GtkWindowLeaf(...)

julia> @profview profile_test_sort(10)
Gtk.GtkWindowLeaf(...)
```

This will open a new GTK window with the profile.
The only difference to VSCode is that the flame graph is flipped vertically:

![ProfileView.jl output](/assets/profileview_2.png)


## Type stability
Since we've seen how important type inference is for performance,
we are going to demonstrate two tools that help us find inference problems.

For this purpose, we are going to use an example from the 
[Cthulhu.jl](https://github.com/JuliaDebug/Cthulhu.jl) documentation:

```julia
function foo()
    T = rand() > 0.5 ? Int64 : Float64
    sum(rand(T, 100))
end
```

This function "flips a coin" to determine whether `T` is the type `Int64` or `Float64`.
It then samples 100 numbers of type `T` and sums them up. 

### `@code_warntype`
The output of `@code_warntype` is similar to to that of `@code_lowered`, which printed 
the *intermediate representation* (IR) of our Julia code.
However, `@code_warntype` additionally shows type information:

![@code_warntype example](/assets/code_warntype_2.png)

We can see type-stable statements in blue/cyan: 
* `rand()` returns a `Float64`
* `rand() > 0.5` returns a `Bool`

Highlighted in yellow are "small concrete unions", for example:
* `T`, which is a union type of two types: `Union{Type{Float64}, Type{Int64}}`
* our random array of size 100, which is a `Union{Vector{Float64}, Vector{Int64}}`
* the return value of `sum`, which is a `Union{Float64, Int64}`

[These union types are not always a problem](https://julialang.org/blog/2018/08/union-splitting/), 
as long as they don't result in a combinatorial explosion of possible types.

A big disadvantage of `@code_warntype` is that it only shows us inferred types
for the exact function call we applied the macro to. 
Type instabilities in inner functions calls are not always visible.

### Cthulhu.jl
~~~
<div class="admonition warning">
  <p class="admonition-title">Warning</p>
  <p>This is a tool for advanced users
  and might be confusing to beginners.</p>
</div>
~~~

[Cthulhu.jl](https://github.com/JuliaDebug/Cthulhu.jl) is the advanced user's version
of `@code_warntype`. It allows us to recursively "descend deeper" into our code
until we find a point at which inference failed.

Calling `@descend` on a function will start a command-line interface
to interactively explore our code with type-annotations.
Since this interface is pretty dense in information, it can look intimidating:

![Cthulhu.jl example](/assets/cthulhu_1.png)

At the top of the output (orange box), the original source code is shown with additional annotations of inferred types, e.g. `Union{Float64, Int64}`.
By default, source code format is used, which can be nicer than `@code_warntype`'s IR.

The second section (green box) shows the interactive interface of Cthulhu.jl.
The letters in `[ ]` brackets are the keys that need to be typed to toggle options.
For example, pressing the `w` key will highlight union types in yellow 
and code with poor type inferability in red:

![Cthulhu.jl highlighting](/assets/cthulhu_2.png)

The bottom-most section (purple box) allows us to move deeper into the code.
Using the arrow keys, the cursor `•` (pink box) can be moved to select a specific function call.
Hitting enter will recursively "descend" into the code.
To "ascend", place the cursor over `↩` and hit enter.

## Acknowledgements
The code snippet used for debugging was taken from Ole Kröger's blog-post 
[*Debugging in Julia - Two different ways*](https://opensourc.es/blog/basics-debugging/).
Snippets for profiling from 
[ProfileView.jl](https://github.com/timholy/ProfileView.jl)
and [Cthulhu.jl](https://github.com/JuliaDebug/Cthulhu.jl).
Many thanks to Théo Galy-Fajou for helpful discussions.