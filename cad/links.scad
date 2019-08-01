include <specs.scad>;
include <lib.scad>



module mBushingSupportedJoint() {
     bar_length = kJointDiameter + 2 * kJointFilletRadius;
     bar_width = kJointDiameter/2 + 2 * kJointFilletRadius;
     difference() {
          linear_extrude(height=kJointHeight) {
               offset(r=-kJointFilletRadius) {
                    circle(d=kJointDiameter + 2 * kJointFilletRadius);
                    translate([0, -bar_width/2, 0]) {
                         square([bar_length, bar_width]);
                    }
               }
          }
          mBushingHull();
     }
     mBushing();
}


kCasterJointGap = 0.5;
kCasterJointYokeThickness = 2;
kCasterJointYokeHeight = kThrustBearingHeight + 2 * kCasterJointYokeThickness + kCasterJointGap;
kCasterJointYokeOuterDiameter = kThrustBearingOuterDiameter + 2 * kCasterJointYokeThickness;
kCasterJointYokeInnerDiameter = kThrustBearingOuterDiameter;
kCasterJointYokeSupportDiameter = kM3x4_8ThreadedInsertDiameter + kCasterJointYokeThickness;

kCasterJointPinDiameter = kThrustBearingInnerDiameter;

module mCasterJointYokeCrossSection() {
     rho = (kCasterJointYokeSupportDiameter + kCasterJointYokeOuterDiameter)/2;
     for(psi=[0, 90]) {
          rotate([0, 0, psi]) {
               difference() {
                    hull() {
                         for(theta=[0, 180]) {
                              translate([rho * cos(theta), rho * sin(theta)]) {
                                   circle(d=kCasterJointYokeSupportDiameter);
                              }
                         }
                         circle(d=kCasterJointYokeOuterDiameter);
                    }
                    for(theta=[0, 180]) {
                         translate([rho * cos(theta), rho * sin(theta)]) {
                              circle(d=kM3x4_8ThreadedInsertDiameter);
                         }
                    }
                    circle(d=kCasterJointYokeInnerDiameter);
               }
          }
     }
}

module mCasterJoint() {
     h = kCasterJointYokeThickness + kThrustBearingHeight/2;
     linear_extrude(height=h) {
          mCasterJointYokeCrossSection();
     }
     translate([0, 0, h])
     linear_extrude(height=kCasterJointYokeHeight-h) {
          difference() {
               mCasterJointYokeCrossSection();
               circle(d=kCasterJointYokeInnerDiameter + 2 * kCasterJointGap);
          }
     }
     rho = (kCasterJointYokeSupportDiameter + kCasterJointYokeOuterDiameter)/2;
     for(theta=[0:90:270]) {
          translate([rho * cos(theta), rho * sin(theta), kCasterJointYokeHeight]) {
               mM3x4_8ThreadedInsert();
          }
     }
     linear_extrude(height=kCasterJointYokeThickness) {
          ring(outer_diameter=kCasterJointYokeInnerDiameter,
               inner_diameter=kCasterJointPinDiameter + 2 * kCasterJointGap);
     }
     translate([0, 0, -kCasterJointGap]) {
          difference() {
               union() {
                    translate([0, 0, kCasterJointYokeHeight - kCasterJointYokeThickness])
                         cylinder(d=kCasterJointYokeInnerDiameter - 2 * kCasterJointGap,
                                  h=kCasterJointYokeThickness);
                    cylinder(d=kCasterJointPinDiameter, h=kCasterJointYokeHeight);
               }
               translate([0, 0, -kEpsilon/2])
                    cylinder(d=kM3x4_8ThreadedInsertDiameter, h=kCasterJointYokeHeight+kEpsilon);
          }
          rotate([180, 0, 0])
          mM3x4_8ThreadedInsert();
     }
     translate([0, 0,  kThrustBearingHeight + kCasterJointYokeThickness])
     rotate([180, 0, 0])
     mThrustBearing();
}

/* module mSuspensionLink() { */
/*      mBearingSupportedJoint(); */
/*      translate([kSuspensionLinkLength, 0, 0]) */
/*      rotate([0, 0, 180]) */
/*      mBushingSupportedJoint(); */
/*      translate([kJointBarLength, -kJointBarWidth/2, 0]) { */
/*           cube([kSuspensionLinkLength - 2 * kJointBarLength, */
/*                 kJointBarWidth, kJointHeight]); */
/*      } */
/* } */

