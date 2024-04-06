module MicroSimple

using Parameters

const Strings = Vector{String}
const Floats = Vector{Float64}


include("Model.jl")
include("Logic.jl")

export Strings, Floats, BasicModel,  BasicModelProbs

export derive_basic_probs

end # module MicroSimple
