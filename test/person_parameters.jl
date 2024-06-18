algorithms = [MLE(), WLE(), MAP(), MAP(Uniform(-1, 1))]

@testset "estimation" begin
    @testset "person_parameter" begin
        betas = fill((a = 1.2, b = 0.33, c = 0.1, d = 0.7, e = 0.9, t = (0.0)), 6)
        responses = [0, 0, 0, 1, 1, 1]

        for model in [OnePL, TwoPL, ThreePL, FourPL, FivePL]
            for alg in algorithms
                pp = person_parameter(model, responses, betas, alg)
                @test pp isa PersonParameter
                @test isfinite(value(pp))
                @test se(pp) > 0
            end
        end

        # dichotomous methods and polytomous methods should produce equivalent results for
        # 2 categories.
        pp_dich = person_parameter(TwoPL, responses, betas, MLE())
        pp_poly = person_parameter(GPCM, responses .+ 1, betas, MLE())

        @test value(pp_dich) ≈ value(pp_poly)
        @test se(pp_dich) ≈ se(pp_poly)

        pp_dich = person_parameter(OnePL, responses, betas, MLE())
        pp_poly = person_parameter(PCM, responses .+ 1, betas, MLE())

        @test value(pp_dich) ≈ value(pp_poly)
        @test se(pp_dich) ≈ se(pp_poly)
    end
end
