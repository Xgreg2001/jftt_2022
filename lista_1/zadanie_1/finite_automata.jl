using BenchmarkTools

delta_dictionary = Dict([])

function fa_matcher(T::String, P::Array{Char})
    m = length(P)
    q = 0

    for (i, a) in Iterators.enumerate(T)
        q = fa_delta(P, q, a, m)
        if q == m
            print("Pattern occurs with shift $(i - m)\n")
        end
    end
end

function fa_is_suffix(word::Array{Char}, sufix::Array{Char})
    n = length(sufix)
    return sufix == word[end - n + 1:end]
end



function fa_delta(P::Array{Char}, q::Int64, a::Char, m::Int64)
    if haskey(delta_dictionary, (q, a))
        return delta_dictionary[(q, a)]
    end

    k = min(m, q + 1)

    while !fa_is_suffix(push!(P[1:q],a) , P[1:k])
        k = k - 1
    end
    delta_dictionary[(q, a)] = k

    return k
end

function main()
    if (length(ARGS) < 2)
        return -1
    end
    pattern = ARGS[1]
    file_path = ARGS[2]

    pattern_array = collect(pattern)

    text = String(read(file_path))

    fa_matcher(text, pattern_array)
end

main()