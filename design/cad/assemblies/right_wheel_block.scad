include <generic/lib.scad>;

use <parts/oem/100mm_rhino_rubber_wheel.scad>;
use <parts/oem/70mm_shock_absorber.scad>;
use <parts/oem/8mm_clamping_hub.scad>;
use <parts/oem/amt112s_encoder.scad>;
use <parts/oem/gt2_pulley.scad>;
use <parts/oem/m3_phillips_screw.scad>;
use <parts/oem/m3_washer.scad>;
use <parts/oem/m3_nut.scad>;
use <parts/oem/m4_phillips_screw.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;
use <parts/oem/steel_shaft.scad>;

use <parts/wheel_block_frame.scad>;
use <wheel_suspension_arm.scad>;
use <wheel_suspension_frame.scad>;

SHOW_WHEEL=true;
SHOW_BLOCK=true;
SHOW_SUSPENSION=true;


function vRightWheelBlockDatasheet() =
     let(shaft_datasheet=v100x8mmSteelShaftDatasheet())
     concat(
          [["wheel_axle_y_offset", property(shaft_datasheet, "length")/2 + 3]],
          vWheelBlockFrameDatasheet()
     );


module mRightWheelBlock() {
     datasheet = vRightWheelBlockDatasheet();
     wheel_block_frame_datasheet = vWheelBlockFrameDatasheet();
     suspension_arm_datasheet = vWheelSuspensionArmDatasheet();
     suspension_frame_datasheet = vWheelSuspensionFrameDatasheet();

