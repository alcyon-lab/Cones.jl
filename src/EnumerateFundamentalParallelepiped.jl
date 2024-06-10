using NormalForms
using IterTools
using LinearAlgebra

function enumerate_fundamental_parallelepiped(cone::Cone{T}) where {T<:Number}
    vrep = Matrix{Int}(vrep_matrix(cone))
    SNFRes = NormalForms.snf(vrep)
    S = SNFRes.S
    Uinv = SNFRes.U
    Winv = SNFRes.V
    dimension = size(vrep, 2) # num of rows
    ambientDimension = size(vrep, 1) # num of cols
    diagonals = Int64[]
    for i in 1:dimension
        if (i <= size(S, 1) && i <= size(S, 2))
            push!(diagonals, S[i, i])
        end
    end
    lastDiagonal = diagonals[end]
    # sprime = [Integer(sk / si) for si in s]
    sprimeDiagonals = Int64[]
    for d in diagonals
        push!(sprimeDiagonals, Int64(lastDiagonal // d))
    end
    sprime = diagm(sprimeDiagonals)
    apex = cone.apex
    qhat = Uinv * apex
    Wprime = Winv * sprime
    qtrans = [sum([-Wprime[j, i] * qhat[i] for i = 1:dimension]) for j = 1:dimension]
    qfrac = [qtrans[i] - floor(Int, qtrans[i]) for i = 1:dimension]
    qint = [floor(Int, qi) for qi in qtrans]
    qsummand = [Int64(qi) for qi in (lastDiagonal * apex + vrep * qfrac)]
    openness = [(qfrac[j] == 0 ? cone.openness[j] : false) for j in 1:dimension]
    #bigP
    #res1 = [[1:1:diagonals[i];] for i= 1:dimension]
    # CartesianProduct( *[xrange(s[i]) for i in 1:k] )
    f = let qint = qint, Wprime = Wprime, openness = openness, lastDiagonal = lastDiagonal, ambientDimension = ambientDimension, vrep = vrep
        function (v)
            innerRes = mod.(Wprime * v .+ qint, lastDiagonal)
            innerRes = [inner == 0 && openness[j] ? lastDiagonal : inner for (inner, j) in zip(innerRes, 1:length(openness))]
            outerRes = vrep * innerRes
            finalRes = collect(Int64(ai + bi // lastDiagonal) for (ai, bi) in zip(outerRes, qsummand))
            return finalRes
        end
    end
    return (f(collect(x)) for x in IterTools.product([(0:diagonals[i]-1) for i in 1:dimension]...))
end
