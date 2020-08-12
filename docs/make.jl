using S2Geometry
using Documenter

makedocs(;
    modules=[S2Geometry],
    authors="Tobi Lipede <t.lipede@gmail.com> and contributors",
    repo="https://github.com/tlipede/S2Geometry.jl/blob/{commit}{path}#L{line}",
    sitename="S2Geometry.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tlipede.github.io/S2Geometry.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tlipede/S2Geometry.jl",
)