kCurvedLinkThickness = 3;
kCurvedLinkWidth = 10;
kCurvedLinkAngularLength = 130;
kCurvedLinkFasteningAngles = [30, 120];
kCurvedLinkFasteningAngularDelta = 5;
kCurvedLinkShockMountsAngularRange = [10:10:120];
kCurvedLinkFillet = 3;


module mCurvedLink() {
     linear_extrude(height=kCurvedLinkThickness, center=true) {
          difference() {
               fillet(kCurvedLinkFillet) {
                    rounded_ring(inner_radius=kSuspensionLinkBarLength - kCurvedLinkWidth/2,
                                 outer_radius=kSuspensionLinkBarLength + kCurvedLinkWidth/2 + kWheelCaseThickness,
                                 angles=[0, kCurvedLinkAngularLength]);
                    translate([kSuspensionLinkBarLength, 0]) {
                         circle(d=kPivotJointDiameter);
                    }
               }
               translate([kSuspensionLinkBarLength, 0]) {
                    circle(d=kBushingInnerDiameter);
               }
               for (angle = kCurvedLinkFasteningAngles) {
                    rounded_ring(inner_radius=kSuspensionLinkBarLength - kCurvedLinkSupportHoleDiameter/2,
                                 outer_radius=kSuspensionLinkBarLength + kCurvedLinkSupportHoleDiameter/2,
                                 angles=[angle - kCurvedLinkFasteningAngularDelta/2,
                                         angle + kCurvedLinkFasteningAngularDelta/2]);
               }
               for (angle = kCurvedLinkShockMountsAngularRange) {
                    rotate(angle) {
                         translate([kSuspensionLinkBarLength, 0]) {
                              circle(d=kCurvedLinkSupportHoleDiameter);
                         }
                    }
               }
          }
     }
}



module mBearingSupportedJoint() {
     bar_length = kJointBarLength + 2 * kJointFilletRadius;
     bar_width = kJointBarWidth + 2 * kJointFilletRadius;
     difference() {
          linear_extrude(height=kJointHeight) {
               offset(r=-kJointFilletRadius) {
                    circle(d=kJointDiameter + 2 * kJointFilletRadius);
                    translate([0, -bar_width/2, 0]) {
                         square([bar_length, bar_width]);
                    }
               }
          }
          translate([0, 0, kJointHeight - kBearingHeight])
          mBearingHull();
          translate([0, 0, -kEpsilon])
          mRoundShaftL100();
     }
     translate([0, 0, kJointHeight - kBearingHeight])
     mBearing();
}




kSuspensionLinkBarLength = 65;
kSuspensionLinkBarWidth = 10;
kSuspensionLinkBarFillet = 5;
kSuspensionLinkBarThickness = 3;

kAxleJointHeight = kBearingHeight + 1;
kPivotJointHeight = kBushingHeight;
kAxleJointDiameter = 30;
kPivotJointDiameter = 15;

kM3ScrewDiameter = 3;


kAxleJointFasteningAngles = kEncoderMountingAngles;
kAxleJointFasteningDiameter = kEncoderMountingDiameter;
kAxleJointFasteningHoleDiameter = kEncoderMountingHoleDiameter;

kPivotJointFasteningAngles = kAxleJointFasteningAngles;
kPivotJointFasteningDiameter = (kPivotJointDiameter + kBushingOuterDiameter)/2;
kPivotJointFasteningHoleDiameter = kAxleJointFasteningHoleDiameter;

kSuspensionLinkHeight = 2 * kSuspensionLinkBarThickness + kAxleJointHeight;

module mSuspensionLink() {
     duplicate([0, 0, 1]) {
          translate([0, 0, -kAxleJointHeight/2 - kSuspensionLinkBarThickness/2]) {
               mSuspensionLinkBar();
          }
     }
     mSuspensionLinkAxleJoint();
     translate([0, 0, -kBearingHeight/2]) {
          mBearing();
     }
     translate([kSuspensionLinkBarLength, 0, 0]) {
          mSuspensionLinkPivotJoint();
          translate([0, 0, -kBushingHeight/2]) {
               mBushing();
          }
     }
}

