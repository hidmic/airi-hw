#!/usr/bin/env python3
import numpy as np
import scipy.optimize as opt
import matplotlib.pyplot as plt

if __name__ == '__main__':
    r_r = 25.
    r_f = 5.
    d_rf = 300.
    d_rd = 140.
    alpha = np.arctan(1./5.)
    x0 = (r_r - r_f / np.cos(alpha))/np.tan(alpha)

    x = d_rf / (r_r/r_f - 1.)
    y = np.sqrt((x + d_rf)**2 - r_r**2) - np.sqrt(x**2 - r_f**2)
    x1 = (r_r * np.tan(alpha/2) + y) * np.cos(alpha)

    h_r = r_r

    def h_f(x):
        return r_f * np.cos(alpha) + x * np.tan(alpha)

    def beta(x):
        return np.arcsin((h_f(x) - h_r)/d_rf)

    def h_d(x):
        return np.min([
            r_r / np.cos(beta(x)) + d_rd * np.tan(beta(x)),
            (d_rf - d_rd) * np.tan(alpha - beta(x))
        ], axis=0)

    def objective(x):
        return -h_d(x)

    x_max = opt.minimize_scalar(objective, bounds=(x0, x1), method='bounded').x
    print("max h_d = {} at x = {}".format(h_d(x_max), x_max))

    # r = 20
    # d = 260
    # alpha = np.arctan(1./5.)
    # x0 = r * np.sin(alpha/2)
    # x1 = d * np.cos(alpha) + x0 * (1 + np.cos(alpha))
    # rho = r * (1 - np.cos(alpha))

    # def delta(x):
    #     return r/np.cos(alpha) + (x - x0) * np.tan(alpha)

    # def beta(x):
    #     return np.arcsin((delta(x) - r)/d)

    # def h(x):
    #     return delta(x) * np.cos(beta(x)) - (x - x0) * np.sin(beta(x))

    # def objective(x):
    #     return -h(x)

    # x_max = opt.minimize_scalar(objective, bounds=(x0, x1), method='bounded').x
    # h_max = h(x_max)
    # print("rho = {}".format(rho))
    # print("h_max = {} at x = {}".format(h_max, x_max))

    x = np.linspace(x0, x1, 100)
    plt.plot(x, h_d(x))
    plt.axvline(x=x_max, ymin=0, ymax=h_d(x_max))
    plt.axhline(y=h_d(x_max), xmin=x0, xmax=x_max)
    plt.grid()
    plt.show()
