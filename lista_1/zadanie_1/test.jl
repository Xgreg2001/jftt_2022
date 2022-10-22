using Test
include("finite_automata.jl")
include("KMP.jl")

for test_file in readdir("test")
    if test_file in readdir("solutions")
        @testset "FA Test $test_file" begin
            text = String(read("test/$test_file"))

            for line in readlines("solutions/$test_file")
                pattern, sol = split(line, "' ", limit=2)
                pattern = replace(pattern, "\\n" => "\n")
                pattern_array = collect(pattern)[2:end]
                sol = sol == "[]" ? [] : parse.(Int, String.(split(sol[2:end-1], ", ")))
                @test fa_matcher(text, pattern_array) == sol
            end
        end

        @testset "KMP Test $test_file" begin
            text = String(read("test/$test_file"))
            text_array = collect(text)

            for line in readlines("solutions/$test_file")
                pattern, sol = split(line, "' ", limit=2)
                pattern = replace(pattern, "\\n" => "\n")
                pattern_array = collect(pattern)[2:end]
                sol = sol == "[]" ? [] : parse.(Int, String.(split(sol[2:end-1], ", ")))
                @test kmp_matcher(text_array, pattern_array) == sol
            end
        end
    else
        error("Brak pliku z rozwiązaniem dla testu: ", test_file)
    end
end