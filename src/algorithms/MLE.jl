"""
    $(TYPEDEF)

Maximum likelihood estimation for person parameters of item response models.
"""
struct MLE <: PersonParameterAlgorithm end

rational_bounds(alg::MLE) = false

function optfun(alg::MLE, modeltype, theta, betas, responses)
    optval = 0.0

    adtype = AutoForwardDiff()

    for (beta, y) in zip(betas, responses)
        ismissing(y) && continue
        f = x -> irf(modeltype, x, beta, 1)
        prob, deriv = value_and_derivative(f, adtype, theta)
        optval += ((y - prob) * deriv) / (prob * (1 - prob))
    end

    return optval
end
