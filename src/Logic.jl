
function derive_basic_probs(m::BasicModel)
    @unpack p_HD, rr_S1, rr_S2, p_HS1, p_S1H, p_S1S2 = m

    r_HD = -log(1 - p_HD)        # rate of death when healthy
    r_S1D = rr_S1 * r_HD     # rate of death when sick
    r_S2D = rr_S2 * r_HD    # rate of death when sicker
    p_S1D = 1 - exp(-r_S1D)  # probability to die when sick
    p_S2D = 1 - exp(-r_S2D) # probability to die when sicker

    h = [1 - p_HS1 - p_HD; p_HS1; 0.0; p_HD]
    s1 =  [p_S1H; 1- p_S1H - p_S1S2 - p_S1D; p_S1S2; p_S1D]
    s2 =  [0.0; 0.0; 1 - p_S2D; p_S2D]


    return BasicModelProbs(
        H = h,
        S1 = s1,
        S2 = s2
    )

end

function cost(m::BasicModel, state::String, is_treatement::Bool)
    @unpack c_H, c_S1, c_S2, c_Trt = m


    state == "D" && return 0.0
    state == "H" && return c_H

    ### Sick states S1, S2
    treat_cost::Float64 = is_treatement ? c_Trt : 0.0
    return state == "S1" ? c_S1 + treat_cost : c_S2 + treat_cost

end

function effs(m::BasicModel, state::String, is_treatement::Bool, cycles::Int)
    @unpack u_H, u_S1, u_S2, u_Trt = m

    state == "D" && return 0.0

    if state == "H"
        u = u_H
    elseif state == "S1"
        u = is_treatement ? u_Trt : u_S1
    else # S2
        u = u_S2
    end
    return u * cycles
end

