include <generic/lib.scad>;

use <oem/m3x5mm_threaded_insert.scad>;
use <oem/ndal_m3_washer.scad>;

use <chassis_base_cover.scad>;
use <pole_plug.partA.scad>;

function vPolePlug_PartB_Datasheet() =
     let(partA_datasheet=vPolePlug_PartA_Datasheet(),
         cover_datasheet=vChassisBaseCoverDatasheet(),
         washer_datasheet=vNdAlM3WasherDatasheet(),
         screw_datasheet=vPolePlugScrewDatasheet())
     [["height", (property(partA_datasheet, "base_thickness") +
                  property(cover_datasheet, "pole_socket_depth") -
                  2 * property(screw_datasheet, "max_head_height") -
                  property(washer_datasheet, "thickness") - 0.5)],
      ["base_thickness", property(partA_datasheet, "base_thickness")],
      ["outer_diameter", property(partA_datasheet, "outer_diameter")],
      ["inner_diameter", property(partA_datasheet, "inner_diameter")],
      ["taper_angle", property(cover_datasheet, "pole_socket_taper_angle")],
      ["fastening_angles", property(partA_datasheet, "fastening_angles")],
      ["fastening_r_offset", property(partA_datasheet, "fastening_r_offset")]];


module mPolePlug_PartB() {
     datasheet = vPolePlug_PartB_Datasheet();

     height = property(datasheet, "height");
     base_thickness = property(datasheet, "base_thickness");
     outer_diameter = property(datasheet, "outer_diameter");
     inner_diameter = property(datasheet, "inner_diameter");
     taper_angle = property(datasheet, "taper_angle");

     fastening_angles = property(datasheet, "fastening_angles");
     fastening_r_offset = property(datasheet, "fastening_r_offset");

     washer_datasheet = vNdAlM3WasherDatasheet();
     washer_thickness = property(washer_datasheet, "thickness");
     washer_outer_diameter = property(washer_datasheet, "outer_diameter");

     screw_datasheet = vPolePlugScrewDatasheet();
     screw_head_height = property(screw_datasheet, "max_head_height");
     screw_head_diameter = property(screw_datasheet, "max_head_diameter");
     screw_nominal_diameter = property(screw_datasheet, "nominal_diameter");

     difference() {
          union() {
               translate([0, 0, base_thickness]) {
                    let(taper_height=height - base_thickness, major_diameter=inner_diameter,
                        minor_diameter=inner_diameter - 2 * taper_height * tan(taper_angle)) {
                         cylinder(d1=major_diameter, d2=minor_diameter, h=taper_height);
                    }
               }
               cylinder(d=outer_diameter, h=base_thickness);
          }
          translate([0, 0, height - washer_thickness]) {
               cylinder(d=washer_outer_diameter + kEpsilon, h=washer_thickness + kEpsilon);
               mM3x5mmThreadedInsertTaperCone();
          }
          translate([0, 0, -kEpsilon]) {
               cylinder(d=screw_nominal_diameter, h=base_thickness + 2 * kEpsilon);
          }
          for(angle = fastening_angles) {
               rotate([0, 0, angle]) {
                    translate([fastening_r_offset, 0, 0]) {
                         translate([0, 0, base_thickness]) {
                              cylinder(d=screw_head_diameter, h=height);
                         }
                         translate([0, 0, -kEpsilon]) {
                              cylinder(d=screw_nominal_diameter, h=height);
                         }
                    }
               }
          }
     }
}

mPolePlug_PartB();
