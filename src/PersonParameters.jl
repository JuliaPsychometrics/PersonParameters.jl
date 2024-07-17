module PersonParameters

using Distributions: Normal, Distribution, Univariate, Continuous, logpdf
using DocStringExtensions: TYPEDEF, SIGNATURES, FIELDS, METHODLIST
using Enzyme: autodiff, autodiff_deferred, Const, Duplicated, DuplicatedNoNeed, Forward
using ItemResponseFunctions:
    ItemResponseModel,
    DichotomousItemResponseModel,
    PolytomousItemResponseModel,
    irf,
    irf!,
    iif,
    information,
    derivative_theta,
    second_derivative_theta,
    second_derivative_theta!,
    expected_score
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
