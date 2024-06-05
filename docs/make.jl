using PersonParameters
using Documenter

DocMeta.setdocmeta!(
    PersonParameters,
    :DocTestSetup,
    :(using PersonParameters);
    recursive = true,
)

makedocs(;
    checkdocs = :exported,
    modules = [PersonParameters],
    authors = "Philipp Gewessler",
    sitename = "PersonParameters.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://juliapsychometrics.github.io/PersonParameters.jl",
        edit_link = "main",
        repolink = "https://github.com/JuliaPsychometrics/PersonParameters.jl/blob/{commit}{path}#{line}",
        assets = String[],
    ),
    pages = ["Home" => "index.md", "API" => "api.md"],
    plugins = [],
)

deploydocs(; repo = "github.com/JuliaPsychometrics/PersonParameters.jl", devbranch = "main")
