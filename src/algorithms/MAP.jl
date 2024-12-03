"""
    $(TYPEDEF)

Maximum posterior estimation of person parameters of item response models.
Use `prior` to specify the prior distribution of ability values.

## Fields
$(FIELDS)
"""
struct MAP{T<:Distribution{Univariate,Continuous},U<:Roots.AbstractSecantMethod} <: PPA
    "The prior distribution of person abilities"
    prior::T
    root_finding_alg::U
end

MAP(prior = Normal(); root_finding_alg = Order1()) = MAP(prior, root_finding_alg)

rational_bounds(alg::MAP) = true

function optfun(alg::MAP, M::Type{<:ItemResponseModel}, theta, betas, responses)
    mle_alg = MLE(root_finding_alg = alg.root_finding_alg)
    optval = optfun(mle_alg, M, theta, betas, responses)
    f(x) = logpdf(alg.prior, x)
    optval += derivative(f, theta)
    return optval
end
