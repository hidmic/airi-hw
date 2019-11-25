include <generic/lib.scad>;

function vM2NutDatasheet() =
     [["e_min", 4.32], ["s_max", 4], ["m_max", 1.6]];

module mM2NutBore() {
     datasheet = vM2NutDatasheet();
     translate([0, 0, -1.5 * property(datasheet, "m_max")])
     cylinder(d=property(datasheet, "e_min") + 6 * kEpsilon,
              h=1.5 * property(datasheet, "m_max") + kEpsilon, $fn=6);
}

module mM2Nut() {
     
     import("stl/din934_m2_nut.stl");
}

mM2Nut();
