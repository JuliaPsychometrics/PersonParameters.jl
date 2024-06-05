@testset "MLE" begin
    @test rational_bounds(MLE()) == false
    @test person_parameter(OnePL, zeros(3), randn(3), MLE()) == PersonParameter(-Inf, Inf)
    @test person_parameter(OnePL, ones(3), randn(3), MLE()) == PersonParameter(Inf, Inf)

    responses = [0, 0, missing]
    @test person_parameter(OnePL, responses, randn(3), MLE()) == PersonParameter(-Inf, Inf)
end
