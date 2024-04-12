module Cones

include("Ray.jl")
include("Cone.jl")
include("CombinationOfCones.jl")

export Ray, Cone, CombinationOfCones, vrep_matrix, flip

end
