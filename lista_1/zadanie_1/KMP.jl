function kmp_matcher(T::Array{Char}, P::Array{Char})::Array{Int}
    sol::Vector{Int} = []

    n = length(T)
    m = length(P)
    pie = compute_prefix_function(P)
    q = 0
    for i in 1:n
        while q > 0 && P[q+1] != T[i]
            q = pie[q]
        end

        if P[q+1] == T[i]
            q = q + 1
        end
        if q == m
            push!(sol, i - m)
            q = pie[q]
        end
    end

    return sol
end

function compute_prefix_function(P::Array{Char})::Array{Int64}
    m = length(P)
    pie = zeros(Int64, m)

    k = 0
    for q in 2:m
        while k > 0 && P[k+1] != P[q]
            k = pie[k]

        end
        if P[k+1] == P[q]
            k = k + 1
        end
        pie[q] = k
    end
    return pie
end

function main()
    if (length(ARGS) < 2)
        return -1
    end
    pattern = ARGS[1]
    file_path = ARGS[2]

    pattern_array = collect(pattern)

    text = String(read(file_path))

    text_array = collect(text)

    sol = kmp_matcher(text_array, pattern_array)

    println(sol)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end