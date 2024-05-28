
# Package tests

In this section, we add tests to the package we started in [Writing a Package](/write).

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents



## Running tests
By convention, package tests are located in a folder called `test`.
The "main" file that includes all other tests is called `runtest.jl`.

```julia
# Contents of test/runtests.jl
using MyPackage
using Test

@testset "MyPackage.jl" begin
    # Write your tests here.
end
```

To run your test suite, enter Pkg-mode and write `test`: 

```julia-repl
julia> # type ] to enter Pkg mode

(MyPackage) pkg> test
    Testing MyPackage
      Status `/private/var/folders/74/wcz8c9qs5dzc8wgkk7839k5c0000gn/T/jl_TcJkwR/Project.toml`

     ... # Julia resolves a temporary environment from scratch
    
     Testing Running tests...
Test Summary: |Time
MyPackage.jl  | None  0.0s
     Testing MyPackage tests passed
```

All of our tests pass since **we don't have any** that could fail!

## Adding tests

Using the [Test.jl](https://docs.julialang.org/en/v1/stdlib/Test/) package from the Julia standard library,
we can add tests to our package:

* `@test` macros evaluate whether the expression next to them is `true`. If it isn't, the test failed.
* `@testset` macros are used to organize and name your tests.
  Test-sets can be arbitrarily nested and can contain multiple tests and test-sets. 
  You can even put them into for-loops and other control-flow structures.

```julia
# New contents of test/runtests.jl
using MyPackage
using Test

@testset "MyPackage.jl" begin
    @testset "timestwo" begin
      @test timestwo(4.0) == 8.0
    end
end
```

Let's run our new test suite:

```julia-repl
(MyPackage) pkg> test
     Testing Running tests...
Test Summary: | Pass  Total  Time
MyPackage.jl  |    1      1  0.0s
     Testing MyPackage tests passed 
```

To compare floating point numbers, which may contain numerical rounding errors, use `isapprox` or `≈` (`\approx<TAB>`) instead of `==`.
The `isapprox` function allows you to specify absolute and relative numerical tolerances.

## Adding test dependencies

Your `test` folder contains its own Julia environment, defined in `test/Project.toml`.
To add additional test dependencies, first activate your test environment and add dependencies using Pkg as usual:

```julia-repl
julia> # type ] to enter Pkg mode

(MyPackage) pkg> activate test
  Activating project at `~/.julia/dev/MyPackage/test`

(test) pkg> add Flux # adding Flux as an example
```

Once a dependency has been added, it can be used in your test suite.

```julia
# New contents of test/runtests.jl
using MyPackage
using Test

using Flux # use new dependency 

@testset "MyPackage.jl" begin
    @testset "timestwo" begin
      @test timestwo(4.0) == 8.0
      ... # other tests using Flux
    end
end
```

## Organizing your tests

Just like your source code, your test suite can be organized into several smaller files using the `include` function.
It is good practice to include **all** required dependencies **in each** of these files, as we will see in the next section.

```julia
# New test file `test/test_timestwo.jl`
using MyPackage
using Test
using Flux

@testset "timestwo" begin
    @test timestwo(4.0) == 8.0
    ... # other tests using Flux
end
```

```julia
# New contents of test/runtests.jl
using MyPackage
using Test

@testset "MyPackage.jl" begin
    include("test_timestwo.jl") # <--- include tests in runtest.jl
end
```

## Advanced testing workflows

!!! tip
    The following workflow is completely optional but useful on large projects.

Every time you run your tests through Pkg's `test` command, Julia resolves a fresh virtual environment for testing. It also runs the **entire** test suite. 
This is great for the purpose of reproducibility but it can waste a lot of time when you want to quickly iterate on a project with many dependencies.

The [TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl) package allows you to activate a copy of your test environment using the function `TestEnv.activate()`.
By adding `using TestEnv` to your [startup file](/repl), it is always available to you.

Once you activated your test environment, you can manually include individual test files.
This is the reason why it is good practice to include all required dependencies in each test file.

```julia-repl
julia> TestEnv.activate()
"/var/folders/lx/07x6z_b908gd4wd3v_wf2b4c0000gn/T/jl_jsA8yy/Project.toml"

(jl_jsA8yy) pkg>  # new copy of your test environment

julia> include("test/test_timestwo.jl"); # run only one test file
Test Summary: | Pass  Total  Time
timestwo      |    1      1  0.1s
```
Using [OhMyREPL](/repl), you can move through your REPL history using the up and down arrow keys. This allows you to quickly re-run your tests by calling your previous command `include("test/test_timestwo.jl");` again.

## Further reading
- [Test.jl documentation](https://docs.julialang.org/en/v1/stdlib/Test/)
- [*Modern Julia Workflows* on testing](https://modernjuliaworkflows.github.io/sharing/#testing)
