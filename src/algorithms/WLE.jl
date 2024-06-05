"""
    PersonParameterWLE

Warm's weighted likelihood estimation for person parameters of item response models.

# References

- Warm, T. A. (1989). Weighted likelihood estimation of ability in item response theory. Psychometrika, 54, 427-450. doi: 10.1007/BF02294627
"""
struct WLE <: PPA end

rational_bounds(alg::WLE) = true

function optfun(
    alg::WLE,
    modeltype::Type{<:DichotomousItemResponseModel},
    theta,
    betas,
    responses,
)
    optval = zero(theta)

    for (beta, y) in zip(betas, responses)
        prob, deriv, deriv2 = second_derivative_theta(modeltype, theta, beta, 1)

        # MLE value
        p1mp = prob * (1 - prob)
        optval += ((y - prob) * deriv) / p1mp

        # bias correction
        i = deriv^2 / p1mp
        j = deriv * deriv2 / p1mp
        optval += j / 2 * i
    end

    return optval
end
