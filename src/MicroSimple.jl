module MicroSimple

using Parameters, Random, OrderedCollections, StatsBase

const Strings = Vector{String}
const Floats = Vector{Float64}
const MatFloat = Matrix{Float64}


include("Model.jl")
include("Logic.jl")

export Strings, Floats, MatFloat
export BasicModel, Results 

export basic_probs, micro_sim

end # module MicroSimple
