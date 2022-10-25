

function fa_matcher(T::String, P::Array{Char})
    delta_dictionary = Dict([])

    solution::Array{Int} = []
    m = length(P)
    q = 0

    for (i, a) in Iterators.enumerate(T)
        q = fa_delta(P, q, a, m, delta_dictionary)
        if q == m
            push!(solution, i - m)
        end
    end

    return solution
end

function fa_is_suffix(word::Array{Char}, sufix::Array{Char})
    n = length(sufix)
    return sufix == word[end-n+1:end]
end



function fa_delta(P::Array{Char}, q::Int64, a::Char, m::Int64, delta_dictionary)
    if haskey(delta_dictionary, (q, a))
        return delta_dictionary[(q, a)]
    end

    k = min(m, q + 1)

    while !fa_is_suffix(push!(P[1:q], a), P[1:k])
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

    sol = fa_matcher(text, pattern_array)

    println(sol)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end