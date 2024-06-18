"""
    $(TYPEDEF)

Maximum posterior estimation of person parameters of item response models.
Use `prior` to specify the prior distribution of ability values.

## Fields
$(FIELDS)
"""
struct MAP{T<:Distribution{Univariate,Continuous},V} <: PPA
    "The prior distribution of person abilities"
    prior::T
    "The automatic differentiation type"
    adtype::V
end

MAP(prior = Normal(); adtype = AutoForwardDiff()) = MAP(prior, adtype)

rational_bounds(alg::MAP) = true

function optfun(alg::MAP, modeltype::Type{<:ItemResponseModel}, theta, betas, responses)
    optval = optfun(MLE(), modeltype, theta, betas, responses)
    optval += derivative(x -> logpdf(alg.prior, x), alg.adtype, theta)
    return optval
end
