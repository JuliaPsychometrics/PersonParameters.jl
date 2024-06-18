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

struct MLETest <: PPA end

rational_bounds(alg::MLETest) = false

function optfun(
    alg::MLE,
    modeltype::Type{<:PolytomousItemResponseModel},
    theta,
    betas,
    responses,
)
    max_cat = maximum(length(beta.t) for beta in betas) + 1
    probs = zeros(max_cat)

    L_deriv = 0.0
    L_deriv2 = 0.0

    for (beta, y) in zip(betas, responses)
        probs .= 0.0
        @unpack a = beta

        irf!(modeltype, probs, theta, beta)

        for c in eachindex(probs)
            L_deriv -= c * a * probs[c]
            L_deriv2 -= (c * a * probs[c])^2
            L_deriv2 += c^2 * a^2 * probs[c]
        end

        L_deriv += y * a
    end

    optval = L_deriv / L_deriv2

    return optval
end
