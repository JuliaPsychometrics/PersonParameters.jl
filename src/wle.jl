"""
    PersonParameterWLE

Warm's weighted likelihood estimation for person parameters of Rasch models

# References

- Warm, T. A. (1989). Weighted likelihood estimation of ability in item response theory. Psychometrika, 54, 427-450. doi: 10.1007/BF02294627
"""
struct WLE <: PersonParameterAlgorithm end

rational_bounds(::WLE) = true

function optfun(::WLE, T::Type{OneParameterLogisticModel}, theta, betas, r::Int)
    score = zero(theta)
    info = zero(theta)
    deriv = zero(theta)

    for beta in betas
        item_score = irf(T, theta, beta, 1)
        item_info = (1 - item_score) * item_score

        score += item_score
        info += item_info
        deriv += item_info * (1 - (2 * item_score))
    end

    return (r - 1) - (score - (deriv / (2 * info)))
end

function se(::WLE, T::Type{OneParameterLogisticModel}, theta, betas)
    # variance equal (asymptotically) to variance of MLE (Warm, 1989)
    return se(MLE(), T, theta, betas)
end
