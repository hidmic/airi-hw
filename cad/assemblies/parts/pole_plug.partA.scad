include <generic/lib.scad>;

use <oem/m3x12mm_phillips_screw.scad>;
use <oem/m8_nut.scad>;

use <chassis_base_cover.scad>;

function vPolePlug_PartA_Datasheet() =
     let(cover_datasheet=vChassisBaseCoverDatasheet(), outer_diameter=60,
         inner_diameter=property(cover_datasheet, "pole_socket_diameter"),
         base_thickness=2)
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["height", property(vM8NutDatasheet(), "m_max") + base_thickness],
      ["base_thickness", base_thickness], ["fastening_angles", [0, 90, 180, 270]],
      ["fastening_r_offset", 15]];

function vPolePlugScrewDatasheet() =
     vM3x12mmPhillipsScrewDatasheet();

module mPolePlugNut() {
     mM8Nut();
}

module mPolePlugScrew() {
     mM3x12mmPhillipsScrew();
}

module mPolePlug_PartA() {
     datasheet = vPolePlug_PartA_Datasheet();
     base_thickness = property(datasheet, "base_thickness");
     outer_diameter = property(datasheet, "outer_diameter");
     fastening_angles = property(datasheet, "fastening_angles");
     fastening_r_offset = property(datasheet, "fastening_r_offset");

     nut_datasheet = vM8NutDatasheet();
     screw_datasheet = vPolePlugScrewDatasheet();

     linear_extrude(height=base_thickness) {
          ring(outer_radius=outer_diameter/2, inner_radius=property(nut_datasheet, "s_max")/2);
     }
     translate([0, 0, base_thickness]) {
          linear_extrude(height=property(nut_datasheet, "m_max")) {
               difference() {
                    circle(d=outer_diameter);
                    circle(d=property(nut_datasheet, "e_min"), $fn=6);
                    for(angle = fastening_angles) {
                         rotate([0, 0, angle]) {
                              translate([fastening_r_offset, 0]) {
                                   circle(d=property(screw_datasheet, "max_head_diameter"));
                              }
                         }
                    }
               }
          }
     }
}

mPolePlug_PartA();
