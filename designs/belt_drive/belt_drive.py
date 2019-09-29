import pint
import numpy as np


if __name__ == '__main__':
    units = pint.UnitRegistry()

    N = 266 * units.rpm
    C = 6.8 * units.kgf * units.cm

    sf = 1.5

    C_peak = (C * sf).to(units.N * units.m)

    p = 3 * units.mm
    n1 = n2 = 20
    pd = n1 * p / np.pi

    d_left = 100 * units.mm
    d_right = 80 * units.mm

    # Use GT3 3 mm pitch 6 mm width
    W = 6 * units.mm
    h = 2.41 * units.mm - 1.14 * units.mm
    C_rated = 0.95 * 1.26 * units.N * units.m
    assert C_rated > C_peak

    EA = 30000 * units.lbf * (0.82 * W / (1 * units.inch))
    T = 2 * (
        0.812 * C_peak.to(units.lbf * units.inch) / pd.to(units.inch) +
        0.077 * units.lbf * units.minute**2 / units.ft**2 * ((pd * N).to(units.ft / units.minute)/1000)**2
    ).to(units.N)

    ε = (T / EA).to('dimensionless')

    n_left = np.floor((1 - 2 * ε) * ((n1 + n2)/2 + 2 * d_left/p))
    L_left = n_left * p

    n_right = np.floor((1 - 2 * ε) * ((n1 + n2)/2 + 2 * d_right/p))
    L_right = n_right * p

    print('\n'.join('{} = {}'.format(name, value)
                    for name, value in locals().items()
                    if isinstance(value, units.Quantity)))
