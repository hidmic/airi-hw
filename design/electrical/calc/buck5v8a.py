import pint
import numpy as np


def buck5v8a():
    """
    Cálculo de fuente switching tipo buck de 5v x 8A.

    Basada en LTC1624 de Analog Devices, usando ecuaciones y modelos
    de fuente buck de:
       Christophe Basso. 2008. Switch-Mode Power Supplies Spice
       Simulations and Practical Designs (1st. ed.). McGraw-Hill, Inc.,
       USA
    """
    units = pint.UnitRegistry()

    # Rango de tensión de entrada (2 baterias AGM o alimentación externa)
    Vi_min = 9 * units.V  # Tensión nominal externa
    Vi = 24 * units.V  # Tensión nominal de batería
    Vi_max = 29.4 * units.V  # Tensión máxima segura de carga

    Vo = 5 * units.V  # Tensión de salida
    Io_min = 2 * units.A  # Corriente de salida mínima
    Io = 4 * units.A  # Corriente de salida nominal (Jetson Nano)
    Io_max = 8 * units.A  # Corriente de salida máxima

    # Rango de frecuencia de conmutación
    fsw_min = 175 * units.kHz
    fsw_max = 225 * units.kHz
    fsw = 200 * units.kHz

    # Rango de tensión de ripple de salida
    Vo_rpp_max = 10 * units.mV
    Vi_rpp_max = 250 * units.mV
    # Caídas de tensión máxima ante escalón de carga
    Vi_tran = 400 * units.mV
    Vo_tran = 200 * units.mV

    # Tensión máxima sobre resistencia de sensado de corriente
    Vsense_thres = 100 * units.mV
    # Tensión máxima de salida del gate driver
    Vdriver_max = 5.5 * units.V
    # Temperatura máxima de operación (rango comercial)
    Ta_max = 70 * units.delta_degC
    # Caída de tensión sobre diodo Schottky de conmutación
    Vd = 0.45 * units.V
    # Eficiencia deseada
    neff = 0.85

    # Cálculo de resistencia de sensado
    Rsense_budget = (Vsense_thres / Io_max).to(units.mΩ)
    Rsense = 12 * units.mΩ

    # Rango de ciclo de trabajo
    M_max = (Vo + Vd)/(Vi_min + Vd)
    M_min = (Vo + Vd)/(Vi_max + Vd)
    D_max = M_max / neff
    D_min = M_min / neff

    # Cálculo de inductor
    L_budget = (D_min * (Vi_max - Vo) / (2 * fsw_min * Io_min)).to(units.uH)

    ## Se utiliza SRP1770C-470M
    L = 47 * units.uH
    L_tol = 0.2
    L_min = L * (1 - L_tol)
    L_max = L * (1 + L_tol)
    assert L_min > L_budget

    L_I_rms_max = 8.7 * units.A
    dI_max = (D_min * (Vi_max - Vo) / (L_min * fsw_min)).to(units.A)
    assert L_I_rms_max > np.sqrt(Io_max**2 + dI_max**2 / 12)

    # Cálculo de capacitores de salida (desacople, reserva)
    ESR_CoutR_max = (Vo_rpp_max / dI_max).to(units.mΩ)

    Cout_budget = max(
        D_max / (2 * fsw_min * ESR_CoutR_max),
        (1 - D_min) / (2 * fsw_min * ESR_CoutR_max),
        (L_max * (Io_max**2 - Io_min**2) / ((Vo + Vo_tran)**2 - Vo**2)),
        (L_max * (Io_min**2 - Io_max**2) / ((Vo - Vo_tran)**2 - Vo**2))
    ).to(units.uF)

    I_CoutR_rms_max = (dI_max / np.sqrt(12)).to(units.mA)

    ## Se utiliza 16SVPE180M como capacitor de desacople
    CoutR = 180 * units.uF
    CoutR_tol = 0.2  # 20%
    CoutR_min = CoutR * (1 - CoutR_tol)
    CoutR_max = CoutR * (1 + CoutR_tol)
    ESR_CoutR = 11 * units.mΩ
    I_CoutR_rms = 4.46 * units.A
    V_CoutR_max = 16 * units.V
    assert I_CoutR_rms > I_CoutR_rms_max
    assert V_CoutR_max > Vo

    ## Se utilizan 2 x EEE-FT1C102AP como capacitores de reserva
    CoutB = 2 * 1000 * units.uF
    CoutB_tol = 0.20  # 20%
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

    ## Verificación de tensión de ripple de salida
    Vo_rpp = (ESR_Cout * dI_max + dI_max / (8 * fsw_min * Cout_min)).to(units.mV)
    assert Vo_rpp < Vo_rpp_max
    assert Vo_rpp / ESR_CoutB < I_CoutB_rms

    # Cálculo de capacitores de entrada (desacople, reserva)
    ## Rango de frecuencia de resonancia de salida
    fo_min = (1 / (2 * np.pi * np.sqrt(L_max * Cout_max))).to(units.Hz)
    fo_max = (1 / (2 * np.pi * np.sqrt(L_min * Cout_min))).to(units.Hz)
    assert np.pi**2/2 * (fo_max/fsw_min)**2 * (1 - D_min) * Vo < Vo_rpp_max

    ## Frecuencia de crossover máxima
    fcross_max = (1 / (2 * np.pi * ESR_Cout * Cout_min)).to(units.Hz)

    CinR_budget = ((D_max * (1 - D_max) * Io_max) / (Vi_rpp_max * fsw_min)).to(units.uF)
    ESR_CinR_budget = (Vi_rpp_max / Io_max).to(units.mΩ)
    I_CinR_rms_max = Io_max * np.sqrt(
        D_max * (1 - D_max) + 1/12 * (Vo / (L_min * fsw_min * Io_max))**2 * D_max * (1 - D_max)**2
    )

    ts_in = 100 * units.us
    CinB_budget = (0.5 * ts_in * (Io_max - Io_min) * D_max / Vi_tran).to(units.uF)
    ESR_CinB_max = (Vi_tran / ((Io_max - Io_min) * D_max)).to(units.mΩ)

    ## Se utilizan 2 x EEH-ZK1V331P como capacitores de entrada
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

    # Cálculo de conmutadores (MOSFET + diodo Schottky)
    Vdr_max = Vswr_max = Vi_max  # Tensión máxima sobre MOSFET y diodo Schottky
    Id_max = Isw_max = Io_max + dI_max  # Corriente máxima de MOSFET y diodo Schottky

    ## Corriente media de MOSFET y diodo Schottky
    Isw_avg_max = Io_max * D_max
    Id_avg_max = Io_max * (1 - D_min)

    ## Corriente RMS máxima de MOSFET y diodo Schottky
    tau = L_min * fsw_min * Io_max / Vo
    Isw_rms_max = Io_max * np.sqrt(D_max * (1 + 1/12 * ((1 - D_max)/tau)**2))
    Id_rms_max = Io_max * np.sqrt(1 - D_max * (1 + 1/12 * ((1 - D_max)/tau)**2))

    ## Se utiliza IRF7470 como MOSFET de conmutacion
    Rds_on = 15 * units.mΩ
    Coss = 690 * units.pF
    Ciss = 3430 * units.pF
    Qg = 44 * units.nC
    Tjsw_max = 150 * units.delta_degC
    Zswja_th = 25 * units.delta_degC / units.W  # Impedancia térmica @ D = 0.5 fsw ≃ 200 kHz

    ## Verificación de potencia y temperatura máxima de conmutador
    Psw = (D_max * Io_max**2 * Rds_on + 1/2 * (Coss * fsw_max * Vswr_max**2)).to(units.W)
    Tjsw = Ta_max + Zswja_th * Psw
    assert Tjsw < Tjsw_max

    ## Verificación de potencia y temperatura máxima de driver
    Pg = (fsw_max * Qg * Vdriver_max).to(units.mW)
    Tjic_max = 125 * units.delta_degC
    Ricja_th = 110 * units.delta_degC / units.W
    Tjic = Ta_max + Pg * Ricja_th
    assert Tjic < Tjic_max

    ## Se utiliza MBRB1645G como diodo
    ### Resistencia térmica para un pad de disipación de 1in²
    Rdja_th = 23.3 * units.delta_degC / units.W
    Tjd_max = 175 * units.delta_degC
    Pd = (Id_avg_max * Vd).to(units.W)
    Tjd = Ta_max + Pd * Rdja_th
    assert Tjd < Tjd_max

    # Cálculo de capacitor de bomba de carga
    Cboost_budget = (50 * Ciss).to(units.uF)
    ## Se utilizan 3 x GCD21BR71H104KA01
    Cboost = 3 * 0.1 * units.uF
    Cboost_tol = 0.1  # 10 %
    Cboost_dc_bias = 0.8
    Cboost_min = Cboost * (1 - Cboost_tol) * Cboost_dc_bias
    V_Cboost_max = 50 * units.V
    assert Cboost_min > Cboost_budget

    # Cálculo de resistencias para realimentación de tensión
    R1 = 5.6 * units.kΩ
    R2 = np.round(R1 * (Vo / (1.19 * units.V) - 1.))

    print('\n'.join('{} = {}'.format(name, value)
          for name, value in locals().items()
          if isinstance(value, units.Quantity)))


if __name__ == '__main__':
    buck5v8a()
