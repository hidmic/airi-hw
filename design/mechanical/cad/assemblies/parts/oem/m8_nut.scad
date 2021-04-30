include <generic/lib.scad>;
use <generic/nuts.scad>;

function vM8NutDatasheet() =
     pvNutDatasheet(e_min=14.38, s_max=13, m_max=6.5);

module mM8Nut() {
     color("silver") import_mesh("stl/m8-nut.stl");
}