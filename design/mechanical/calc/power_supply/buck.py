
import pint
import numpy as np


if __name__ == '__main__':
    units = pint.UnitRegistry()

    Vi_min = 9 * units.V
    Vi = 12 * units.V
    Vi_max = 29.4 * units.V
    Vo = 5 * units.V
    Io_min = 2 * units.A
    Io = 4 * units.A
    Io_max = 8 * units.A
    fsw_min = 175 * units.kHz
    fsw_max = 225 * units.kHz
    fsw = 200 * units.kHz

    Vo_rpp_max = 10 * units.mV
    Vo_tran = 200 * units.mV
    Vi_rpp_max = 250 * units.mV
    Vi_tran = 400 * units.mV

    Vsense_thres = 100 * units.mV
    Vdriver_max = 5.5 * units.V
    Ta_max = 70 * units.delta_degC
    Vd = 0.45 * units.V
    neff = 0.85

    Rsense_budget = (Vsense_thres / Io_max).to(units.mΩ)
    Rsense = 12 * units.mΩ
    M_max = (Vo + Vd)/(Vi_min + Vd)
    M_min = (Vo + Vd)/(Vi_max + Vd)

    D_max = M_max / neff
    D_min = M_min / neff

    L_budget = (D_min * (Vi_max - Vo) / (2 * fsw_min * Io_min)).to(units.uH)

    # Use SRP1770C-470M
    L = 47 * units.uH
    L_tol = 0.2
    L_min = L * (1 - L_tol)
    L_max = L * (1 + L_tol)
    L_I_rms_max = 8.7 * units.A
    assert L_min > L_budget

    dI_max = (D_min * (Vi_max - Vo) / (L_min * fsw_min)).to(units.A)
    assert L_I_rms_max > np.sqrt(Io_max**2 + dI_max**2 / 12)

    ESR_CoutR_max = (Vo_rpp_max / dI_max).to(units.mΩ)

    Cout_budget = max(
        D_max / (2 * fsw_min * ESR_CoutR_max),
        (1 - D_min) / (2 * fsw_min * ESR_CoutR_max),
        (L_max * (Io_max**2 - Io_min**2) / ((Vo + Vo_tran)**2 - Vo**2)),
        (L_max * (Io_min**2 - Io_max**2) / ((Vo - Vo_tran)**2 - Vo**2))
    ).to(units.uF)

    I_CoutR_rms_max = (dI_max / np.sqrt(12)).to(units.mA)

    # Use 16SVPE180M
    CoutR = 180 * units.uF
    CoutR_tol = 0.2
    CoutR_min = CoutR * (1 - CoutR_tol)
    CoutR_max = CoutR * (1 + CoutR_tol)
    ESR_CoutR = 11 * units.mΩ
    I_CoutR_rms = 4.46 * units.A
    V_CoutR_max = 16 * units.V
    assert I_CoutR_rms > I_CoutR_rms_max
    assert V_CoutR_max > Vo

    # Use 2 x EEE-FT1C102AP
    CoutB = 2 * 1000 * units.uF
    CoutB_tol = 0.20
    CoutB_min = CoutB * (1 - CoutB_tol)
    CoutB_max = CoutB * (1 + CoutB_tol)
    ESR_CoutB = 60 * units.mΩ / 2
    V_CoutB_max = 16 * units.V
    I_CoutB_rms = 2 * 1.19 * units.A
    assert ESR_CoutB < Vo_tran / (Io_max - Io_min)
    assert V_CoutB_max > Vo

    Cout = CoutB + CoutR
    Cout_min = CoutB_min + CoutR_min
    Cout_max = CoutB_max + CoutR_max
    ESR_Cout = 1/(1/ESR_CoutR + 1/ESR_CoutB)
    assert Cout_min > Cout_budget

    Vo_rpp = (ESR_Cout * dI_max + dI_max / (8 * fsw_min * Cout_min)).to(units.mV)
    assert Vo_rpp < Vo_rpp_max
    assert Vo_rpp / ESR_CoutB < I_CoutB_rms

    fo_min = (1 / (2 * np.pi * np.sqrt(L_max * Cout_max))).to(units.Hz)
    fo_max = (1 / (2 * np.pi * np.sqrt(L_min * Cout_min))).to(units.Hz)
    assert np.pi**2/2 * (fo_max/fsw_min)**2 * (1 - D_min) * Vo < Vo_rpp_max

    fcross_max = (1 / (2 * np.pi * ESR_Cout * Cout_min)).to(units.Hz)

    CinR_budget = ((D_max * (1 - D_max) * Io_max) / (Vi_rpp_max * fsw_min)).to(units.uF)
    ESR_CinR_budget = (Vi_rpp_max / Io_max).to(units.mΩ)
    I_CinR_rms_max = Io_max * np.sqrt(
        D_max * (1 - D_max) + 1/12 * (Vo / (L_min * fsw_min * Io_max))**2 * D_max * (1 - D_max)**2
    )

    ts_in = 100 * units.us
    CinB_budget = (0.5 * ts_in * (Io_max - Io_min) * D_max / Vi_tran).to(units.uF)
    ESR_CinB_max = (Vi_tran / ((Io_max - Io_min) * D_max)).to(units.mΩ)

    # Use 2 x EEH-ZK1V331P
    Cin = 2 * 330 * units.uF
    Cin_tol = 0.2
    Cin_min = Cin * (1 - Cin_tol)
    Cin_max = Cin * (1 + Cin_tol)
    I_Cin_rms = 2.8 * units.A * 2
    ESR_Cin = 20 * units.mΩ / 2
    V_Cin_max = 35 * units.V
    assert Cin_min > max(CinR_budget, CinB_budget)
    assert ESR_Cin * Io_max  + D_max * (1 - D_max) * Io_max / (Cin_min * fsw_min) < Vi_rpp_max
    assert ESR_Cin < min(Vi_tran / ((Io_max - Io_min) * D_min), ESR_CinB_max)
    assert V_Cin_max > Vi_max
    assert I_Cin_rms > I_CinR_rms_max

    Vdr_max = Vswr_max = Vi_max
    Id_max = Isw_max = Io_max + dI_max

    Isw_avg_max = Io_max * D_max
    Id_avg_max = Io_max * (1 - D_min)

    tau = L_min * fsw_min * Io_max / Vo
    Isw_rms_max = Io_max * np.sqrt(D_max * (1 + 1/12 * ((1 - D_max)/tau)**2))
    Id_rms_max = Io_max * np.sqrt(1 - D_max * (1 + 1/12 * ((1 - D_max)/tau)**2))

    # Use IRF7470
    Rds_on = 15 * units.mΩ
    Coss = 690 * units.pF
    Ciss = 3430 * units.pF
    Qg = 44 * units.nC
    Tjsw_max = 150 * units.delta_degC
    Zswja_th = 25 * units.delta_degC / units.W   # @ D = 0.5 fsw ≃ 200 kHz

    Psw = (D_max * Io_max**2 * Rds_on + 1/2 * (Coss * fsw_max * Vswr_max**2)).to(units.W)
    Tjsw = Ta_max + Zswja_th * Psw
    assert Tjsw < Tjsw_max

    Pg = (fsw_max * Qg * Vdriver_max).to(units.mW)
    Tjic_max = 125 * units.delta_degC
    Ricja_th = 110 * units.delta_degC / units.W
    Tjic = Ta_max + Pg * Ricja_th
    assert Tjic < Tjic_max

    Cboost_budget = (50 * Ciss).to(units.uF)
    # Use 3 x GCD21BR71H104KA01
    Cboost = 3 * 0.1 * units.uF
    Cboost_tol = 0.1
    Cboost_dc_bias = 0.8
    Cboost_min = Cboost * (1 - Cboost_tol) * Cboost_dc_bias
    V_Cboost_max = 50 * units.V
    assert Cboost_min > Cboost_budget

    # Use MBRB1645G
    Rdja_th = 23.3 * units.delta_degC / units.W  # Pad area = 1in²
    Tjd_max = 175 * units.delta_degC

    Pd = (Id_avg_max * Vd).to(units.W)
    Tjd = Ta_max + Pd * Rdja_th
    assert Tjd < Tjd_max

    R1 = 5.6 * units.kΩ
    R2 = np.round(R1 * (Vo / (1.19 * units.V) - 1.))

    print('\n'.join('{} = {}'.format(name, value)
          for name, value in locals().items()
          if isinstance(value, units.Quantity)))
