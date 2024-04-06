
function basic_probs(m::BasicModel)

    @unpack p_HD, rr_S1, rr_S2, p_HS1, p_S1H, p_S1S2 = m

    r_HD = -log(1 - p_HD)        # rate of death when healthy
    r_S1D = rr_S1 * r_HD     # rate of death when sick
    r_S2D = rr_S2 * r_HD    # rate of death when sicker
    p_S1D = 1 - exp(-r_S1D)  # probability to die when sick
    p_S2D = 1 - exp(-r_S2D) # probability to die when sicker

    ## Transition prob vectors 
    d::Floats = [0; 0; 0; 1]
    h::Floats = [1 - p_HS1 - p_HD; p_HS1; 0; p_HD]
    s1::Floats = [p_S1H; 1 - p_S1H - p_S1S2 - p_S1D; p_S1S2; p_S1D]
    s2::Floats = [0; 0; 1 - p_S2D; p_S2D]


    return OrderedDict{String,Floats}("D" => d,
        "H" => h,
        "S1" => s1,
        "S2" => s2)
end

function basic_costs(m::BasicModel, is_treatement::Bool)
    @unpack c_H, c_S1, c_S2, c_Trt = m
    treat_cost::Int = is_treatement ? c_Trt : 0

    return OrderedDict{String,Int}("D" => 0,
        "H" => c_H,
        "S1" => c_S1 + treat_cost,
        "S2" => c_S2 + treat_cost)

end

function basic_effs(m::BasicModel, is_treatement::Bool)
    @unpack u_H, u_S1, u_S2, u_Trt = m

    return OrderedDict{String,Float64}("D" => 0,
    "H" => u_H,
    "S1" => is_treatement ? u_Trt : u_S1,
    "S2" => u_S2)

end


function micro_sim(m::BasicModel, is_treatement::Bool; seed::Int=1)
    @unpack n_t, n_i, v_n, d_c, d_e, v_M_1, disp_iters = m
  
    println()

    ### precompute conditional on treatment
    probs = basic_probs(m)
    costs = basic_costs(m, is_treatement)
    effs = basic_effs(m, is_treatement)

    C::Matrix{Int} = zeros(Int, n_i, n_t + 1)
    E::MatFloat = zeros(n_i, n_t + 1)
    M::Matrix{String} = fill("", n_i, n_t + 1)
    M[:, 1] = v_M_1

    for i in 1:n_i
        Random.seed!(seed + i)  # Set the seed for each individual

        state_0 = v_M_1[i]
        C[i, 1]  = costs[state_0] # estimate costs per individual for the initial health state 
        E[i, 1] =  effs[state_0] # estimate QALYs per individual for the initial health state

        for t in 1:n_t
            state = sample(v_n, Weights( probs[M[i, t]]), 1)[1]
            M[i, t + 1] = state
            C[i, t + 1] = costs[state]
            E[i, t + 1] = effs[state]
        end 
      
        iszero(i % disp_iters) && print("\r$(round(i/n_i * 100))% done") # display iterations, each disp_iters
        
    end
    println()

    tc = C * (1 / (1 + d_c)) .^ (0:n_t)   # total (discounted) cost per individual
    te = E *  (1 / (1 + d_e)) .^ (0:n_t) # total (discounted) QALYs per individual 


    return Results(total_costs = tc,
    total_effs = te,
    total_cost_hat= mean(tc),  # average (discounted) cost 
    total_eff_hat = mean(te)  # average (discounted) QALYs
    )
end