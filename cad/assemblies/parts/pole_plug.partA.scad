include <generic/lib.scad>;

use <oem/m8_nut.scad>;
use <oem/m3_phillips_screw.scad>;
use <oem/m3x5mm_threaded_insert.scad>;


use <chassis_base_cover.scad>;

function vPolePlug_PartA_Datasheet() =
     let(cover_datasheet=vChassisBaseCoverDatasheet(),
         outer_diameter=property(cover_datasheet, "pole_block_diameter"),
         inner_diameter=property(cover_datasheet, "pole_socket_diameter"),
         base_thickness=2)
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["height", property(vM8NutDatasheet(), "m_max") + base_thickness],
      ["base_thickness", base_thickness], ["fastening_angles", [0, 90, 180, 270]],
      ["fastening_r_offset", 15]];

function vPolePlugScrewDatasheet() =
     vM3PhillipsScrewDatasheet();

module mPolePlugNut() {
     mM8Nut();
}

module mPolePlugScrew() {
     mM3x12mmPhillipsScrew();
}

module mPolePlug_PartA() {
     datasheet = vPolePlug_PartA_Datasheet();
     height = property(datasheet, "height");
     base_thickness = property(datasheet, "base_thickness");
     outer_diameter = property(datasheet, "outer_diameter");
     fastening_angles = property(datasheet, "fastening_angles");
     fastening_r_offset = property(datasheet, "fastening_r_offset");

     nut_datasheet = vM8NutDatasheet();
     nut_s_max = property(nut_datasheet, "s_max");
     nut_m_max = property(nut_datasheet, "m_max");
     nut_e_min = property(nut_datasheet, "e_min");
     screw_datasheet = vPolePlugScrewDatasheet();
     screw_nominal_diameter = property(screw_datasheet, "nominal_diameter");

     difference() {
          union() {
               cylinder(d=outer_diameter, h=base_thickness);
               translate([0, 0, base_thickness]) {
                    cylinder(d=outer_diameter, h=nut_m_max);
               }
          }
          translate([0, 0, -kEpsilon]) {
               cylinder(d=nut_s_max, h=base_thickness + 2 * kEpsilon);
               translate([0, 0, base_thickness]) {
                    cylinder(d=nut_e_min, h=nut_m_max + 2 * kEpsilon, $fn=6);
               }
          }
          for(angle = fastening_angles) {
               rotate([0, 0, angle]) {
                    translate([fastening_r_offset, 0, 0]) {
                         translate([0, 0, height]) {
                              mM3x5mmThreadedInsertTaperCone();
                         }
                         translate([0, 0, -kEpsilon]) {
                              cylinder(d=screw_nominal_diameter, h=height);
                         }
                    }
               }
          }
     }
}

mPolePlug_PartA();
