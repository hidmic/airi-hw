import pint
import numpy as np
from scipy import signal

if __name__ == '__main__':
    units = pint.UnitRegistry()

    Ta_max = 70 * units.delta_degC

    Cin = 1.0 * units.uF
    Cout = 22 * units.uF
    R1 = 100 * units.Ω
    C1 = 0.1 * units.uF
    # Use SMBJ30A as TVS
    # Use IFX20002MBV50HT as UREG

    Pe_max = 40 * units.W
    Vi_min = 9 * units.V
    Pm_max = 100 * units.W
    Vm_min = 24 * units.V
    Id_max = max(
        Pe_max / Vi_min, (Pe_max + Pm_max) / Vm_min
    ).to(units.A)

    Vbat_max = 2 * 14.9 * units.V
    # Use IRF7470 as M
    Rds_on = 15 * units.mΩ
    Coss = 690 * units.pF
    Ciss = 3430 * units.pF
    Qg = 55 * units.nC
    BVdss = 40 * units.V
    Tj_max = 150 * units.delta_degC
    Rja_th = 40 * units.delta_degC / units.W

    Pd = (Id_max**2 * Rds_on).to(units.W)
    Tj = Ta_max + Pd * Rja_th
    assert Vbat_max < BVdss
    assert Tj < Tj_max

    print('\n'.join(
        '{} = {}'.format(name, value)
        for name, value in locals().items()
        if isinstance(value, (float, units.Quantity, np.ndarray))
    ))
