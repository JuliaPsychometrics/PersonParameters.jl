"""
    PersonParameterWLE

Warm's weighted likelihood estimation for person parameters of item response models.

# References

- Warm, T. A. (1989). Weighted likelihood estimation of ability in item response theory. Psychometrika, 54, 427-450. doi: 10.1007/BF02294627
"""
struct WLE <: PPA end

rational_bounds(alg::WLE) = true

function optfun(alg::WLE, M::Type{<:ItemResponseModel}, theta, betas, responses)
    optval = optfun(MLE(), M, theta, betas, responses)
    bias = zero(optval)

    for beta in betas
        probs, derivs, derivs2 = second_derivative_theta(M, theta, beta)
        bias += sum(@. derivs * derivs2 / probs)
    end

    info = information(M, theta, betas)
    bias *= (-1 / (2 * info^2))

    return optval - info * bias
end
