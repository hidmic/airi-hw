include <generic/lib.scad>;

use <parts/oem/16mm_led_pushbutton.scad>;
use <parts/oem/m3_phillips_screw.scad>;
use <parts/oem/sma_female_bulkhead_connector.scad>;
use <parts/oem/usb_type_a_panel_connector.scad>;

use <parts/chassis_base_cover.scad>;
use <parts/chassis_cover.partA.scad>;
use <parts/chassis_cover.partB.scad>;
use <parts/chassis_bay.scad>;

use <pole_plug.scad>;

function vChassisCoverDatasheet() = vChassisBaseCoverDatasheet();

module mChassisCover() {
     datasheet = vChassisCoverDatasheet();

     mChassisBay();

     translate([0, 0, property(vChassisBayDatasheet(), "height")]) {
          translate([0, 0, property(datasheet, "height")]) {
               translate([0, 0, property(datasheet, "pole_socket_depth")]) mPolePlug();

               rotate([0, 0, property(datasheet, "panel_angular_offset")]) {
                    translate([property(datasheet, "panel_r_offset"), 0, 0]) {
                         let (button_diameter=v16mmLEDPushbuttonDatasheet()) {
                              duplicate([1, 0, 0]) {
                                   translate([(property(datasheet, "panel_width") +
                                               property(button_diameter, "cutout_diameter"))/4, 0, 0]) {
                                        mUSBTypeAPanelConnector();
                                   }
                              }
                         }
                         m16mmLEDPushbutton();
                    }
               }
               for(angle = property(datasheet, "fastening_angles")) {
                    rotate([0, 0, angle]) {
                         translate([property(datasheet, "fastening_r_offset"), 0, 0]) {
                              mM3x6mmPhillipsScrew();
                         }
                    }
               }
          }
          for(location = property(datasheet, "sma_conn_locations")) {
               translate(location) {
                    rotate([0, -90, 0]) mSMAFemaleBulkheadConnector();
               }
          }
          /* for(angle = property(datasheet, "sma_conn_angles")) { */
               /*      rotate([0, 0, angle]) { */
               /*           translate([property(datasheet, "inner_wireway_radius"), 0]) { */
               /*                mSMAFemaleBulkheadConnector(); */
               /*           } */
               /*      } */
               /* } */
          translate([0, 0, property(datasheet, "min_thickness")]) {
               for(angle = property(datasheet, "support_angles")) {
                    rotate([0, 0, angle]) {
                         translate([property(datasheet, "support_r_offset"), 0, 0]) {
                              mM3x12mmPhillipsScrew();
                         }
                    }
               }
          }
          for(angle = property(datasheet, "bay_support_angles")) {
               rotate([0, 0, angle]) {
                    translate([property(datasheet, "support_r_offset"), 0, 0]) {
                         mM3x12mmPhillipsScrew();
                    }
               }
          }
          mChassisCover_PartA();

          translate([0, 0, property(datasheet, "height") - property(datasheet, "min_thickness")]) {
               mChassisCover_PartB();
          }
     }
}

mChassisCover();
