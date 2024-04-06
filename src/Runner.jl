


# using Parameters

if !isdefined(@__MODULE__, :MicroSimple)
    include("MicroSimple.jl")
end

using .MicroSimple



mod = BasicModel()

@time begin
res_treat = micro_sim(mod, true)
res_no_treat = micro_sim(mod, false)
end 

