"""
    $(TYPEDEF)

Maximum likelihood estimation for person parameters of item response models.
"""
@kwdef struct MLE{T<:Roots.AbstractSecantMethod} <: PPA
    root_finding_alg::T = Order1()
end

rational_bounds(alg::MLE) = false

function optfun(alg::MLE, M::Type{<:ItemResponseModel}, theta, betas, responses)
    f(x) = loglikelihood(M, x, betas, responses)
    optval = derivative(f, theta)
    return optval
end
