


# using Parameters

if !isdefined(@__MODULE__, :MicroSimple)
    include("MicroSimple.jl")
end

using .MicroSimple



mod = BasicModel()

der = derive_basic_probs(mod)