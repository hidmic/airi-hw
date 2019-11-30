include <generic/lib.scad>;

use <oem/mr08d_024022_motor.scad>;

function vMR08DMotorFrontCapDatasheet() =
     let (motor_datasheet=vMR08D024022MotorDatasheet())
     [["main_diameter", property(motor_datasheet, "gear_box_diameter") + 2],
      ["main_height", 10], ["wall_thickness", 1]];


module mMR08DMotorFrontCap() {
     datasheet = vMR08DMotorFrontCapDatasheet();
     main_diameter = property(datasheet, "main_diameter");
     main_height = property(datasheet, "main_height");
     wall_thickness = property(datasheet, "wall_thickness");

     module front_view_section() {
          union() {
               translate([main_diameter / 4, 0]) {
                    square([main_diameter / 2, main_diameter * 0.8], center=true);
               }
               circle(d=main_diameter);
          }
     }
     linear_extrude(height=main_height) {
          outline(delta=-wall_thickness) {
               front_view_section();
          }
     }
     linear_extrude(height=wall_thickness) {
          difference() {
               front_view_section();
               let (motor_datasheet=vMR08D024022MotorDatasheet()) {
                    circle(d=property(motor_datasheet, "bearing_diameter"));
                    for(angle = property(motor_datasheet, "mount_angles")) {
                         rotate([0, 0, angle]) {
                              translate([property(motor_datasheet, "mount_diameter")/2, 0]) {
                                   circle(d=property(motor_datasheet, "mount_hole_diameter"));
                              }
                         }
                    }
               }
          }
     }
}

mMR08DMotorFrontCap();





module mMR08DMotorClampPartB() {
     for (v = [[-kDCMotorPlusGearBoxLength/2, kDCMotorDiameter-kEpsilon],
               [-kDCMotorPlusGearBoxLength, kDCMotorBottomDiameter-kEpsilon]]) {
          let(x_offset = v[0], cut_diameter = v[1]) {
               translate([x_offset, 0, 0]) {
                    rotate([0, -90, 0]) {
                         linear_extrude(height=kChassisThickness) {
                              difference() {
                                   duplicate([0, 1, 0]) {
                                        translate([0, -kDCMotorDiameter/2 , 0]) {
                                             rotate([0, 0,  -90]) {
                                                  exp_nerve_xsection(kBeltDriveMotorAxleHeight/2, kDCMotorDiameter/4, decay_rate = 4);
                                             }
                                             square([kBeltDriveMotorAxleHeight/2, kDCMotorDiameter/2]);
                                        }
                                   }
                                   translate([kBeltDriveMotorAxleHeight, 0]) circle(d=cut_diameter);
                              }
                         }
                    }
               }
          }
     }
     duplicate([0, 1, 0]) {
          translate([-kDCMotorPlusGearBoxLength, kDCMotorDiameter/4, 0]) {
               cube([kDCMotorPlusGearBoxLength/2, kChassisThickness, kChassisThickness]);
          }
     }
}

//mMR08DMotorClampPartB();
