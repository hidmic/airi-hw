import pint
import numpy as np
import scipy.optimize as opt
import matplotlib.pyplot as plt


def suspension():
    """
    Cálculo de resortes de suspension.

    NOTA: cálculos especulativos, a falta de datos experimentales
    """
    units = pint.UnitRegistry()

    h_step = 2 * units.cm  # Altura máxima de umbral (Ley 24.314)
    r_wheel = 48.0 * units.mm  # Radio de rueda de tracción
    r_rear_caster = 25.0 * units.mm  # Radio del caster trasero
    r_front_caster = 5.0 * units.mm  # Radio del caster delantero
    # Distancia de centro a centro entre casters
    d_caster_base = 340.0 * units.mm
    # Distancia de centro a centro entre caster trasero y rueda de tracción
    d_rear_caster_to_wheel = 140.0 * units.mm
    # Inclinación máxima de rampas (Ley 24.314)
    alpha = np.arctan(1.0/5.0)

    # Verificación de dimensiones (para evitar contacto de
    # la parte inferior de la máquina con el suelo)
    x0 = (r_rear_caster - r_front_caster / np.cos(alpha)) / np.tan(alpha)
    x = d_caster_base / (r_rear_caster/r_front_caster - 1.)
    y = np.sqrt((x + d_caster_base)**2 - r_rear_caster**2) - np.sqrt(x**2 - r_front_caster**2)
    x1 = (r_rear_caster * np.tan(alpha/2) + y) * np.cos(alpha)

    h_rear_caster = r_rear_caster

    def h_front_caster(x):
        return r_front_caster * np.cos(alpha) + x * np.tan(alpha)

    def beta(x):
        return np.arcsin((h_front_caster(x) - h_rear_caster)/d_caster_base)

    def h(x):
        return min(
            r_rear_caster / np.cos(beta(x)) + d_rear_caster_to_wheel * np.tan(beta(x)),
            (d_caster_base - d_rear_caster_to_wheel) * np.tan(alpha - beta(x)) + r_front_caster
        )

    def objective(x):
        return -h(x * units.mm).to(units.mm).magnitude

    bounds = (x0.to(units.mm).magnitude, x1.to(units.mm).magnitude)
    x_max = opt.minimize_scalar(objective, bounds=bounds, method='bounded').x * units.mm
    print("max h_d = {} at x = {}".format(h(x_max), x_max))

    # Distancia de caster trasero a baterias
    d_rear_caster_to_batt1 = 80 * units.mm
    d_rear_caster_to_batt2 = 180 * units.mm
    P_batt1 = P_batt2 = 2.43 * units.kgf  # Peso de baterias

    # Fuerzas estáticas sobre caster trasero y rueda de tracción
    # (se asume la mayor parte del peso se debe a las baterias)
    f_rear_caster = (
        (d_rear_caster_to_batt2 - d_rear_caster_to_wheel) * P_batt2 +
        (d_rear_caster_to_batt1 - d_rear_caster_to_wheel) * P_batt1
    ) / -d_rear_caster_to_wheel
    f_wheel = (P_batt1 * d_rear_caster_to_batt1 + P_batt2 * d_rear_caster_to_batt2) / d_rear_caster_to_wheel

    # Cálculo de suspensión para caster trasero

    ## Se utiliza F2276 SAE 1070 (resortecnica.com)
    D = 18.1 * units.mm  # Diámetro exterior
    d = 1 * units.mm  # Diámetro interior
    p = 8 * units.mm  # Pitch entre vueltas
    L = 43 * units.mm  # Longitud total
    n = 8  # Cantidad de vueltas

    ## Cálculo de constante elástica y deformación total
    ## (ver https://imechanica.org/files/HelicalSpring.pdf)
    ν = 0.27  # Ratio de Poisson
    E = 201 * units.GPa  # Módulo de elasticidad
    G = 0.5 * E / (1 + ν)  # Módulo de rigidez
    J = np.pi * d**4 / 32  # Momento polar del alambre
    𝛾 = np.arctan(p / (np.pi * D))
    k_rear_caster = (1 / (
        n * np.pi * D**3 / (4 * G * J * np.cos(𝛾)) *
        ((1 + d**2 / (2 * D**2)) * np.cos(𝛾)**2 +
         (1 + d**2 / (4 * D**2)) * np.sin(𝛾)**2/(1 + ν))
    )).to(units.kgf / units.mm)
    e_rear_caster = f_rear_caster / k_rear_caster
    assert e_rear_caster < L, e_rear_caster

    # Cálculo de suspensión para ruedas

    ## Se utiliza F051 SAE 1070 (resortecnica.com)
    D = 6.8 * units.mm  # Diámetro exterior
    d = 1.25 * units.mm  # Diámetro interior
    p = 2.6 * units.mm  # Pitch entre vueltas
    L = 68 * units.mm  # Longitud total
    n = 27.5  # Cantidad de vueltas

    ## Cálculo de constante elástica y deformación total
    ## (ver https://imechanica.org/files/HelicalSpring.pdf)
    ν = 0.27  # Ratio de Poisson
    E = 201 * units.GPa  # Módulo de elasticidad
    G = 0.5 * E / (1 + ν)  # Módulo de rigidez
    J = np.pi * d**4 / 32  # Momento polar del alambre
    𝛾 = np.arctan(p / (np.pi * D))
    k_wheel = (1 / (
        n * np.pi * D**3 / (4 * G * J * np.cos(𝛾)) *
        ((1 + d**2/(2 * D**2)) * np.cos(𝛾)**2 +
         (1 + d**2 /(4 * D**2)) * np.sin(𝛾)**2/(1 + ν))
    )).to(units.kgf / units.mm)
    e_wheel = f_wheel / k_wheel
    assert e_wheel < L

    # Cálculo de suspensión para caster delantero

    ## Se utiliza F174 SAE 1070 (resortecnica.com)
    D = 8.8 * units.mm  # Diámetro exterior
    d = 2 * units.mm  # Diámetro interior
    p = 3.3 * units.mm  # Pitch entre vueltas
    L = 15 * units.mm  # Longitud total
    n = 5.5  # Cantidad de vueltas

    ## Cálculo de constante elástica
    ## (ver https://imechanica.org/files/HelicalSpring.pdf)
    ν = 0.27  # Ratio de Poisson
    E = 201 * units.GPa  # Módulo de elasticidad
    G = 0.5 * E / (1 + ν)  # Módulo de rigidez
    J = np.pi * d**4 / 32  # Momento polar del alambre
    𝛾 = np.arctan(p / (np.pi * D))
    k_front_caster = (1 / (
        n * np.pi * D**3 / (4 * G * J * np.cos(𝛾)) *
        ((1 + d**2/(2 * D**2)) * np.cos(𝛾)**2 +
         (1 + d**2 /(4 * D**2)) * np.sin(𝛾)**2/(1 + ν))
    )).to(units.kgf / units.mm)

    ## Cálculo de deformación total, asumiendo colisión elástica
    ## y transferencia total de energia cinética en energía potencial.
    m = 8 * units.kg  # Masa total del equipo
    N = 266 * units.rpm  # Velocidad de las ruedas

    e_front_caster = (
        N * r_wheel * np.sin(alpha) / np.sqrt(k_front_caster / m)
    ).to(units.mm)
    assert e_front_caster < L

    # x = np.linspace(x0, x1, 100)
    # plt.plot(x, h(x))
    # plt.axvline(x=x_max, ymin=0, ymax=h(x_max))
    # plt.axhline(y=h_d(x_max), xmin=x0, xmax=x_max)
    # plt.grid()
    # plt.show()

    # Cálculo de resortes para el bumper

    D = 6.8 * units.mm
    d = 0.8 * units.mm
    p = 2.5 * units.mm
    L = 12 * units.mm
    n = 6

    ν = 0.27
    E = 201 * units.GPa
    G = 0.5 * E / (1 + ν)
    J = np.pi * d**4 / 32
    𝛾 = np.arctan(p / (np.pi * D))

    k_bumper = (1 / (
        n * np.pi * D**3 / (4 * G * J * np.cos(𝛾)) *
        ((1 + d**2/(2 * D**2)) * np.cos(𝛾)**2 +
         (1 + d**2 /(4 * D**2)) * np.sin(𝛾)**2/(1 + ν))
    )).to(units.kgf / units.mm)

    print('\n'.join('{} = {}'.format(name, value)
                    for name, value in locals().items()
                    if isinstance(value, units.Quantity)))


if __name__ == '__main__':
    suspension()
