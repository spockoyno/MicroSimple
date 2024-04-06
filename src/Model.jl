

@with_kw struct BasicModel
    @deftype Float64

    n_i::Int = 100000                      # number of simulated individuals
    n_t::Int = 30                          # time horizon, 30 cycles
    v_n::Strings = ["H", "S1", "S2", "D"]  # the model states: Healthy (H), Sick (S1), Sicker (S2), Dead (D)
    v_M_1::Strings = fill("H", n_i)     # everyone begins in the healthy state
  
    d_c = 0.03                    # discount rate for costs
    d_e = 0.03                    # discount rate for health outcome (QALYs)
    v_Trt::Strings = ["No Treatment", "Treatment"]  # store the strategy names
    p_HD = 0.005                  # probability to die when healthy
    p_HS1 = 0.15                  # probability to become sick when healthy
    p_S1H = 0.5                   # probability to become healthy when sick
    p_S1S2 = 0.105                # probability to become sicker when sick
    rr_S1 = 3                     # rate ratio of death when sick vs healthy
    rr_S2 = 10                    # rate ratio of death when sicker vs healthy

    c_H::Int = 2000                        # cost of remaining one cycle healthy
    c_S1::Int = 4000                       # cost of remaining one cycle sick
    c_S2::Int = 15000                      # cost of remaining one cycle sicker
    c_Trt::Int = 12000                     # cost of treatment (per cycle)
    u_H = 1.0                       # utility when healthy  TODO isn't health utility always 1?
    u_S1 = 0.75                   # utility when sick
    u_S2 = 0.5                    # utility when sicker
    u_Trt = 0.95                  # utility when sick(e


    disp_iters::Int = 100  # display progress after each disp_iters

end 



@with_kw struct Results
    total_costs::Floats
    total_effs::Floats
    total_cost_hat::Float64
    total_eff_hat::Float64
end 