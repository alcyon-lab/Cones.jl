using Cones
using Documenter

DocMeta.setdocmeta!(Cones, :DocTestSetup, :(using Cones); recursive=true)

makedocs(;
    modules=[Cones],
    authors="Alcyon Lab",
    repo="https://github.com/alcyon-lab/Cones.jl/blob/{commit}{path}#{line}",
    sitename="Cones.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
