module Cones

include("Ray.jl")
include("Cone.jl")
include("CombinationOfCones.jl")
include("EnumerateFundamentalParallelepiped.jl")
include("ComputeRationalFunction.jl")

export
    # Types
    Ray,
    Cone,
    CombinationOfCones,
    # Functions
    vrep_matrix,
    flip,
    enumerate_fundamental_parallelepiped,
    compute_rational_function,
    compute_rational_function_str

end
