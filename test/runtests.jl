using Cones
using Aqua
using Test

using Test
using Values


@testset "Cones.jl" begin
    @testset "Ray Constructors" begin
        # Test constructor with direction only
        ray1 = Ray([1, 2, 3])
        @test ray1.direction == [1, 2, 3]
        @test ray1.apex == [0, 0, 0]

        # Test constructor with direction and apex
        ray2 = Ray([1, 2, 3], [4, 5, 6])
        @test ray2.direction == [1, 2, 3]
        @test ray2.apex == [4, 5, 6]

        # Test conversion constructor
        ray3 = Ray{Float64}([1, 2, 3])
        @test ray3.direction == [1.0, 2.0, 3.0]
        @test ray3.apex == [0.0, 0.0, 0.0]

        # Test copy constructor
        ray4 = Ray(ray2)
        @test ray4.direction == ray2.direction
        @test ray4.apex == ray2.apex
    end

    # Test arithmetic operations
    @testset "Ray Arithmetic Operations" begin
        ray1 = Ray([1, 2, 3], [4, 5, 6])
        ray2 = Ray([3, 2, 1], [6, 5, 4])

        # Test addition
        ray_sum = ray1 + ray2
        @test ray_sum.direction == [4, 4, 4]
        @test ray_sum.apex == [10, 10, 10]

        # Test subtraction
        ray_diff = ray1 - ray2
        @test ray_diff.direction == [-2, 0, 2]
        @test ray_diff.apex == [-2, 0, 2]

        # Test scalar multiplication
        ray_scaled = ray1 * 2
        @test ray_scaled.direction == [2, 4, 6]
        @test ray_scaled.apex == [4, 5, 6]

        # Test scalar multiplication (commutative)
        ray_scaled_comm = 2 * ray1
        @test ray_scaled_comm == ray_scaled

        # Test scalar multiplication with Value
        scalar = Value(2)
        ray_value_scaled = ray1 * scalar
        @test ray_value_scaled.direction == [2, 4, 6]
        @test ray_value_scaled.apex == [4, 5, 6]

        # Test scalar multiplication with Value (commutative)
        ray_value_scaled_comm = scalar * ray1
        @test ray_value_scaled_comm == ray_value_scaled

        # Test negation
        ray_neg = -ray1
        @test ray_neg.direction == [-1, -2, -3]
        @test ray_neg.apex == [4, 5, 6]
    end

    # Test comparison operation
    @testset "Ray Comparison" begin
        ray1 = Ray([1, 2, 3], [4, 5, 6])
        ray2 = Ray([1, 2, 3], [4, 5, 6])
        ray3 = Ray([3, 2, 1], [6, 5, 4])

        @test ray1 == ray2
        @test ray1 != ray3
    end

    # Test flip function
    @testset "Ray Flip" begin
        # Test flipping a simple ray
        ray1 = Ray([1, 2, 3])
        flipped_ray1 = flip(ray1)
        @test flipped_ray1.direction == [-1, -2, -3]
        @test flipped_ray1.apex == [0, 0, 0]

        # Test flipping a ray with negative direction
        ray2 = Ray([-1, -2, -3])
        flipped_ray2 = flip(ray2)
        @test flipped_ray2.direction == [1, 2, 3]
        @test flipped_ray2.apex == [0, 0, 0]

        # Test flipping a ray with a zero direction component
        ray3 = Ray([0, 1, -1])
        flipped_ray3 = flip(ray3)
        @test flipped_ray3.direction == [0, -1, 1]
        @test flipped_ray3.apex == [0, 0, 0]

        # Test flipping a ray with all zero direction
        ray4 = Ray([0, 0, 0])
        flipped_ray4 = flip(ray4)
        @test flipped_ray4.direction == [0, 0, 0]
        @test flipped_ray4.apex == [0, 0, 0]

        # Test flipping a ray with direction and apex
        ray5 = Ray([1, 2, 3], [4, 5, 6])
        flipped_ray5 = flip(ray5)
        @test flipped_ray5.direction == [-1, -2, -3]
        @test flipped_ray5.apex == [4, 5, 6]
    end

    # Test isforward function
    @testset "Ray isforward" begin
        ray1 = Ray([1, 2, 3])
        ray2 = Ray([-1, -2, -3])
        ray3 = Ray([0, 0, 0])
        ray4 = Ray([0, 1, 0])

        @test isforward(ray1) == true
        @test isforward(ray2) == false
        @test isforward(ray3) == true
        @test isforward(ray4) == true
    end
    @testset "Ray Primitive" begin
        # Test with direction that can be normalized
        ray1 = Ray([2, 4, 6])
        prim_ray1 = primitive(ray1)
        @test prim_ray1.direction == [1, 2, 3]
        @test prim_ray1.apex == [0, 0, 0]

        # Test with direction that is already primitive
        ray2 = Ray([1, 2, 3])
        prim_ray2 = primitive(ray2)
        @test prim_ray2.direction == [1, 2, 3]
        @test prim_ray2.apex == [0, 0, 0]

        # Test with direction that includes non-integer components
        ray3 = Ray(([3 // 2, 3 // 1, 9 // 2]))
        prim_ray3 = primitive(ray3)
        @test prim_ray3.direction == [1, 2, 3]
        @test prim_ray3.apex == [0, 0, 0]

        # Test with direction that includes zero elements
        ray4 = Ray([0, 4, 8])
        prim_ray4 = primitive(ray4)
        @test prim_ray4.direction == [0, 1, 2]
        @test prim_ray4.apex == [0, 0, 0]

        # Test with all zero direction
        ray5 = Ray([0, 0, 0])
        prim_ray5 = primitive(ray5)
        @test prim_ray5.direction == [0, 0, 0]
        @test prim_ray5.apex == [0, 0, 0]

        # Test with direction that includes negative components
        ray6 = Ray([-2, -4, -6])
        prim_ray6 = primitive(ray6)
        @test prim_ray6.direction == [-1, -2, -3]
        @test prim_ray6.apex == [0, 0, 0]

        # Test with mixed integer and non-integer components
        ray7 = Ray([5 // 2, 5, 15 // 2])
        prim_ray7 = primitive(ray7)
        @test prim_ray7.direction == [1, 2, 3]
        @test prim_ray7.apex == [0, 0, 0]

        # Test with float
        ray8 = Ray([1.5, 3.0, 4.5])
        @test_throws AssertionError primitive(ray8)
    end

    @testset "Cones vrep_matrix" begin
        # Test case 1: Simple V-rep matrix
        rays1 = [Ray([1, 0, 0]), Ray([0, 1, 0]), Ray([0, 0, 1])]
        apex1 = [0, 0, 0]
        openness1 = [true, true, true]
        cone1 = Cone(rays1, apex1, openness1)
        vrep1 = vrep_matrix(cone1)
        expected_vrep1 = [0 0 1; 0 1 0; 1 0 0]
        @test vrep1 == expected_vrep1

        # Test case 2: V-rep matrix with different rays
        rays2 = [Ray([1, 2, 3]), Ray([4, 5, 6]), Ray([7, 8, 9])]
        apex2 = [1, 1, 1]
        openness2 = [true, false, true]
        cone2 = Cone(rays2, apex2, openness2)
        vrep2 = vrep_matrix(cone2)
        expected_vrep2 = [1 4 7; 2 5 8; 3 6 9]
        @test vrep2 == expected_vrep2
    end

    @testset "Cones flip" begin
        # Test case 1: Flip cone with simple rays
        rays1 = [Ray([1, 0, 0]), Ray([-1, 0, 0])]
        apex1 = [0, 0, 0]
        openness1 = [true, false]
        cone1 = Cone(rays1, apex1, openness1)
        flipped_cone1 = flip(cone1)
        expected_flipped_rays1 = [Ray([1, 0, 0]), Ray([1, 0, 0])]
        expected_flipped_openness1 = [true, true]
        @test flipped_cone1.rays == expected_flipped_rays1
        @test flipped_cone1.openness == expected_flipped_openness1
        @test flipped_cone1.sign == !cone1.sign # 1 flip

        # Test case 2: Flip cone with more complex rays
        rays2 = [Ray([1, 2]), Ray([-3, -4]), Ray([-5, 6])]
        apex2 = [0, 0]
        openness2 = [true, false, true]
        cone2 = Cone(rays2, apex2, openness2)
        flipped_cone2 = flip(cone2)
        expected_flipped_rays2 = [Ray([1, 2]), Ray([3, 4]), Ray([5, -6])]
        expected_flipped_openness2 = [true, true, false]
        @test flipped_cone2.rays == expected_flipped_rays2
        @test flipped_cone2.openness == expected_flipped_openness2
        @test flipped_cone2.sign == cone2.sign # two flips

        # Test case 3: Flip cone with rays having zero direction
        rays3 = [Ray([0, 0, 0]), Ray([1, 0, 0])]
        apex3 = [0, 0, 0]
        openness3 = [true, true]
        cone3 = Cone(rays3, apex3, openness3)
        flipped_cone3 = flip(cone3)
        expected_flipped_rays3 = [Ray([0, 0, 0]), Ray([1, 0, 0])]
        expected_flipped_openness3 = [true, true]
        @test flipped_cone3.rays == expected_flipped_rays3
        @test flipped_cone3.openness == expected_flipped_openness3
        @test flipped_cone3.sign == cone3.sign # * flip

        # Test case 4: Flip cone with all zero rays
        rays4 = [Ray([0, 0, 0]), Ray([0, 0, 0])]
        apex4 = [0, 0, 0]
        openness4 = [true, false]
        cone4 = Cone(rays4, apex4, openness4)
        flipped_cone4 = flip(cone4)
        expected_flipped_rays4 = [Ray([0, 0, 0]), Ray([0, 0, 0])]
        expected_flipped_openness4 = [true, false]
        @test flipped_cone4.rays == expected_flipped_rays4
        @test flipped_cone4.openness == expected_flipped_openness4
        @test flipped_cone4.sign == cone4.sign # 0 flip
    end

    # Test case for substitute_vector
    @testset "substitute_vector" begin
        vec1 = [Value(:x), Value(:y), 3]
        subs1 = Dict(:x => 1, :y => 2)
        result1 = Cones.substitute_vector(vec1, subs1)
        expected_result1 = [1, 2, 3]
        @test result1 == expected_result1

        vec2 = [Value(:a), 2, Value(:b)]
        subs2 = Dict(:a => 5, :b => 10)
        result2 = Cones.substitute_vector(vec2, subs2)
        expected_result2 = [5, 2, 10]
        @test result2 == expected_result2

        # Edge case: no substitution needed
        vec3 = [1, 2, 3]
        subs3 = Dict(:x => 1)
        result3 = Cones.substitute_vector(vec3, subs3)
        expected_result3 = [1, 2, 3]
        @test result3 == expected_result3

        # Edge case: empty vector
        vec4 = Vector{Union{Number,Value}}()
        subs4 = Dict(:x => 1)
        result4 = Cones.substitute_vector(vec4, subs4)
        expected_result4 = []
        @test result4 == expected_result4
    end

    # Test case for substitute_ray
    @testset "substitute_ray" begin
        ray1 = Ray([Value(:x), 2], [Value(:y), 4])
        subs1 = Dict(:x => 1, :y => 3)
        result1 = Cones.substitute_ray(ray1, subs1)
        expected_ray1 = Ray([1, 2], [3, 4])
        @test result1 == expected_ray1

        ray2 = Ray([Value(:a), Value(:b)], [Value(:c), Value(:d)])
        subs2 = Dict(:a => 1, :b => 2, :c => 3, :d => 4)
        result2 = Cones.substitute_ray(ray2, subs2)
        expected_ray2 = Ray([1, 2], [3, 4])
        @test result2 == expected_ray2

        # Edge case: no substitution needed
        ray3 = Ray([1, 2], [3, 4])
        subs3 = Dict(:x => 1)
        result3 = Cones.substitute_ray(ray3, subs3)
        expected_ray3 = Ray([1, 2], [3, 4])
        @test result3 == expected_ray3

        # Edge case: empty direction and apex
        ray4 = Ray(Vector{Union{Number,Value}}(), Vector{Union{Number,Value}}())
        subs4 = Dict(:x => 1)
        result4 = Cones.substitute_ray(ray4, subs4)
        expected_ray4 = Ray([], [])
        @test result4 == expected_ray4
    end

    # Test case for substitute_cone
    @testset "substitute_cone" begin
        rays1 = [Ray([Value(:x), 2], [Value(:y), 4])]
        apex1 = [Value(:z), 6]
        openness1 = [true]
        cone1 = Cone(rays1, apex1, openness1)
        subs1 = Dict(:x => 1, :y => 3, :z => 5)
        result1 = Cones.substitute_cone(cone1, subs1)
        expected_cone1 = Cone([Ray([1, 2], [3, 4])], [5, 6], [true])
        @test result1.rays == expected_cone1.rays
        @test result1.apex == expected_cone1.apex
        @test result1.openness == expected_cone1.openness
        @test result1.sign == expected_cone1.sign

        rays2 = [Ray([Value(:a)], [Value(:b)])]
        apex2 = [Value(:c)]
        openness2 = [false]
        cone2 = Cone(rays2, apex2, openness2)
        subs2 = Dict(:a => 1, :b => 2, :c => 3)
        result2 = Cones.substitute_cone(cone2, subs2)
        expected_cone2 = Cone([Ray([1], [2])], [3], [false])
        @test result2.rays == expected_cone2.rays
        @test result2.apex == expected_cone2.apex
        @test result2.openness == expected_cone2.openness
        @test result2.sign == expected_cone2.sign

        # Edge case: no substitution needed
        rays3 = [Ray([1], [2])]
        apex3 = [3]
        openness3 = [true]
        cone3 = Cone(rays3, apex3, openness3)
        subs3 = Dict(:x => 1)
        result3 = Cones.substitute_cone(cone3, subs3)
        expected_cone3 = Cone([Ray([1], [2])], [3], [true])
        @test result3.rays == expected_cone3.rays
        @test result3.apex == expected_cone3.apex
        @test result3.openness == expected_cone3.openness
        @test result3.sign == expected_cone3.sign

        # Edge case: empty rays and apex
        rays4 = Vector{Ray{Union{Number,Value}}}()
        apex4 = Vector{Union{Number,Value}}()
        openness4 = Bool[]
        cone4 = Cone(rays4, apex4, openness4)
        subs4 = Dict(:x => 1)
        result4 = Cones.substitute_cone(cone4, subs4)
        expected_cone4 = Cone(Vector{Ray{Number}}(), Vector{Number}(), Bool[])
        @test result4.rays == expected_cone4.rays
        @test result4.apex == expected_cone4.apex
        @test result4.openness == expected_cone4.openness
        @test result4.sign == expected_cone4.sign
    end

    @testset "CombinationOfCones" begin
        conepos = Cone([[1, 2], [1, 3]], [4, 3], [false, false], true)
        coneneg = Cone([[1, 2], [1, 3]], [4, 3], [false, false], false)
        coneother = Cone([[5, 2], [1, 3]], [4, 3], [true, false], true)
        combination = CombinationOfCones{Int}()
        @test size(combination.cones, 1) == 0
        combination += conepos
        @test size(combination.cones, 1) == 1
        @test combination.cones[1][2] == 1
        combination += conepos
        @test size(combination.cones, 1) == 1
        @test combination.cones[1][2] == 2
        combination += coneneg
        @test size(combination.cones, 1) == 1
        @test combination.cones[1][2] == 1
        combination += coneneg
        @test size(combination.cones, 1) == 0
        combination += coneneg
        @test size(combination.cones, 1) == 1
        @test combination.cones[1][2] == 1
        combination += coneneg
        @test size(combination.cones, 1) == 1
        @test combination.cones[1][2] == 2
        combination += coneother
        @test size(combination.cones, 1) == 2
        @test combination.cones[1][2] == 2
    end
end

@testset "Cones.jl Aqua" begin
    Aqua.test_all(Cones)
end