module mSuspensionLinkAxleJointXSection() {
     difference() {
          circle(d=kAxleJointDiameter);
          for (angle = kAxleJointFasteningAngles) {
               rotate([0, 0, angle]) {
                    translate([kAxleJointFasteningDiameter/2, 0]) {
                         circle(d=kAxleJointFasteningHoleDiameter);
                    }
               }
          }
          circle(d=kBearingOuterDiameter);
     }
}

module mSuspensionLinkAxleJoint() {
     linear_extrude(height=kAxleJointHeight, center=true) {
          mSuspensionLinkAxleJointXSection();
     }
}

module mSuspensionLinkPivotJointXSection() {
     difference() {
          circle(d=kPivotJointDiameter);
          for (angle = kPivotJointFasteningAngles) {
               rotate([0, 0, angle]) {
                    translate([kPivotJointFasteningDiameter/2, 0]) {
                         circle(d=kPivotJointFasteningHoleDiameter);
                    }
               }
          }
          circle(d=kBushingOuterDiameter);
     }
}

module mSuspensionLinkPivotJoint() {
     linear_extrude(height=kPivotJointHeight, center=true) {
          mSuspensionLinkPivotJointXSection();
     }
}

module mSuspensionLinkBar() {
     linear_extrude(height=kSuspensionLinkBarThickness, center=true) {
          difference() {
               offset(r=-kSuspensionLinkBarFillet) {
                    offset(delta=kSuspensionLinkBarFillet) {
                         translate([kSuspensionLinkBarLength/2, 0]) {
                              square([kSuspensionLinkBarLength, kSuspensionLinkBarWidth], center=true);
                         }
                         circle(d=kAxleJointDiameter);
                         translate([kSuspensionLinkBarLength, 0]) {
                              circle(d=kPivotJointDiameter);
                         }
                    }
               }
               circle(d=(kBearingOuterDiameter + kRoundShaftDiameter)/2);
               for (angle = kAxleJointFasteningAngles) {
                    rotate([0, 0, angle]) {
                         translate([kAxleJointFasteningDiameter/2, 0]) {
                              circle(d=kAxleJointFasteningHoleDiameter);
                         }
                    }
               }
               translate([kSuspensionLinkBarLength, 0]) {
                    circle(d=(kBushingOuterDiameter + kBushingInnerDiameter)/2);
                    for (angle = kPivotJointFasteningAngles) {
                         rotate([0, 0, angle]) {
                              translate([kPivotJointFasteningDiameter/2, 0]) {
                                   circle(d=kPivotJointFasteningHoleDiameter);
                              }
                         }
                    }
               }
               for (x = steps(kAxleJointDiameter/2+5, kSuspensionLinkBarLength-kPivotJointDiameter/2-5, 6)) {
                    translate([x, 0, 0]) circle(d=kM3ScrewDiameter);
               }
          }
     }
}



kSuspensionArmHeight = kSuspensionLinkHeight + 2 * kCurvedLinkThickness;

module mSuspensionArm() {
     rotate([90, 0, 0]) {
          duplicate([0, 0, 1]) {
               translate([0, 0, -kSuspensionLinkHeight/2-kCurvedLinkThickness/2]) {
                    mCurvedLink();
               }
          }
          mSuspensionLink();
     }
}

//translate([0, 0, -kAxleJointHeight/2])

/* translate([kSuspensionLinkLength, 0]) { */
/* difference() { */
/*      circle(d=kPivotJointDiameter); */
/*      circle(d=kBushingOuterDiameter); */
/* } */
/* } */

/* difference() { */
/*      circle(d=kAxleJointDiameter); */
/*      circle(d=(kBearingOuterDiameter + kRoundShaftDiameter)/2); */
/*      for (angle = kEncoderMountingAngles) { */
/*           rotate([0, 0, angle]) */
/*           translate([kEncoderMountingDiameter/2, 0]) */
/*           circle(d=kEncoderMountingHoleDiameter); */
/*      } */
/* } */



kWheelAxleZOffset = 48 - 15.5 - 3;

