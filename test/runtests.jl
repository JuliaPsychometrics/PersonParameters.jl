using Test

using PersonParameters

@testset "PersonParameters.jl" begin
    @testset "OneParameterLogisticModel" begin
        # The implemented algorithms to compute person parameter estimates
        # are tested against reported values from Rost (2004).
        betas = [-1.17, -0.69, 0.04, 0.7, 1.12]

        @testset "MLE" begin
            pp = person_parameters(OnePL, betas, MLE())

            @test length(pp.values) == length(betas) + 1
            @test isnan(pp.values[1])
            @test isnan(pp.values[end])
            @test pp.values[2:(end-1)] ≈ [-1.59, -0.47, 0.48, 1.59] atol = 0.01

            @test isnan(pp.standard_errors[1])
            @test isnan(pp.standard_errors[end])
            @test pp.standard_errors[2:(end-1)] ≈ [1.18, 0.99, 0.99, 1.17] atol = 0.01
        end

        @testset "Warm's Weighted Likelihood Estimation" begin
            pp = person_parameters(OneParameterLogisticModel, betas, WLE())
            @test length(pp.values) == length(betas) + 1
            @test pp.values ≈ [-2.77, -1.33, -0.41, 0.42, 1.33, 2.75] atol = 0.01
            @test pp.standard_errors ≈ [1.71, 1.11, 0.98, 0.98, 1.11, 1.71] atol = 0.01
        end
    end
end
