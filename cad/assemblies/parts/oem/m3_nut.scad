
function vM3NutDatasheet() =
     [["e_min", 6.01], ["s_max", 5.5], ["m_max", 2.4]];


module mM3Nut() {
     color("silver") render() import("stl/din934_m3_nut.stl");
}

mM3Nut();
