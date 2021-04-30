import pint
import numpy as np


def motor24v2a():
    """
    Calculo de controlador de motores de 24v x 2A.

    Basada en DRV8873-Q1 de TI Instruments.
    """
    units = pint.UnitRegistry()

    # Temperatura de operación máxima (rango comercial)
    Ta_max = 70 * units.delta_degC

    # Rango de tensión de entrada (2 baterias AGM, 6 celdas cada una)
    Vi_min = 2 * 9.6 * units.V  # Batería descargada (1.6 V/celda)
    Vi_max = 2 * 14.9 * units.V  # Tensión de carga máxima segura (<2.5 V/celda)

    # Se utiliza DRV8873-Q1 (controlador de puente H integrado)
    # Capacitor de desacople
    CvmR = 0.1 * units.uF
    V_CvmR_max = 35 * units.V
    # Capacitor de reserva
    CvmB = 10 * units.uF
    V_CvmB_max = 35 * units.V
    # Capacitores de bomba de carga (reserva y conmutación)
    Cvcp = 1 * units.uF
    V_Cvcp_max = 16 * units.V
    Cfly = 47 * units.nF
    # Capacitor de desacople en Vdd (regulador interno)
    Cdvdd = 1 * units.uF
    V_Cdvdd_max = 6.3 * units.V

    # Resistencia de pull-up para salida
    # open-collector en caso de fallo
    Rfault = 100 * units.kΩ

    # Tensión nominal de alimentación
    Vcc = 3.3 * units.V
    # Corriente límite para el motor (bloqueo)
    # NOTA: este límite es inferior a la corriente
    # de saturación del MR08D-024022 intencionalmente,
    # sacrificando torque para mantener al controlador
    # en un rango de temperatura seguro.
    Itrip = 4.6 * units.A
    # Constante de escala del espejo de corriente
    Aipropi = 1100 * units.A / units.A
    # Cálculo de resistencia para espejo de corriente
    Ripropi_budget = (Aipropi * Vcc / Itrip).to(units.Ω)
    Ripropi = 820 * units.Ω
    assert Ripropi > Ripropi_budget
    P_Ripropi = ((Itrip/Aipropi)**2 * Ripropi).to(units.W)

    fsw = 16 * units.kHz  # Frecuencia de conmutación del puente
    SR = 53.2 * units.V / units.us  # Slew-rate de los gate drivers
    tr = tf = Vi_max / SR  # Tiempos de conmutación
    Tj_max = 150 * units.delta_degC  # Máxima temperatura de juntura
    # Resistencia térmica para HTSSOP sobre pad de ~10cm2, en dos
    # capas, con vías térmicas (estimación)
    Rth_ja = 35.4 * units.delta_degC / units.W

    # Corriente nominal del motor (estimación)
    Io = 2.0 * units.A
    # Resistencia del canal de los MOSFET integrados
    Rds_on = 155 * units.mΩ
    # Corriente nominal de alimentación
    Ivm = 7 * units.mA
    # Cálculo de potencias y temperatura de juntura
    Pvm = (Vi_max * Ivm).to(units.W)  # Nominal
    Psw = (0.5 * fsw * Vi_max * (tr + tf) * Io).to(units.W)  # Conmutación
    Pdc = (Io**2 * (2 * Rds_on)).to(units.W)  # Disipación en el canal
    P = Pvm + Pdc + Psw
    Tj = Ta_max + P * Rth_ja
    assert Tj < Tj_max

    print('\n'.join(
        '{} = {}'.format(name, value)
        for name, value in locals().items()
        if isinstance(value, (float, units.Quantity, np.ndarray))
    ))


if __name__ == '__main__':
    motor24v2a()
