module PersonParameters

using Roots: find_zero
using ItemResponseFunctions:
    ItemResponseModel, OneParameterLogisticModel, irf, iif, information

export MLE, WLE, person_parameters
export OneParameterLogisticModel




abstract type PersonParameterAlgorithm end

function optfun end
function se end

struct PersonParameterResult{T<:ItemResponseModel,U<:Real,V<:PersonParameterAlgorithm}
    values::Vector{U}
    standard_errors::Vector{U}
    algorithm::V
end

function person_parameters(
    T::Type{OneParameterLogisticModel},
    betas::AbstractVector{U},
    alg::PersonParameterAlgorithm,
) where {U<:Real}
    I = length(betas)
    thetas = zeros(U, I + 1)
    standard_errors = similar(thetas)
    init_x = zero(U)

    for r in eachindex(thetas)
        if (r == 1 || r == I + 1) && !rational_bounds(alg)
            thetas[r] += NaN
            standard_errors[r] += NaN
            continue
        end

        thetas[r] += find_zero(x -> optfun(alg, T, x, betas, r), init_x)
        standard_errors[r] += se(alg, T, thetas[r], betas)
    end

    return PersonParameterResult{T,U,typeof(alg)}(thetas, standard_errors, alg)
end

include("mle.jl")
include("wle.jl")

end
