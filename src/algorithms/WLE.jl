"""
    $(TYPEDEF)

Warm's weighted likelihood estimation for person parameters of item response models.

# References

- Warm, T. A. (1989). Weighted likelihood estimation of ability in item response theory. Psychometrika, 54, 427-450. doi: 10.1007/BF02294627
"""
@kwdef struct WLE{T<:Roots.AbstractSecantMethod} <: PPA
    root_finding_alg::T = Order1()
end

rational_bounds(alg::WLE) = true

function optfun(alg::WLE, M::Type{<:ItemResponseModel}, theta, betas, responses)
    mle_alg = MLE(root_finding_alg = alg.root_finding_alg)
    optval = optfun(mle_alg, M, theta, betas, responses)
    bias = zero(optval)

    for beta in betas
        probs, derivs, derivs2 = second_derivative_theta(M, theta, beta)
        bias += sum(derivs[i] * derivs2[i] / probs[i] for i in eachindex(probs))
    end

    info = information(M, theta, betas)
    bias *= (-1 / (2 * info^2))

    return optval - info * bias
end
