include <generic/lib.scad>;

use <oem/16mm_led_pushbutton.scad>;
use <oem/sma_female_bulkhead_connector.scad>;
use <oem/usb_type_a_panel_connector.scad>;

use <chassis_base.scad>;
use <chassis_base_cover.scad>;


module mChassisCover_PartB() {
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

     support_angles = property(datasheet, "support_angles");
     support_r_offset = property(datasheet, "support_r_offset");
     bay_support_angles = property(datasheet, "bay_support_angles");

     pole_socket_depth = property(datasheet, "pole_socket_depth");
     pole_socket_diameter = property(datasheet, "pole_socket_diameter");
     pole_socket_taper_angle = property(datasheet, "pole_socket_taper_angle");
     pole_block_diameter = property(datasheet, "pole_block_diameter");
     pole_block_taper_angle = property(datasheet, "pole_block_taper_angle");

     panel_depth = property(datasheet, "panel_depth");
     panel_length = property(datasheet, "panel_length");
     panel_width = property(datasheet, "panel_width");
     panel_angular_offset = property(datasheet, "panel_angular_offset");
     panel_r_offset = property(datasheet, "panel_r_offset");

     pushbutton_cutout_diameter = property(v16mmLEDPushbuttonDatasheet(), "cutout_diameter");

     usb_conn_datasheet = vUSBTypeAPanelConnectorDatasheet();
     usb_conn_cutout_length = property(usb_conn_datasheet, "cutout_length");
     usb_conn_cutout_width = property(usb_conn_datasheet, "cutout_width");

     screw_datasheet = vChassisCoverSupportScrewDatasheet();
     screw_nominal_diameter = property(screw_datasheet, "nominal_diameter");
     screw_max_head_diameter = property(screw_datasheet, "max_head_diameter");

     color($default_color) {
          difference() {
               linear_extrude(height=min_thickness) {
                    difference() {
                         circle(r=inner_wireway_radius);
                         rotate([0, 0, panel_angular_offset]) {
                              translate([panel_r_offset, 0, 0]) {
                                   rotate([0, 0, -90]) {
                                        circle(d=pushbutton_cutout_diameter);
                                        duplicate([0, 1, 0]) {
                                             translate([0, (panel_width + pushbutton_cutout_diameter)/4]) {
                                                  translate([-usb_conn_cutout_width/2, -usb_conn_cutout_length/2]) {
                                                       square([usb_conn_cutout_width, usb_conn_cutout_length]);
                                                  }
                                             }
                                        }
                                   }
                              }
                         }
                         for(angle = property(datasheet, "fastening_angles")) {
                              for (r_offset = property(datasheet, "fastening_r_offset")) {
                                   rotate([0, 0, angle]) {
                                        translate([r_offset, 0]) {
                                             circle(d=screw_nominal_diameter);
                                        }
                                   }
                              }
                         }
                         circle(d=screw_nominal_diameter);
                    }
               }
               translate([0, 0, min_thickness/2]) {
                    linear_extrude(height=min_thickness/2) {
                         for (angle = [-120, 0, 120]) {
                              rotate([0, 0, angle]) {
                                   translate([inner_diameter, 0]) {
                                        wifi_logo(10);
                                   }
                              }
                         }
                    }
               }
          }
          translate([0, 0, min_thickness]) {
               let(pole_block_major_diameter=pole_block_diameter + 2 * pole_socket_depth * tan(pole_block_taper_angle),
                   pole_block_minor_diameter=pole_block_diameter, pole_socket_major_diameter=pole_socket_diameter,
                   pole_socket_minor_diameter=pole_socket_diameter - 2 * pole_socket_depth * tan(pole_socket_taper_angle)) {
                    difference() {
                         cylinder(d1=pole_block_major_diameter,
                                  d2=pole_block_minor_diameter,
                                  h=pole_socket_depth);
                         translate([0, 0, kEpsilon]) {
                              cylinder(d1=pole_socket_minor_diameter,
                                       d2=pole_socket_major_diameter,
                                       h=pole_socket_depth + kEpsilon);
                         }

                    }
               }
          }
     }
}

mChassisCover_PartB();
