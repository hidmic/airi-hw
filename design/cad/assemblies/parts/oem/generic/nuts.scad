include <lib.scad>;

function pvNutDatasheet(e_min, s_max, m_max) =
     [["e_min", e_min], ["s_max", s_max], ["m_max", m_max]];

module pmNutBore(datasheet) {
     translate([0, 0, -1.5 * property(datasheet, "m_max")]) {
          cylinder(d=property(datasheet, "e_min") + 6 * kEpsilon,
                   h=1.5 * property(datasheet, "m_max") + kEpsilon,
                   $fn=6);
     }
}

module pmNutXSection(datasheet) {
     projection(cut=true) pNutBore(datasheet);
}
