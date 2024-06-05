"""
    $(TYPEDEF)

Maximum likelihood estimation for person parameters of item response models.
"""
struct MLE <: PPA end

rational_bounds(alg::MLE) = false

function optfun(
    alg::MLE,
    modeltype::Type{<:DichotomousItemResponseModel},
    theta,
    betas,
    responses,
)
    optval = zero(theta)

    for (beta, y) in zip(betas, responses)
        prob, deriv = derivative_theta(modeltype, theta, beta, 1)
        optval += ((y - prob) * deriv) / (prob * (1 - prob))
    end

    return optval
end
