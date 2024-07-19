using PersonParameters
using Documenter
using DocumenterVitepress

DocMeta.setdocmeta!(
    PersonParameters,
    :DocTestSetup,
    :(using PersonParameters);
    recursive = true,
)

makedocs(;
    sitename = "PersonParameters.jl",
    authors = "Philipp Gewessler",
    modules = [PersonParameters],
    warnonly = true,
    checkdocs = :all,
    format = DocumenterVitepress.MarkdownVitepress(;
        repo = "github.com/JuliaPsychometrics/PersonParameters.jl",
        devbranch = "main",
        devurl = "dev",
    ),
    clean = true,
    draft = false,
    source = "src",
    build = "build",
    pages = [
        "Home" => "index.md",
        "Getting started" => "getting-started.md",
        "Guides" => [
            "Online estimation of ability in adaptive testing" => "guides/adaptive-testing.md",
        ],
        "References" => ["Treatment of missing values" => "references/missing-values.md"],
        "API" => "api.md",
    ],
)

deploydocs(;
    repo = "github.com/JuliaPsychometrics/PersonParameters.jl",
    target = "build",
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true,
)
