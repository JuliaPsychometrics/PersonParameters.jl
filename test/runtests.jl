using Test

using PersonParameters
using PersonParameters: rational_bounds, get_unique_response_patterns

using Distributions
@testset "PersonParameters.jl" begin
    include("response_patterns.jl")
    include("algorithms/MLE.jl")
    include("algorithms/WLE.jl")
    include("algorithms/MAP.jl")
    include("person_parameters.jl")
end
