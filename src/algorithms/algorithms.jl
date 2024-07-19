"""
    $(TYPEDEF)

An abstract type representing an estimation algorithm for person parameters of an item
response model.

Each algorithm must implement the following functions:

- [`optfun`](@ref): The optimization function passed to the root finding algorithm
- [`se`](@ref): Calculation of the standard error of estimation.
                Defaults to ``1/\\sqrt{I(\\theta)}``, where ``I`` is the test information at ``\\theta``.
"""
abstract type PersonParameterAlgorithm end

const PPA = PersonParameterAlgorithm

function optimize(alg::PPA, M::Type{<:ItemResponseModel}, betas, responses; init, kwargs...)
    prob = ZeroProblem(x -> optfun(alg, M, x, betas, responses), init)
    theta = solve(prob, Order1(); kwargs...)
    standard_error = se(alg, M, theta, betas)
    return PersonParameter{typeof(theta)}(theta, standard_error)
end

"""
    $(SIGNATURES)

The optimization function passed to the root finding algorithm.
"""
function optfun(alg::PPA, M::Type{<:ItemResponseModel}, theta, betas, responses) end

"""
    $(SIGNATURES)

Calculate the standard error for a person parameter estimate `theta` given an estimation
algorithm (`alg`), a model type (`M`), and item parameters (`betas`).
"""
function se(alg::PPA, M::Type{<:ItemResponseModel}, theta, betas)
    info = information(M, theta, betas)
    return sqrt(inv(info))
end



include("MLE.jl")
include("WLE.jl")
include("MAP.jl")
include("EAP.jl")
