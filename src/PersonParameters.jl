module PersonParameters

using Distributions: Normal, Distribution, Univariate, Continuous, logpdf
using DocStringExtensions: TYPEDEF, SIGNATURES, FIELDS, METHODLIST
using ForwardDiff: derivative
using ItemResponseFunctions:
    ItemResponseModel,
    DichotomousItemResponseModel,
    irf,
    iif,
    information,
    derivative_theta,
    second_derivative_theta
using Reexport: @reexport
using Roots

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

export PersonParameter,
    PersonParameterResult,
    PersonParameterAlgorithm,
    MAP,
    MLE,
    WLE,
    person_parameters,
    person_parameter,
    value,
    se,
    score,
    modeltype,
    algorithm

include("utils.jl")
include("algorithms/algorithms.jl")
include("person_parameters.jl")

end
