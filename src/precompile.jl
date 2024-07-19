using PrecompileTools: @setup_workload, @compile_workload

@setup_workload begin
    models = [OnePL, OnePLG, TwoPL, ThreePL, FourPL, FivePL, PCM, GPCM, RSM, GRSM]
    beta = (; a = 1.0, b = 0.0, c = 0.0, d = 1.0, e = 1.0, t = zeros(1))
    betas = fill(beta, 3)
    responses = Int.(rand(10, 3) .> 0.5)

    @compile_workload begin
        algorithms = [MLE(), WLE(), MAP(), EAP()]

        for model in models
            for alg in algorithms
                data = model <: DichotomousItemResponseModel ? responses : responses .+ 1
                person_parameters(model, data, betas, alg)
            end
        end
    end
end
