include <generic/lib.scad>;

use <parts/oem/m8_nut.scad>;
use <parts/oem/m3_phillips_screw.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;
use <parts/oem/ndal_m3_washer.scad>;

use <parts/pole_plug.partA.scad>;
use <parts/pole_plug.partB.scad>;


module mPolePlug() {
     partA_datasheet = vPolePlug_PartA_Datasheet();
     partB_datasheet = vPolePlug_PartB_Datasheet();
     washer_datasheet = vNdAlM3WasherDatasheet();
     nut_datasheet = vM8NutDatasheet();

     translate([0, 0, property(partA_datasheet, "height") + property(partB_datasheet, "base_thickness")]) {
          rotate([180, 0, 0]) {
               mPolePlug_PartA();
               translate([0, 0, property(nut_datasheet, "m_max")/2 + property(partA_datasheet, "base_thickness")]) {
                    mM8Nut();
               }
               translate([0, 0, property(partA_datasheet, "height")]) {
                    for(angle = property(partA_datasheet, "fastening_angles")) {
                         rotate([0, 0, angle]) {
                              translate([property(partA_datasheet, "fastening_r_offset"), 0, 0]) {
                                   mirror([0, 0, 1]) {
                                        mM3x5mmThreadedInsert();
                                   }
                                   translate([0, 0, property(partB_datasheet, "base_thickness")]) {
                                        mM3x6mmPhillipsScrew();
                                   }
                              }
                         }
                    }
               }
               translate([0, 0, property(partA_datasheet, "height")]) {
                    mPolePlug_PartB();
                    translate([0, 0, property(partB_datasheet, "height")]) {
                         translate([0, 0, -property(washer_datasheet, "thickness")]) {
                              mirror([0, 0, 1]) {
                                   mM3x5mmThreadedInsert();
                              }
                              mNdAlM3Washer();
                         }
                         mM3x6mmPhillipsScrew();
                    }
               }
          }
     }
}

mPolePlug();
