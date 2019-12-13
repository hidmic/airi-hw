include <generic/lib.scad>;

use <oem/16mm_led_pushbutton.scad>;
use <oem/m3_phillips_screw.scad>;
use <oem/rplidar_a1m8_r1.scad>;
use <oem/sma_female_bulkhead_connector.scad>;
use <oem/usb_type_a_panel_connector.scad>;

use <chassis_base.scad>;


function vChassisBaseCoverDatasheet() =
     let(chassis_datasheet=vChassisBaseDatasheet(),
         inner_diameter=property(chassis_datasheet, "inner_diameter"),
         min_thickness=property(chassis_datasheet, "thickness"),
         bay_height=property(vRPLidarA1M8R1Datasheet(), "working_width") + 2,
         height=(property(chassis_datasheet, "height") -
                 property(chassis_datasheet, "base_height") -
                 bay_height), cover_support_diameter=10,
         inner_wireway_radius=50, outer_wireway_radius=170)
     [["height", height], ["bay_height", bay_height], ["panel_depth", height - min_thickness],
      ["panel_length", 40], ["panel_width", 80], ["panel_angular_offset", 0],
      ["panel_r_offset", -(inner_wireway_radius + outer_wireway_radius)/2],
      ["wireway_depth", height - min_thickness], ["inner_wireway_radius", inner_wireway_radius],
      ["outer_wireway_radius", outer_wireway_radius], ["wireway_conduit_angles", [-135, -45, 45, 135]],
      ["wireway_conduit_width", 25], ["wireway_width", 15], ["wireway_taper_angle", 30],
      ["support_angles", [-165, -135, -105, -75, 75, 105, 135, 165]],
      ["bay_support_angles", [-90, 90, 180]], ["sma_conn_angles", [-45, 45]],
      ["support_r_offset", inner_diameter/2 - cover_support_diameter/2],
      ["support_diameter", cover_support_diameter], ["pole_socket_diameter", 50],
      ["pole_socket_depth", height - min_thickness], ["pole_socket_taper_angle", 45],
      ["min_thickness", min_thickness]];


function vChassisCoverSupportScrewDatasheet() = vM3PhillipsScrewDatasheet();


module mChassisBaseCover() {
     datasheet = vChassisBaseCoverDatasheet();
     height = property(datasheet, "height");
     min_thickness = property(datasheet, "min_thickness");

     outer_wireway_radius = property(datasheet, "outer_wireway_radius");
     inner_wireway_radius = property(datasheet, "inner_wireway_radius");

     wireway_depth = property(datasheet, "wireway_depth");
     wireway_width = property(datasheet, "wireway_width");
     wireway_taper_angle = property(datasheet, "wireway_taper_angle");
     wireway_conduit_angles = property(datasheet, "wireway_conduit_angles");
     wireway_conduit_width = property(datasheet, "wireway_conduit_width");

     support_angles = property(datasheet, "support_angles");
     support_r_offset = property(datasheet, "support_r_offset");
     bay_support_angles = property(datasheet, "bay_support_angles");

     pole_socket_depth = property(datasheet, "pole_socket_depth");
     pole_socket_diameter = property(datasheet, "pole_socket_diameter");
     pole_socket_taper_angle = property(datasheet, "pole_socket_taper_angle");

     panel_depth = property(datasheet, "panel_depth");
     panel_length = property(datasheet, "panel_length");
     panel_width = property(datasheet, "panel_width");
     panel_angular_offset = property(datasheet, "panel_angular_offset");
     panel_r_offset = property(datasheet, "panel_r_offset");

     sma_conn_angles = property(datasheet, "sma_conn_angles");

     chassis_datasheet = vChassisBaseDatasheet();
     chassis_height = property(chassis_datasheet, "height");
     fillet_radius = property(chassis_datasheet, "fillet_radius");

     pushbutton_cutout_diameter = property(v16mmLEDPushbuttonDatasheet(), "cutout_diameter");

