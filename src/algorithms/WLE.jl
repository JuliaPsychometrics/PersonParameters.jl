"""
    PersonParameterWLE

Warm's weighted likelihood estimation for person parameters of item response models.

# References

- Warm, T. A. (1989). Weighted likelihood estimation of ability in item response theory. Psychometrika, 54, 427-450. doi: 10.1007/BF02294627
"""
struct WLE <: PersonParameterAlgorithm end

rational_bounds(alg::WLE) = true

function optfun(alg::WLE, modeltype, theta, betas, responses)
    optval = 0.0

    adtype = AutoForwardDiff()

    for (beta, y) in zip(betas, responses)
        f = x -> irf(modeltype, x, beta, 1)
        prob, deriv = value_and_derivative(f, adtype, theta)

        p1mp = prob * (1 - prob)
        optval += ((y - prob) * deriv) / p1mp

        # bias correction
        deriv2 = second_derivative(f, adtype, theta)
        i = deriv^2 / p1mp
        j = deriv * deriv2 / p1mp
        optval += j / 2 * i
    end

    return optval
end

