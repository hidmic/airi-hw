import pint
import numpy as np


def belt_drive():
    """
    Cálculo de transmisión a correa.

    Ecuaciones y modelos tomados de
    """
    units = pint.UnitRegistry()

    # Cálculo de torque mínimo de motor
    alpha = np.arctan(1.0/5.0)  # Inclinación máxima de rampas (Ley 24.314)
    Pmax = 8 * units.kgf  # Peso nominal
    D = 9.6 * units.cm  # Diámetro de rueda
    Cmin = Pmax * np.sin(alpha) * D / 2

    # Cálculo de velocidad nominal mínima de motor
    vmin = 1 * units.m / units.s
    Nmin = (vmin / (D / 2)).to(units.rpm)

    # Caracteristicas del motorreductor DC MR08D 24v 24:1
    # (con motor DC Mobuchi RS-555SH-2670)
    N = 266 * units.rpm  # Velocidad nominal
    C = 6.8 * units.kgf * units.cm  # Torque a máxima eficiencia
    assert 2 * C > Cmin
    assert N > Nmin

    sf = 1.5  # Factor de servicio nominal
    C_peak = (C * sf).to(units.N * units.m)
    # Se utiliza correa GT3 3 mm de pitch, 6 mm de ancho
    p = 3 * units.mm  # Pitch de correa
    n1 = n2 = 20  # Dientes por polea
    pd = n1 * p / np.pi  # Delta angular

    d_left = 100 * units.mm
    d_right = 80 * units.mm

    W = 6 * units.mm
    h = 2.41 * units.mm - 1.14 * units.mm
    C_rated = 0.95 * 1.26 * units.N * units.m
    assert C_rated > C_peak  # Verificación de torque

    # Cálculo de tensión de correa
    T = 2 * (
        0.812 * C_peak.to(units.lbf * units.inch) / pd.to(units.inch) +
        0.077 * units.lbf * units.minute**2 / units.ft**2 * ((pd * N).to(units.ft / units.minute)/1000)**2
    ).to(units.N)

    # Cálculo de dientes y ángulo de contacto
    EA = 30000 * units.lbf * (0.82 * W / (1 * units.inch))
    ε = (T / EA).to('dimensionless')

    n_left = np.floor((1 - 2 * ε) * ((n1 + n2)/2 + 2 * d_left/p))
    L_left = n_left * p
    n_right = np.floor((1 - 2 * ε) * ((n1 + n2)/2 + 2 * d_right/p))
    L_right = n_right * p

    print('\n'.join('{} = {}'.format(name, value)
                    for name, value in locals().items()
                    if isinstance(value, units.Quantity)))


if __name__ == '__main__':
    belt_drive()
