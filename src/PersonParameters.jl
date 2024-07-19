module PersonParameters


using Distributions: Normal, Distribution, Univariate, Continuous, logpdf, pdf
using DocStringExtensions: TYPEDEF, SIGNATURES, FIELDS, METHODLIST
using Folds
using ForwardDiff: derivative
using QuadGK: quadgk

using ItemResponseFunctions:
    DichotomousItemResponseModel,
    ItemParameters,
    ItemResponseModel,
    PolytomousItemResponseModel,
    derivative_theta,
    expected_score,
    iif,
    information,
    irf!,
    irf,
    second_derivative_theta!,
    second_derivative_theta

using Reexport: @reexport
using Roots
using SimpleUnPack: @unpack

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
    FivePL,
    PCM,
    PartialCreditModel,
    GPCM,
    GeneralizedPartialCreditModel,
    RSM,
    RatingScaleModel,
    GRSM,
    GeneralizedRatingScaleModel

export PersonParameter,
    PersonParameterResult,
    PersonParameterAlgorithm,
    EAP,
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

include("precompile.jl")

end
