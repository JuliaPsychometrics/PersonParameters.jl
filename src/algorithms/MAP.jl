"""
    $(TYPEDEF)

Maximum posterior estimation of person parameters of item response models.
Use `prior` to specify the prior distribution of ability values.

## Fields
$(FIELDS)
"""
struct MAP{T<:Distribution{Univariate,Continuous}} <: PPA
    "The prior distribution of person abilities"
    prior::T
end

MAP(prior = Normal()) = MAP(prior)

rational_bounds(alg::MAP) = true

function optfun(alg::MAP, M::Type{<:ItemResponseModel}, theta, betas, responses)
    optval = optfun(MLE(), M, theta, betas, responses)
    f(x) = logpdf(alg.prior, x)
    optval += derivative(f, theta)
    return optval
end
