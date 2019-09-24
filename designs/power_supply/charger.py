
import pint
import numpy as np
from scipy import signal

if __name__ == '__main__':
    units = pint.UnitRegistry()

    Ta_max = 50 * units.delta_degC

    Vi_min = 12 * units.V
    Vi_max = 18 * units.V
    Io_min = 100 * units.mA
    Ii_max = 10 * units.A

    R_bat = 2 * 28 * units.mΩ
    C_bat = 7 * units.A * units.H
    Vo_rpp_max = (R_bat * C_bat / (20 * units.H)).to(units.mV)
    Vi_rpp_max = 250 * units.mV
    Vi_tran = 400 * units.mV

    V_en = Vi_min - Vi_tran - Vi_rpp_max
    R1 = 27 * units.kΩ
    V_uvlo = V_en - 3 * units.uA * R1
    R2_min = R1 / (V_uvlo / (1.22 * units.V) - 1)
    R2 = 5.6 * units.kΩ

    Vo_min = 2 * 9.6 * units.V
    Vo_max = 2 * 14.5 * units.V

    Rt = 19.6 * units.kΩ
    fsw = 400 * units.kHz

    neff = 0.85

    M_max = Vo_max/Vi_min
    M_min = Vo_min/Vi_max

    D_max = 1 - neff / M_max
    D_min = 1 - neff / M_min

    Ii_min = Io_min / (1 - D_max)
    Io_max = Ii_max * (1 - D_max)

    # Compute Rs
    Ris_budget = (250 * units.mV / Io_max).to(units.mΩ)
    Rsns_budget = (85 * units.mV / Ii_max).to(units.mΩ)
    Ris = 75 * units.mΩ
    Rsns = 8.2 * units.mΩ
    Rcs = 8.2 * units.mΩ
    Rcsin = 1.8 * units.kΩ
    Rcsout = round((1.25 * units.V * Rcsin / (Rcs * Ii_max)).to(units.kΩ))

    R3 = 100 * units.kΩ
    R4 = round(R3 / ((Vo_max) / (1.25/2 * units.V) - 1), 1)
    R5 = R6 = 27 * units.kΩ

    # Compute L

    L_budget = ((2 * Vo_max) / (27 * fsw * Io_min)).to(units.uH)

    ## Use 74437529203680
    L = 68 * units.uH
    L_tol = 0.2
    L_min = L * (1 - L_tol)
    L_max = L * (1 + L_tol)
    L_I_rms_max = 17 * units.A
    L_I_sat = 10.6 * units.A
    ESR_L = 10.3 * units.mΩ
    assert L_min > L_budget

    L_dI_max = (D_max * (1 - D_max) * Vo_max / (L_min * fsw)).to(units.A)
    L_I_rms = np.sqrt(Ii_max**2 + (L_dI_max**2) / 12)
    L_I_pk = Ii_max + L_dI_max / 2
    assert L_I_pk < L_I_sat
    assert L_I_rms < L_I_rms_max

    # Compute Cin

    CinR_budget = (L_dI_max / (8 * fsw * Vi_rpp_max)).to(units.uF)
    I_CinR_rms_max = (L_dI_max / np.sqrt(12)).to(units.mA)

    ts_in = 100 * units.us
    CinB_budget = (0.5 * ts_in * (Ii_max - Ii_min) / Vi_tran).to(units.uF)
    ESR_CinB_max = (Vi_tran / (Ii_max - Ii_min)).to(units.mΩ)

    ## Use 1 x C3216X6S1V106K160AC
    CinR = 10 * units.uF
    CinR_tol = 0.2
    CinR_kDC_bias = 0.4
    CinR_min = CinR * (1 - CinR_tol) * CinR_kDC_bias
    CinR_max = CinR * (1 + CinR_tol) * CinR_kDC_bias
    ESR_CinR = 2.2 * units.mΩ
    V_CinR_max = 35 * units.V
    assert CinR_min > CinR_budget
    assert ESR_CinR * L_dI_max + L_dI_max / (8 * fsw * CinR_min) < Vi_rpp_max
    assert V_CinR_max > Vi_max
    Vi_rpp = (L_dI_max / (8 * fsw * CinR_min)).to(units.V)

    ## Use 2 x 493-13961-1-ND
    CinB = 2 * 1000 * units.uF
    CinB_tol = 0.2
    CinB_min = CinB * (1 - CinB_tol)
    CinB_max = CinB * (1 + CinB_tol)
    ESR_CinB = 47 * units.mΩ / 2
    I_CinB_rms = 2 * 2.4 * units.A
    V_CinR_max = 35 * units.V
    assert CinB_min > CinB_budget
    assert ESR_CinB < ESR_CinB_max
    assert I_CinB_rms > Vi_rpp/(2 * np.sqrt(3) * ESR_CinB)
    assert V_CinR_max > Vi_max

    Cin_max = CinB_max + CinR_max

    # Compute Cout

    Vo_rpp_mid = 400 * units.mV

    Cout_ripple_budget = (Io_max * D_max / (fsw * Vo_rpp_mid/2)).to(units.uF)
    ESR_Cout_ripple_cap = (Vo_rpp_mid / (Ii_max + L_dI_max/2)).to(units.mΩ)
    I_Cout_rms_max = Io_max * np.sqrt(
        D_max / (1 - D_max) + 1/12 * (Vo_max / (L_min * fsw * Io_max))**2 * D_max * (1 - D_max)**2
    )

    RHPZ_min = ((Vo_min/Io_max) * (1 - D_max)**2 / (2 * np.pi * L_max)).to(units.kHz)
    Cout_stability_budget = (1 / (2 * np.pi * RHPZ_min * ESR_Cout_ripple_cap)).to(units.uF)
    Cout_budget = max(Cout_ripple_budget, Cout_stability_budget)

    # Use 2 x P123471CT-ND
    Cout = 2 * 2400 * units.uF
    Cout_tol = 0.20
    Cout_min = Cout * (1 - Cout_tol)
    Cout_max = Cout * (1 + Cout_tol)
    ESR_Cout = 32 * units.mΩ / 2
    V_Cout_max = 35 * units.V
    I_Cout_rms = 2 * 3.25 * units.A
    assert Cout_min > Cout_budget

    ESR_Cout_min = (1 / (2 * np.pi * RHPZ_min * Cout_min)).to(units.mΩ)
    Rs = 33 * units.mΩ
    assert ESR_Cout + Rs / 2 > ESR_Cout_min
    assert (ESR_Cout + Rs / 2) * (
        Io_max / (1 - D_max) + L_dI_max/2
    ) + Io_max * D_max / (fsw * Cout_min) < Vo_rpp_mid
    assert I_Cout_rms > I_Cout_rms_max
    assert V_Cout_max > Vo_max

    # Compute Lf & Cf

    ζf_min = 2.
    Lf_budget = (((ESR_Cout + Rs/2) / (2 * ζf_min))**2 * Cout_max).to(units.uH)
    # Use XC2399CT-ND
    Lf = 0.82 * units.uH
    Lf_tol = 0.2
    Lf_min = Lf * (1 - Lf_tol)
    Lf_max = Lf * (1 + Lf_tol)
    assert Lf_min > Lf_budget

    Af_min = Vo_rpp_mid / Vo_rpp_max
    Cf_budget = ((Af_min**2 - 1) / ((2 * np.pi * fsw)**2 * Lf_min)).to(units.uF)

    # Use
    Cf = 220 * units.uF
    Cf_tol = 0.2
    Cf_min = Cf * (1 - Cf_tol)
    Cf_max = Cf * (1 + Cf_tol)
    assert Cf_min > Cf_budget

    # Compute main diode

    ## Use MBRB1645G
    Id_avg_max = Io_max
    Id_rms_max = np.sqrt(I_Cout_rms_max**2 + Io_max**2)
    Vd = 0.42 * units.V
    Rd = 0.04 * units.Ω
    Rdja_th = 23.3 * units.delta_degC / units.W  # Pad area = 1in²
    Tjd_max = 175 * units.delta_degC
    Pd = (Id_avg_max * Vd + Id_rms_max**2 * Rd).to(units.W)
    Tjd = Ta_max + Pd * Rdja_th
    assert Tjd < Tjd_max

    # Compute main switch

    ## Use IRF7470
    Rds_on = 15 * units.mΩ
    Coss = 690 * units.pF
    Ciss = 3430 * units.pF
    Qg = 55 * units.nC
    BVdss = 40 * units.V
    Tj_max = 150 * units.delta_degC
    Zja_th = 40 * units.delta_degC / units.W   # @ D = 0.5 fsw ≃ 200 kHz

    tau = L_min * fsw * Io_max / Vo_max
    Isw_max = Ii_max + L_dI_max/2
    Isw_rms_max = Io_max * np.sqrt(D_max / (1 - D_max)**2 + 1/3 * (1/(2 * tau))**2 * D_max**3 * (1 - D_max)**3)
    Isw_avg_max = Ii_max * D_max
    Vsw_max = Vo_max

    Psw = (Isw_rms_max**2 * Rds_on + 1/2 * (Coss * fsw * Vsw_max**2)).to(units.W)
    Tj = Ta_max + Zja_th * Psw
    assert Tj < Tj_max
    assert Vo_max < BVdss

    Iicq = 2.3 * units.mA
    Ig = (fsw * Qg).to(units.mA)
    Tjic_max = 150 * units.delta_degC
    Ricja_th = 35 * units.delta_degC / units.W
    Tjic = Ta_max + (Vi_max * (Iicq + Ig)) * Ricja_th
    assert Tjic < Tjic_max

    # Compute pulse switch

    ## Use IRF9317
    Rds_on_p = 10.2 * units.mΩ
    Qg_p = 50 * units.nC
    BVdss_p = 30 * units.V
    Tj_p_max = 150 * units.delta_degC
    Rja_th_p = 50 * units.delta_degC / units.W
    Psw_p = (Io_max**2 * Rds_on_p).to(units.W)
    Tj_p = Ta_max + Psw_p * Rja_th_p
    Vsw_p_max = Vo_max - Vo_min
    assert Tj_p < Tj_p_max
    assert Vsw_p_max < BVdss_p

    # Compute pulse diode

    ## Use MBRB1645G
    Idp_avg_max = Io_max
    Idp_rms_max = Io_max
    Vdp = 0.42 * units.V
    Rdp = 0.04 * units.Ω
    Rdpja_th = 23.3 * units.delta_degC / units.W  # Pad area = 1in²
    Tjdp_max = 175 * units.delta_degC
    Pdp = (Idp_avg_max * Vdp + Idp_rms_max**2 * Rdp).to(units.W)
    Tjdp = Ta_max + Pdp * Rdja_th
    assert Tjdp < Tjdp_max

    # Compute load switch

    ## Use IRF9317
    Rds_on_sw = 10.2 * units.mΩ
    gfs_sw = 36 * units.S
    Vth_sw_min = 1.9 * units.V
    Qg_sw = 50 * units.nC
    BVdss_sw = 30 * units.V
    Tj_sw_max = 150 * units.delta_degC
    Rja_th_sw = 10 * units.delta_degC / units.W
    tp_sw_max = 200 * units.ms
    Psw_sw = Io_max**2 * Rds_on_sw
    Tj_sw = Ta_max + Psw_sw * Rja_th_sw
    Vds_sw_max = Vo_max - Vo_min
    assert Tj_sw < Tj_sw_max
    assert Vds_sw_max < BVdss_sw

    Csw = 0.22 * units.uF
    Csw_tol = 0.2
    Csw_min = Csw * (1 - Csw_tol)
    Cload_max = Cin_max + Cout_max
    Irush_max = (Cload_max * Vi_max / tp_sw_max).to(units.A)
    Vpl_sw = -Vth_sw_min - (Irush_max / gfs_sw)
    Rsw_budget = (
        ((Vi_max + Vpl_sw)/Csw_min) * Cload_max / Irush_max
    ).to(units.kΩ)
    Cpull_budget = Csw * 20
    Rsw = 1000 * units.kΩ
    Cpull = 4.7 * units.uF

    print('\n'.join(
        '{} = {}'.format(name, value)
        for name, value in locals().items()
        if isinstance(value, (float, units.Quantity, np.ndarray))
    ))
