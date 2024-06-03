using Polynomials

function compute_rational_function(cone::Cone{T}, parallelepipeds::Vector{Vector{Int}}, x::Union{Vector}) where {T<:Number}
    num = 0
    for p in parallelepipeds
        num += Polynomials.create_monomial_from_exponents(p, x)
    end

    den = 1
    for ray in cone.rays
        den *= (1 - Polynomials.create_monomial_from_exponents(ray.direction, x))
    end

    return CombinationOfRationalFunctions(Pair(num * (-1)^(!cone.sign), den))
end


function compute_rational_function_str(cone::Cone{T}, parallelepipeds::Vector{Vector{Int}}) where {T<:Number}
    function create_monomial_str_from_exponents(z::Vector{<:Number})
        tmp = ""
        for i in eachindex(z)
            if length(tmp) > 0
                tmp = tmp * " * " * "x$(i)^($(z[i]))"
            else
                tmp = "x$(i)^($(z[i]))"
            end
        end
        return "(" * tmp * ")"
    end
    num = ""
    for p in parallelepipeds
        if (length(num) > 0)
            num = num * " + " * create_monomial_str_from_exponents(p)
        else
            num = create_monomial_str_from_exponents(p)
        end
    end
    den = ""
    for ray in cone.rays
        if (length(den) > 0)
            den = den * " * " * "(1 - $(create_monomial_str_from_exponents(ray.direction)))"
        else
            den = "(1 - $(create_monomial_str_from_exponents(ray.direction)))"
        end
    end
    res = "(" * num * ")/(" * den * ")"
    if (!cone.sign)
        res = "-(" * res * ")"
    end
    return res
end
