using Documenter, ColorProfiles
using FileIO, MD5

makedocs(clean = false,
         warnonly = true, # FIXME
         checkdocs = :exports,
         modules = [ColorProfiles, ProfileClasses],
         format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
                                  assets = ["assets/favicon.ico"]),
         sitename = "ColorProfiles",
         pages = [
             "Introduction" => "index.md",
             "Loader/Saver" => "loader-saver.md",
             "Basic Types" => "basic-types.md",
             "Tags" => "tags.md",
             "Tagged Types" => "tagged-types.md",
             "Type Mapping" => "type-mapping.md",
             "Utilities" => "utilities.md"
         ])

deploydocs(repo = "github.com/kimikage/ColorProfiles.jl.git",
           devbranch = "main",
           push_preview = true)