     usb_conn_datasheet = vUSBTypeAPanelConnectorDatasheet();
     usb_conn_cutout_length = property(usb_conn_datasheet, "cutout_length");
     usb_conn_cutout_width = property(usb_conn_datasheet, "cutout_width");

     screw_datasheet = vChassisCoverSupportScrewDatasheet();
     screw_nominal_diameter = property(screw_datasheet, "nominal_diameter");
     screw_max_head_diameter = property(screw_datasheet, "max_head_diameter");

     difference() {
          translate([0, 0, height - wireway_depth]) {
               difference() {
                    union() {
                         difference() {
                              union() {
                                   difference() {
                                        translate([0, 0, wireway_depth - chassis_height]) {
                                             difference() {
                                                  mChassisOuterVolume();
                                                  translate([0, 0, -height]) {
                                                       mChassisBBox();
                                                  }
                                             }
                                        }
                                        cylinder(r1=(outer_wireway_radius + wireway_width/2),
                                                 r2=(outer_wireway_radius + wireway_width/2 +
                                                     (wireway_depth + kEpsilon) * tan(wireway_taper_angle)),
                                                 h=wireway_depth + kEpsilon);
                                   }
                                   cylinder(r1=(outer_wireway_radius - wireway_width/2),
                                            r2=(outer_wireway_radius - wireway_width/2 -
                                                (wireway_depth + kEpsilon) * tan(wireway_taper_angle)),
                                            h=wireway_depth);
                              }
                              cylinder(r1=(inner_wireway_radius + wireway_width/2),
                                       r2=(inner_wireway_radius + wireway_width/2 +
                                           (wireway_depth + kEpsilon) * tan(wireway_taper_angle)),
                                       h=wireway_depth + kEpsilon);
                         }
                         cylinder(r1=(inner_wireway_radius - wireway_width/2),
                                  r2=(inner_wireway_radius - wireway_width/2 -
                                      (wireway_depth + kEpsilon) * tan(wireway_taper_angle)),
                                  h=wireway_depth);
                    }
                    for(angle = wireway_conduit_angles) {
                         rotate([0, 0, angle]) {
                              rotate([0, 0, -90])
                                   translate([-wireway_conduit_width/2, inner_wireway_radius, 0]) {
                                   cube([wireway_conduit_width,
                                         outer_wireway_radius - inner_wireway_radius,
                                         wireway_depth + kEpsilon]);
                              }
                         }
                    }
               }
          }
          translate([0, 0, height - pole_socket_depth]) {
               cylinder(d1=pole_socket_diameter - 2 * pole_socket_depth * tan(pole_socket_taper_angle),
                        d2=pole_socket_diameter, h=pole_socket_depth + kEpsilon);
          }

          cylinder(d=screw_nominal_diameter, h=2 * (min_thickness + kEpsilon), center=true);

          rotate([0, 0, panel_angular_offset])
          translate([panel_r_offset, 0, 0]) {
               rotate([0, 0, -90]) {
                    translate([0, 0, height - panel_depth]) {
                         linear_extrude(height=panel_depth + kEpsilon, scale=1.05) {
                              fillet(r=fillet_radius) square([panel_length, panel_width], center=true);
                         }
                    }
                    translate([0, 0, -kEpsilon]) {
                         cylinder(d=pushbutton_cutout_diameter, h=height - panel_depth + 2 * kEpsilon);
                         duplicate([0, 1, 0]) {
                              translate([0, (panel_width + pushbutton_cutout_diameter)/4, 0]) {
                                   translate([-usb_conn_cutout_width/2, -usb_conn_cutout_length/2, 0]) {
                                        cube([usb_conn_cutout_width,
                                              usb_conn_cutout_length,
                                              height - panel_depth + 2 * kEpsilon]);
                                   }
                              }
                         }
                    }
               }
          }
          linear_extrude(height=2 * (height - panel_depth + kEpsilon), center=true) {
               for(angle = sma_conn_angles) {
                    rotate([0, 0, angle]) {
                         translate([inner_wireway_radius, 0]) {
                              mSMAFemaleBulkheadConnectorCutuotSection();
                         }
                    }
               }
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
}

mChassisBaseCover();
