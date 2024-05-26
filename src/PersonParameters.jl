module PersonParameters

using DifferentiationInterface:
    AutoForwardDiff, derivative, second_derivative, value_and_derivative
using Distributions: Normal, Distribution, Univariate, Continuous, logpdf
using ItemResponseFunctions: ItemResponseModel, irf, iif, information
using DocStringExtensions: TYPEDEF, SIGNATURES, FIELDS
using Reexport: @reexport
using Roots: find_zero

import ForwardDiff

@reexport using ItemResponseFunctions:
    OneParameterLogisticModel,
    OnePL,
    OneParameterLogisticPlusGuessingModel,
    OnePLG,
    TwoParameterLogisticModel,
    TwoPL,
    ThreeParameterLogisticModel,
    ThreePL,
    FourParameterLogisticModel,
    FourPL,
    FiveParameterLogisticModel,
    FivePL

export PersonParameter, PersonParameterResult, PersonParameterAlgorithm
export MAP, MLE, WLE, person_parameters, person_parameter
export value, se, score

include("algorithms/algorithms.jl")
include("person_parameters.jl")

end
