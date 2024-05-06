module PersonParameters

using Roots: find_zero
using ItemResponseFunctions:
    ItemResponseModel, OneParameterLogisticModel, irf, iif, information

export MLE, WLE, person_parameters, person_parameter
export OneParameterLogisticModel
export value, se, score

abstract type PersonParameterAlgorithm end

function optfun end
function se end

struct PersonParameter{U<:Real}
    value::U
    se::U
    score::Int
end

value(pp::PersonParameter) = pp.value
se(pp::PersonParameter) = pp.se
score(pp::PersonParameter) = pp.score

struct PersonParameterResult{
    T<:ItemResponseModel,
    U<:PersonParameter,
    V<:PersonParameterAlgorithm,
}
    values::Vector{U}
    algorithm::V
end

Base.getindex(pp::PersonParameterResult, i) = getindex(pp.values, i)

function person_parameters(
    T::Type{OneParameterLogisticModel},
    scores::AbstractVector{Int},
    betas::AbstractVector{U},
    alg::PersonParameterAlgorithm,
) where {U<:Real}
    thetas = [person_parameter(T, score, betas, alg) for score in scores]
    return PersonParameterResult{T,eltype(thetas),typeof(alg)}(thetas, alg)
end

function person_parameter(
    T::Type{OneParameterLogisticModel},
    score::Int,
    betas::AbstractVector{U},
    alg::PersonParameterAlgorithm,
) where {U<:Real}
    I = length(betas)
    init_x = zero(U)

    if !rational_bounds(alg)
        if score == 0
            return PersonParameter(-Inf, Inf, score)
        elseif score == I
            return PersonParameter(Inf, Inf, score)
        end
    end

    theta = find_zero(x -> optfun(alg, T, x, betas, score + 1), init_x)
    standard_error = se(alg, T, theta, betas)

    return PersonParameter(theta, standard_error, score)
end

include("mle.jl")
include("wle.jl")

end
