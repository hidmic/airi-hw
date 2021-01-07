import pint
import numpy as np


if __name__ == '__main__':
    units = pint.UnitRegistry()

    Ta_max = 70 * units.delta_degC

    Vi_min = 2 * 9.6 * units.V
    Vi_max = 2 * 14.5 * units.V

    # Use DRV8873
    CvmR = 0.1 * units.uF
    V_CvmR_max = 35 * units.V
    CvmB = 10 * units.uF
    V_CvmB_max = 35 * units.V

    Cvcp = 1 * units.uF
    V_Cvcp_max = 16 * units.V
    Cfly = 47 * units.nF
    Cdvdd = 1 * units.uF
    V_Cdvdd_max = 6.3 * units.V

    Rfault = 100 * units.kΩ

    Vcc = 3.3 * units.V
    Itrip = 4.6 * units.A
    Aipropi = 1100 * units.A / units.A
    Ripropi_budget = (Aipropi * Vcc / Itrip).to(units.Ω)
    Ripropi = 820 * units.Ω
    P_Ripropi = ((Itrip/Aipropi)**2 * Ripropi).to(units.W)

    fsw = 16 * units.kHz
    SR = 53.2 * units.V / units.us
    tr = tf = Vi_max / SR
    Tj_max = 150 * units.delta_degC
    Rth_ja = 35.4 * units.delta_degC / units.W

    Io = 2.0 * units.A
    Rds_on = 155 * units.mΩ
    Ivm = 7 * units.mA
    Pvm = (Vi_max * Ivm).to(units.W)
    Psw = (0.5 * fsw * Vi_max * (tr + tf) * Io).to(units.W)
    Pdc = (Io**2 * (2 * Rds_on)).to(units.W)
    P = Pvm + Pdc + Psw
    Tj = Ta_max + P * Rth_ja
    assert Tj < Tj_max

    print('\n'.join(
        '{} = {}'.format(name, value)
        for name, value in locals().items()
        if isinstance(value, (float, units.Quantity, np.ndarray))
    ))
