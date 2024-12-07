using PRIMME
using Documenter

DocMeta.setdocmeta!(PRIMME, :DocTestSetup, :(using PRIMME); recursive=true)

makedocs(;
    modules=[PRIMME],
    authors="Raye Kimmerer <raye@rayegun.com> and contributors",
    sitename="PRIMME.jl",
    format=Documenter.HTML(;
        canonical="https://rayegun.github.io/PRIMME.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/rayegun/PRIMME.jl",
    devbranch="main",
)
