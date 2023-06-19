using Dates

const julia_shield = "https://img.shields.io/badge/edit-Julia%20source%20code-beige"
const pluto_shield = "https://img.shields.io/badge/view-Standalone%20Notebook-beige"
const issue_shield = "https://img.shields.io/badge/open-GitHub%20issue-beige"
const issue_url = "https://github.com/adrhill/julia-ml-course/issues"

function generate_iframes(d::Date = today())
    dir = @__DIR__ # expected to be /website
    lectures = filter(endswith(".jl"), readdir(joinpath(dir, "..", "lectures")))
    homework = filter(endswith(".jl"), readdir(joinpath(dir, "..", "homework")))
    date_string = "Date($(Dates.year(d)), $(Dates.month(d)), $(Dates.day(d)))"

    for filename in lectures
        outpath = joinpath(dir, replace(filename, ".jl" => ".md"))
        julia_url = "https://github.com/adrhill/julia-ml-course/tree/main/lectures/$(filename)"
        pluto_url = "https://adrhill.github.io/julia-ml-course/lectures/$(replace(filename, ".jl" => ".html"))"

        open(outpath, "w") do io
            write(
                io,
                """
                +++
                title = "Lecture $filename"
                hascode = false
                author = "Adrian Hill"
                date = $(date_string)
                tags = ["lecture", "notebook"]
                +++

                <!--
                DO NOT MODIFY. File is automatically generated in website/generate_iframes.jl.
                -->

                ~~~
                <div class="badge-container">
                    <a href="$julia_url"><img class="badge" src=$julia_shield></a>
                    <a href="$pluto_url"><img class="badge" src=$pluto_shield></a>
                    <a href="$issue_url"><img class="badge" src=$issue_shield></a>
                </div>

                <div id="iframe-container">
                    <iframe id="pluto_notebook" frameborder="0" $(filename)" src="$pluto_url"></iframe>
                </div>
                ~~~
                """,
            )
        end
    end

    for filename in homework
        outpath = joinpath(dir, replace(filename, ".jl" => ".md"))
        julia_url = "https://github.com/adrhill/julia-ml-course/tree/main/homework/$(filename)"
        pluto_url = "https://adrhill.github.io/julia-ml-course/homework/$(replace(filename, ".jl" => ".html"))"

        open(outpath, "w") do io
            write(
                io,
                """
                +++
                title = "Homework $filename"
                hascode = false
                author = "Adrian Hill"
                date = $(date_string)
                tags = ["homework", "notebook"]
                +++

                <!--
                DO NOT MODIFY. File is automatically generated in website/generate_iframes.jl.
                -->

                ~~~
                <div class="badge-container">
                    <a href="$julia_url"><img class="badge" src=$julia_shield></a>
                    <a href="$pluto_url"><img class="badge" src=$pluto_shield></a>
                    <a href="$issue_url"><img class="badge" src=$issue_shield></a>
                </div>

                <div id="iframe-container">
                    <iframe id="pluto_notebook" frameborder="0" $(filename)" src="$pluto_url"></iframe>
                </div>
                ~~~
                """,
            )
        end
    end
end
