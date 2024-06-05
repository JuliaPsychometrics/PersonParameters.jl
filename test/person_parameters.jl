algorithms = [MLE(), WLE(), MAP(), MAP(Uniform(-1, 1))]

@testset "estimation" begin
    @testset "person_parameter" begin
        betas = fill((a = 1.2, b = 0.0, c = 0.1, d = 0.7, e = 0.9), 6)
        responses = [0, 0, 0, 1, 1, 1]

        for model in [OnePL, TwoPL, ThreePL, FourPL, FivePL]
            for alg in algorithms
                pp = person_parameter(model, responses, betas, alg)
                @test pp isa PersonParameter
                @test isfinite(value(pp))
                @test se(pp) > 0
            end
        end
    end
end
