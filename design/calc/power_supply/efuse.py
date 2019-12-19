import pint
import numpy as np
from scipy import signal

if __name__ == '__main__':
    units = pint.UnitRegistry()

    Ta_max = 70 * units.delta_degC

    Vi_min = 9 * units.V
    Vi_max = 27 * units.V
    Ilim = 16 * units.A

    Rsns = round((48.5 * units.mV / Ilim).to(units.mΩ))

    Plim_min = (5 * units.mV * Vi_max / Rsns).to(units.W)
    Rpwr_budget = (
        1.3e5 * Rsns * (Plim_min - 1.18 * units.mV * Vi_max / Rsns) / units.W
    ).to(units.kΩ)
    Rpwr = 9.1 * units.kΩ
    Plim = (Rpwr * units.W / (1.3e5 * Rsns) + 1.18 * units.mV * Vi_max / Rsns).to(units.W)

    Cout_budget = 8.2 * units.mF
    t_start_budget = (Cout_budget/2 * (Vi_max**2/Plim + Plim/Ilim**2)).to(units.ms)
    Ctimer_budget = (1.5 * t_start_budget * 85 * units.uA / (4 * units.V)).to(units.uF)
    Ctimer = 3.3 * units.uF

    t_fault = (Ctimer * 4 * units.V / (85 * units.uA)).to(units.ms)

    # Use IPB042N10
    Rds_on = 4.2 * units.mΩ
    Rja_th = 23.3 * units.delta_degC / units.W  # Pad area = 1in²
    Tj_max = 175 * units.delta_degC
    Pdc = (Ilim**2 * Rds_on).to(units.W)
    Tj = Ta_max + Pdc * Rja_th
    assert Tj < Tj_max, Tj

    SOAm = np.log(7 * units.A / (3 * units.A)) / np.log(10 * units.ms / (1 * units.s))
    SOAa = 7 * units.A / (10 * units.ms)**SOAm

    Tj_start = Ta_max + (Plim / Vi_max)**2 * Rds_on * Rja_th
    I_max = SOAa * t_fault**SOAm * (Tj_max - Tj_start) / (Tj_max - 25 * units.delta_degC)
    assert I_max > Plim / Vi_max

    Vuv = 250 * units.mV
    Vuv_h = Vi_min
    Vuv_l = Vuv_h - Vuv
    Vov_h = Vi_max

    R1 = (Vuv / (21 * units.uA)).to(units.kΩ)
    R3 = 2.5 * units.V * R1 * Vuv_l / (Vov_h * (Vuv_l - 2.5 * units.V))
    R2 = 2.5 * units.V * R1 / (Vuv_l - 2.5 * units.V) - R3

    R1 = 12 * units.kΩ
    R3 = 1.5 * units.kΩ
    R2 = 3.3 * units.kΩ

    Vov = ((R1 + R2) * 21 * units.uA).to(units.mV)

    # Use SMBJ30A as TVS
    # Use MBRB1645 as D

    print('\n'.join(
        '{} = {}'.format(name, value)
        for name, value in locals().items()
        if isinstance(value, (float, units.Quantity, np.ndarray))
    ))
