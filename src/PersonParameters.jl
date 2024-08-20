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
    second_derivative_theta,
    likelihood,
    loglikelihood

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

export EAP,
    MAP,
    MLE,
    PersonParameter,
    PersonParameterAlgorithm,
    PersonParameterResult,
    ResponsePatterns,
    WLE,
    algorithm,
    ids,
    modeltype,
    patterns,
    person_parameter,
    person_parameters,
    score,
    se,
    value

include("response_patterns.jl")
include("algorithms/algorithms.jl")
include("person_parameters.jl")

include("precompile.jl")

end
