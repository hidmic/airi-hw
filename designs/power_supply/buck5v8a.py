
import pint
import numpy as np


if __name__ == '__main__':
    units = pint.UnitRegistry()
    Vi_min = 9.0 * units.V
    Vi = 24 * units.V
    Vi_max = 29.8 * units.V
    Vo = 5 * units.V
    Io_min = 2 * units.A
    Io = 4 * units.A
    Io_max = 8 * units.A
    fsw_min = 175 * units.kHz
    fsw_max = 225 * units.kHz
    fsw = 400 * units.kHz
    Vo_rpp = 30 * units.mV
    Vi_rpp = 200 * units.mV
    Vo_tran = 200 * units.mV
    Vi_tran = 200 * units.mV
    Vsense_thres = 100 * units.mV
    Vdriver_max = 5.5 * units.V
    Ta_max = 40 * units.delta_degC
    Vd = 0.6 * units.V
    neff = 0.85

    Rsense = (Vsense_thres / Io_max).to(units.mΩ)

    M_max = (Vo + Vd)/(Vi_min + Vd)
    M_min = (Vo + Vd)/(Vi_max + Vd)

    D_max = M_max / neff
    D_min = M_min / neff

    L_strict_min = (D_min * (Vi_max - Vo) / (2 * fsw_min * Io_min)).to(units.uH)

    # Use SRP1770C-470M
    L = 47 * units.uH
    L_tol = 0.2
    L_min = L * (1 - L_tol)
    L_max = L * (1 + L_tol)
    L_I_rms_max = 8.7 * units.A
    assert L_min > L_strict_min

    dI_max = (D_min * (Vi_max - Vo) / (L_min * fsw_min)).to(units.A)
    assert L_I_rms_max > np.sqrt(Io_max**2 + dI_max**2 / 12)

    Cin_min_strict = ((D_max * (1 - D_max) * Io_max) / (Vi_rpp * fsw_min)).to(units.uF)
    I_Cin_rms_max = Io_max * np.sqrt(
        D_max * (1 - D_max) + 1/12 * (Vo / (L_min * fsw_min * Io_max))**2 * D_max * (1 - D_max)**2
    )
    ESR_Cin_max = (Vi_tran / ((Io_max - Io_min) * D_min)).to(units.mΩ)

    # Use P16562CT-ND
    Cin = 82 * units.uF
    Cin_tol = 0.2
    Cin_min = Cin * (1 - Cin_tol)
    Cin_max = Cin * (1 + Cin_tol)
    I_Cin_rms = 4 * units.A
    ESR_Cin = 20 * units.mΩ
    V_Cin_max = 35 * units.V
    assert Cin_min > Cin_min_strict
    assert V_Cin_max > Vi_max
    assert ESR_Cin < ESR_Cin_max
    # assert I_Cin_rms > I_Cin_rms_max

    I_Cout_rms_max = (dI_max / np.sqrt(12)).to(units.mA)
    ESR_Cout_max = (Vo_rpp / dI_max).to(units.mΩ)

    Cout_min_perm = max(
        D_max / (2 * fsw_min * ESR_Cout_max),
        (1 - D_min) / (2 * fsw_min * ESR_Cout_max),
    ).to(units.uF)

    Cout_min_tran = max(
        (L_max * (Io_max**2 - Io_min**2) / ((Vo + Vo_tran)**2 - Vo**2)),
        (L_max * (Io_min**2 - Io_max**2) / ((Vo - Vo_tran)**2 - Vo**2))
    ).to(units.uF)

    Cout_strict_min = max(Cout_min_tran, Cout_min_perm)

    # Use 2 x P122426CT-ND
    Cout = 2 * 1200 * units.uF
    Cout_tol = 0.20
    Cout_min = Cout * (1 - Cout_tol)
    Cout_max = Cout * (1 + Cout_tol)
    ESR_Cout = 60 * units.mΩ / 2
    V_Cout_max = 16 * units.V
    I_Cout_rms = 2 * 1.19 * units.A
    assert Cout_min > Cout_strict_min
    assert ESR_Cout <= ESR_Cout_max
    assert V_Cout_max > Vo
    assert ESR_Cout * dI_max < Vo_rpp
    assert ESR_Cout < Vo_tran / (Io_max - Io_min)
    assert I_Cout_rms > I_Cout_rms_max

    fo_max = (1 / (2 * np.pi * np.sqrt(L_min * Cout_min))).to(units.Hz)
    assert np.pi**2/2 * (fo_max/fsw_min)**2 * (1 - D_min) * Vo < Vo_rpp

    fcross_max = (1 / (2 * np.pi * ESR_Cout * Cout_min)).to(units.Hz)

    Vdr_max = Vswr_max = Vi_max
    Id_max = Isw_max = Io_max + dI_max

    Isw_avg_max = Io_max * D_max
    Id_avg_max = Io_max * (1 - D_min)

    tau = L_min * fsw_min * Io_max / Vo
    Isw_rms_max = Io_max * np.sqrt(D_max * (1 + 1/12 * ((1 - D_max)/tau)**2))
    Id_rms_max = Io_max * np.sqrt(1 - D_max * (1 + 1/12 * ((1 - D_max)/tau)**2))

    # Use IRF7470
    # kmos = 2.5 * units.W / (units.A * units.V ** 1.85 * units.F * units.Hz)
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

    Cboost_min = (50 * Ciss).to(units.uF)
    # Use 1276-1007
    Cboost = (2 * 0.1) * units.uF
    V_Cboost_max = 50 * units.V
    assert Cboost > Cboost_min

    # Use MBRB1045G
    Rdja_th = 34 * units.delta_degC / units.W # Pad area = 600mm²
    Tjd_max = 175 * units.delta_degC

    Pd = (Id_avg_max * Vd).to(units.W)
    Tjd = Ta_max + Pd * Rdja_th
    assert Tjd < Tjd_max

    R1 = 5.6 * units.kΩ
    R2 = np.round(R1 * (Vo / (1.19 * units.V) - 1.))

    print('\n'.join('{} = {}'.format(name, value)
          for name, value in locals().items()
          if isinstance(value, units.Quantity)))
