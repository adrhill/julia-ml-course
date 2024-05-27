
# Package tests

In this section, we add tests to the package we started in [Writing Packages](/write).

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents



## Running tests
By convention, package tests are located in a folder called `test`.
The main file that includes all other tests is called `runtest.jl`.

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

All of our tests passed since we didn't have any!

## Adding tests

Using the [Test.jl](https://docs.julialang.org/en/v1/stdlib/Test/) package from the Julia standard library,
we can add tests to our package:

* `@testset` macros are used to organize to organize your tests and can be arbitrarily nested.
* `@test` macros evaluate whether the expression next to them is `true`. If not, the testset failed.

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

Let's run our new test:

```julia-repl
(MyPackage) pkg> test
     Testing Running tests...
Test Summary: | Pass  Total  Time
MyPackage.jl  |    1      1  0.0s
     Testing MyPackage tests passed 
```

For comparisons on floating point numbers which contain numerical errors, use `isapprox` (`≈`) instead of `==`.

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
It is good practice to include **all** required dependencies in these files, as we will see in the next section.

```julia
# contents of `test/test_timestwo.jl`
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
    The following workflow is completely optional and only useful on large projects.

Every time you run your tests through Pkg's `test` command, Julia resolves a fresh virtual environment for testing. It also runs the **entire** test suite. 
This is great for the purpose of reproducibility but it can waste a lot of time when you want to quickly iterate on a project with many dependencies.

The package [TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl) allows you to quickly activate a copy of your test environment using the function `TestEnv.activate()`.
By [adding `using TestEnv` to your `startup.jl`](/repl), it is always available to you.

Once you activated your test environment, you can manually include individual test files.
This is the reason why it is good practice to include all required dependencies in each file.

```julia-repl
julia> TestEnv.activate()
"/var/folders/lx/07x6z_b908gd4wd3v_wf2b4c0000gn/T/jl_jsA8yy/Project.toml"

(jl_jsA8yy) pkg>  # new copy of your test environment

julia> include("test/test_timestwo.jl");
Test Summary: | Pass  Total  Time
timestwo      |    1      1  0.1s
```
Using [OhMyREPL](/repl), you can move through your REPL history using the up-arrow. This allows you to quickly re-run your tests by calling `include("test/test_timestwo.jl");` again.

## Further reading
- [Test.jl documentation](https://docs.julialang.org/en/v1/stdlib/Test/)
- [*Modern Julia Workflows* on testing](https://modernjuliaworkflows.github.io/sharing/#testing)
