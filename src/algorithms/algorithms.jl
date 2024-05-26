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

"""
    $(SIGNATURES)

The optimization function passed to the root finding algorithm.
"""
function optfun(alg::PersonParameterAlgorithm, modeltype, theta, betas, responses) end

"""
    $(SIGNATURES)

Calculate the standard error for a person parameter estimate `theta` given an estimation
algorithm (`alg`), a model type (`modeltype`), and item parameters (`betas`).
"""
function se(alg::PersonParameterAlgorithm, modeltype, theta, betas)
    info = information(modeltype, theta, betas)
    return sqrt(inv(info))
end

include("MLE.jl")
include("WLE.jl")
include("MAP.jl")