     translate([0, 0, property(wheel_block_frame_datasheet, "wheel_axle_z_offset")]) {
          if (SHOW_WHEEL) {
               translate([0, -property(v100mmRhinoRubberWheelDatasheet(), "inner_width"), 0]) {
                    rotate([-90, 0, 0]) {
                         for (location = property(v8mmClampingHubDatasheet(), "mount_locations")) {
                              translate(location) mM4x16mmPhillipsScrew();
                         }
                    }
               }
               m100mmRhinoRubberWheel();
               translate([0, property(v8mmClampingHubDatasheet(), "height")/2, 0]) {
                    rotate([0, 0, -90]) m8mmClampingHub();
               }
               translate([0, property(datasheet, "wheel_axle_y_offset"), 0]) {
                    rotate([90, 0, 0]) m100x8mmSteelShaft();
               }
          }
          if (SHOW_SUSPENSION) {
               translate([0, property(wheel_block_frame_datasheet, "width")/2 + property(suspension_frame_datasheet, "height")/2, 0]) {
                    translate([property(suspension_arm_datasheet, "length") * 0.45, 0, 0]) {
                         mirror([0, 0, 1]) m70mmShockAbsorber();
                    }
                    let(frame_height=property(suspension_frame_datasheet, "height")) {
                         translate([property(suspension_frame_datasheet, "pivot_radius"), 0, 0]) {
                              rotate([90, 0, 0]) {
                                   translate([0, 0, -frame_height/2]) mM3x20mmPhillipsScrew();
                                   translate([0, 0, frame_height/2]) {
                                        translate([0, 0, property(vM3WasherDatasheet(), "thickness")]) mM3Nut();
                                        mM3Washer();
                                   }
                              }
                         }
                         rotate([0, -property(suspension_frame_datasheet, "angular_length"), 0]) {
                              translate([property(suspension_frame_datasheet, "main_radius"), 0, 0]) {
                                   rotate([90, 0, 0]) {
                                        translate([0, 0, -frame_height/2]) mM3x20mmPhillipsScrew();
                                        translate([0, 0, frame_height/2]) {
                                             translate([0, 0, property(vM3WasherDatasheet(), "thickness")]) mM3Nut();
                                             mM3Washer();
                                        }
                                   }
                              }
                         }
                         for (angle = property(suspension_frame_datasheet, "support_angles")) {
                              rotate([0, -angle, 0]) {
                                   translate([property(suspension_frame_datasheet, "main_radius"), 0, 0]) {
                                        translate([0, -frame_height/2 + property(suspension_frame_datasheet, "thickness"), 0]) {
                                             rotate([90, 0, 0]) {
                                                  translate([0, 0, -property(vM3WasherDatasheet(), "thickness")]) {
                                                       mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                                       mM3Washer();
                                                  }
                                             }
                                        }
                                   }
                              }
                         }
                    }
                    mWheelSuspensionFrame();
                    rotate([90, 0, 0]) {
                         translate([0, 0, -property(suspension_arm_datasheet, "height")/2]) {
                              mWheelSuspensionArm();
                         }
                    }
               }

               translate([0, -property(wheel_block_frame_datasheet, "width")/2 - property(suspension_frame_datasheet, "height")/2, 0]) {
                    translate([property(suspension_arm_datasheet, "length") * 0.45, 0, 0]) {
                         mirror([0, 0, 1]) m70mmShockAbsorber();
                    }
                    let(frame_height=property(suspension_frame_datasheet, "height")) {
                         translate([property(suspension_frame_datasheet, "pivot_radius"), 0, 0]) {
                              rotate([-90, 0, 0]) {
                                   translate([0, 0, -frame_height/2]) mM3x20mmPhillipsScrew();
                                   translate([0, 0, frame_height/2]) {
                                        translate([0, 0, property(vM3WasherDatasheet(), "thickness")]) mM3Nut();
                                        mM3Washer();
                                   }
                              }
                         }
                         rotate([0, -property(suspension_frame_datasheet, "angular_length"), 0]) {
                              translate([property(suspension_frame_datasheet, "main_radius"), 0, 0]) {
                                   rotate([-90, 0, 0]) {
                                        translate([0, 0, -frame_height/2]) mM3x20mmPhillipsScrew();
                                        translate([0, 0, frame_height/2]) {
                                             translate([0, 0, property(vM3WasherDatasheet(), "thickness")]) mM3Nut();
                                             mM3Washer();
                                        }
                                   }
                              }
                         }
                         for (angle = property(suspension_frame_datasheet, "support_angles")) {
                              rotate([0, -angle, 0]) {
                                   translate([property(suspension_frame_datasheet, "main_radius"), 0, 0]) {
                                        translate([0, frame_height/2 - property(suspension_frame_datasheet, "thickness"), 0]) {
                                             rotate([-90, 0, 0]) {
                                                  translate([0, 0, -property(vM3WasherDatasheet(), "thickness")]) {
                                                       mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                                       mM3Washer();
                                                  }
                                             }
                                        }
                                   }
                              }
                         }
                    }
                    mWheelSuspensionFrame();
                    translate([0, -property(suspension_arm_datasheet, "height")/2 - kEpsilon, 0]) {
                         rotate([180, 0, 0]) {
                              rotate([0, 90, 0]) {
                                   mAMT112SEncoder();
                              }
                         }
                    }
                    rotate([-90, 0, 0]) {
                         translate([0, 0, -property(suspension_arm_datasheet, "height")/2]) {
                              mWheelSuspensionArm();
                         }
                    }
               }
          }
     }
     if (SHOW_BLOCK) {
          rotate([90, 0, 0]) {
               translate([0, property(wheel_block_frame_datasheet, "wheel_axle_z_offset"), 0]) {
                    duplicate([0, 0, 1]) {
                         for(angle = property(wheel_block_frame_datasheet, "support_angles")) {
                              rotate([0, 0, angle])
                                   translate([property(wheel_block_frame_datasheet, "support_r_offset"),
                                              0, -property(wheel_block_frame_datasheet, "width")/2]) {
                                   mM3x5mmThreadedInsert();
                              }
                         }
                    }
               }
               translate([0, 0, -property(wheel_block_frame_datasheet, "width")/2]) {
                    mWheelBlockFrame();
               }
          }
     }
}

mRightWheelBlock();
