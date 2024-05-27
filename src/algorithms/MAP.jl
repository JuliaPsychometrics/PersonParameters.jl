"""
    $(TYPEDEF)

Maximum posterior estimation of person parameters of item response models.
Use `prior` to specify the prior distribution of ability values.

## Fields
$(FIELDS)
"""
struct MAP{T<:Distribution{Univariate,Continuous}} <: PersonParameterAlgorithm
    "The prior distribution of person abilities"
    prior::T
end

MAP() = MAP(Normal())

rational_bounds(alg::MAP) = true

function optfun(alg::MAP, modeltype, theta, betas, responses)
    optval = optfun(MLE(), modeltype, theta, betas, responses)
    optval += ForwardDiff.derivative(x -> logpdf(alg.prior, x), theta)
    return optval
end