kWheelCaseWidth = 40;
kWheelCaseDiameter = 140;
kWheelCaseThickness = 3;
kWheelCaseToeWidth = 15;

kCurvedLinkSupportHoleDiameter = 4;
kCurvedLinkSupportDiameter = 10;
kCurvedLinkSupportBaseWidth = 16;
kCurvedLinkSupportFilletRadius = 4;

module mCurvedLinkSupportXSection() {
     rotate([0, 0, 180]) {
          difference() {
               window(4*kCurvedLinkSupportDiameter) {
                    curved_bench_fillet(kCurvedLinkSupportFilletRadius, bench_radius=kWheelCaseDiameter/2) {
                         hull() {
                              translate([(kCurvedLinkSupportDiameter + kWheelCaseThickness)/2, 0]) {
                                   circle(d=kCurvedLinkSupportDiameter);
                              }
                              translate([kWheelCaseDiameter/2 + kWheelCaseThickness/2, 0])
                                   ring(inner_radius=kWheelCaseDiameter/2,
                                        outer_radius=kWheelCaseDiameter/2 + kWheelCaseThickness,
                                        angles=[170, 190]);
                         }
                         translate([kWheelCaseDiameter/2 + kWheelCaseThickness/2, 0])
                              ring(inner_radius=kWheelCaseDiameter/2,
                                   outer_radius=kWheelCaseDiameter/2 + kWheelCaseThickness,
                                   angles=[150, 210]);
                    }
               }
               translate([kCurvedLinkSupportDiameter/2 + kWheelCaseThickness, 0]) {
                    circle(d=kCurvedLinkSupportHoleDiameter);
               }
          }
     }
}


module mWheelCase() {
     rotate([90, 0, 0])
     linear_extrude(height=kWheelCaseWidth, center=true) {
          translate([0, kWheelAxleZOffset]) {
               ring(inner_radius=kWheelCaseDiameter/2,
                    outer_radius=kWheelCaseDiameter/2 + kWheelCaseThickness,
                    angles=[0, 180]);
               for(angle=kCurvedLinkFasteningAngles) {
                    rotate([0, 0, angle]) {
                         translate([kWheelCaseDiameter/2 + kWheelCaseThickness, 0]) {
                              mCurvedLinkSupportXSection();
                         }
                    }
               }
          }
          duplicate([1, 0, 0]) {
               translate([-kWheelCaseDiameter/2 - kWheelCaseThickness, 0]) {
                    square([kWheelCaseToeWidth, kWheelCaseThickness]);
                    square([kWheelCaseThickness, kWheelAxleZOffset]);
               }
          }
     }
}

module mWheelBlock() {
     translate([0, 0, kWheelAxleZOffset]) {
          duplicate([0, 1, 0]) {
               translate([0, kWheelCaseWidth/2 + kSuspensionArmHeight/2, 0]) {
                    mSuspensionArm();
               }
          }
          translate([0, kWheelCaseWidth/2 + kSuspensionArmHeight - kCurvedLinkThickness, 0]) {
               rotate([0, 90, 0]) mEncoder();
          }
          translate([0, -kWheelCaseWidth/2 - kSuspensionArmHeight - 10, 0]) {
               rotate([0, 0, -90]) mMountedRoundBeltPulley();
          }
          mRoundShaftL100();
          mRubberWheel();
     }
     mWheelCase();

     duplicate([0, 1, 0]) {
          translate([27, -kWheelCaseWidth/2-kSuspensionArmHeight/2, kWheelAxleZOffset - 3]) {
               rotate([180, 5, 0]) mShockAbsorber();
          }
     }
}

$fn = 64;

kDCMotorAxleZOffset = 20;

duplicate([0, 1, 0])
translate([0, 40, 0]) {
translate([30, -10, 0]) {
translate([0, 0, kDCMotorAxleZOffset]) {
     rotate([180, 0, 0]) {
     translate([-kDCMotorShaftLength, 0, 0])
     mDCMotor();
     mTransmission();
     }
}
}
translate([-85, 90, 0])
mWheelBlock();
}

translate([-85, 0, 0]) {
     color([1, 0, 0])

          translate([-110, 0, 45]) 
cube([120, 150, 90], center=true);
circle(d=400);
}
translate([0, 0, 40])
mLidar();
