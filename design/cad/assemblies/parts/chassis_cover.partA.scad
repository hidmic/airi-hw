include <generic/lib.scad>;

use <oem/m3x5mm_threaded_insert.scad>;
use <oem/sma_female_bulkhead_connector.scad>;

use <chassis_base.scad>;
use <chassis_base_cover.scad>


module mChassisCover_PartA() {
     datasheet = vChassisBaseCoverDatasheet();
     height = property(datasheet, "height");
     inner_diameter = property(datasheet, "inner_diameter");
     min_thickness = property(datasheet, "min_thickness");
     support_diameter = property(datasheet, "support_diameter");

     chassis_datasheet = vChassisBaseDatasheet();
     chassis_height = property(chassis_datasheet, "height");
     chassis_outer_diameter = property(chassis_datasheet, "outer_diameter");
     chassis_fillet_radius = property(chassis_datasheet, "fillet_radius");

     outer_wireway_radius = property(datasheet, "outer_wireway_radius");
     inner_wireway_radius = property(datasheet, "inner_wireway_radius");

     wireway_width = property(datasheet, "wireway_width");
     wireway_conduit_angles = property(datasheet, "wireway_conduit_angles");
     wireway_conduit_width = property(datasheet, "wireway_conduit_width");

     support_angles = property(datasheet, "support_angles");
     support_r_offset = property(datasheet, "support_r_offset");
     bay_support_angles = property(datasheet, "bay_support_angles");

     sma_conn_datasheet = vSMAFemaleBulkheadConnectorDatasheet();
     sma_conn_thread_length = property(sma_conn_datasheet, "thread_length");
     sma_conn_thread_diameter = property(sma_conn_datasheet, "thread_diameter");
     sma_conn_locations = property(datasheet, "sma_conn_locations");

     screw_datasheet = vChassisCoverSupportScrewDatasheet();
     screw_nominal_diameter = property(screw_datasheet, "nominal_diameter");
     screw_max_head_diameter = property(screw_datasheet, "max_head_diameter");

     color($default_color) {
          difference() {
               translate([0, 0, -chassis_height + height]) {
                    difference() {
                         mChassisOuterVolume();
                         translate([0, 0, -height]) {
                              mChassisBBox();
                         }
                    }
               }
               translate([0, 0, -kEpsilon]) {
                    cylinder(r=outer_wireway_radius, h=height + 2 * kEpsilon);
               }
               for (angle = support_angles) {
                    rotate([0, 0, angle]) {
                         translate([support_r_offset, 0, 0]) {
                              cylinder(d=screw_nominal_diameter, h=2 * (height + kEpsilon), center=true);
                              translate([0, 0, min_thickness]) {
                                   cylinder(d=screw_max_head_diameter, h=height - min_thickness + kEpsilon);
                              }
                         }
                    }
               }
               for (angle = bay_support_angles) {
                    rotate([0, 0, angle]) {
                         translate([support_r_offset, 0, 0]) {
                              cylinder(d=screw_nominal_diameter, h=2 * (height + kEpsilon), center=true);
                              cylinder(d=screw_max_head_diameter, h=2 * (height + kEpsilon), center=true);
                         }
                    }
               }
          }

          difference() {
               linear_extrude(height=height - min_thickness) {
                    outline(delta=min_thickness) {
                         circle(d=inner_diameter);
                         ring(outer_radius=outer_wireway_radius,
                              inner_radius=inner_wireway_radius);
                         for(angle = wireway_conduit_angles) {
                              rotate([0, 0, angle]) {
                                   difference() {
                                        translate([outer_wireway_radius/2, 0]) {
                                             square([outer_wireway_radius, wireway_conduit_width], center=true);
                                        }
                                        circle(d=inner_diameter);
                                   }
                              }
                         }
                         for(location = sma_conn_locations) {
                              translate([location.x - sma_conn_thread_length, location.y]) {
                                   square([2 * sma_conn_thread_length, wireway_conduit_width], center=true);
                              }
                         }
                    }
                    for(angle = property(datasheet, "fastening_angles")) {
                         rotate(angle) {
                              translate([inner_wireway_radius - min_thickness/2, 0]) {
                                   curved_support_xsection(
                                        support_radius=support_diameter/2,
                                        hole_radius=screw_nominal_diameter/2,
                                        fillet_radius=chassis_fillet_radius,
                                        wall_outer_radius=inner_wireway_radius,
                                        wall_inner_radius=inner_wireway_radius - min_thickness);
                              }

                              translate([inner_diameter/2 + min_thickness/2, 0]) {
                                   curved_support_xsection(
                                        support_radius=support_diameter/2,
                                        hole_radius=screw_nominal_diameter/2,
                                        fillet_radius=chassis_fillet_radius,
                                        wall_outer_radius=inner_diameter/2 + min_thickness,
                                        wall_inner_radius=inner_diameter/2,
                                        internal=false);
                              }
                         }
                    }
               }
               for(angle = property(datasheet, "fastening_angles")) {
                    for (r_offset = property(datasheet, "fastening_r_offset")) {
                         rotate([0, 0, angle]) {
                              translate([r_offset, 0, height - min_thickness]) {
                                   mM3x5mmThreadedInsertTaperCone();
                              }
                         }
                    }
               }
               for(location = sma_conn_locations) {
                    translate(location) {
                         rotate([0, 90, 0]) {
                              translate([0, 0, -kEpsilon]) {
                                   cylinder(d=sma_conn_thread_diameter, h=min_thickness + 2 * kEpsilon);
                                   mirror([1, 0, 0]) {
                                        translate([0, -sma_conn_thread_diameter/2, 0]) {
                                             cube([height, sma_conn_thread_diameter, min_thickness + 2 * kEpsilon]);
                                        }
                                   }
                              }
                         }
                    }
               }
          }
          linear_extrude(height=min_thickness) {
               ring(outer_radius=outer_wireway_radius, inner_radius=inner_wireway_radius);
               for(angle = wireway_conduit_angles) {
                    rotate([0, 0, angle]) {
                         difference() {
                              translate([outer_wireway_radius/2, 0]) {
                                   square([outer_wireway_radius, wireway_conduit_width], center=true);
                              }
                              circle(d=inner_diameter);
                         }
                    }
               }
               for(location = sma_conn_locations) {
                    translate([location.x - sma_conn_thread_length, location.y]) {
                         square([2 * sma_conn_thread_length, wireway_conduit_width], center=true);
                    }
               }
          }
     }
}

mChassisCover_PartA();
