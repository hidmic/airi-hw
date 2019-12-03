include <generic/lib.scad>;

use <generic/nuts.scad>;

function vM2NutDatasheet() =
     pvNutDatasheet(e_min=4.32, s_max=4, m_max=1.6);

module mM2NutBore() {
     pmNutBore(vM2NutDatasheet());
}

module mM2NutXSection() {
     pmNutXSection(vM2NutDatasheet());
}

module mM2Nut() {
     import("stl/din934_m2_nut.stl");
}

mM2Nut();
