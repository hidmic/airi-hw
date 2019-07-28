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

kSuspensionSupportWidth = 10;


module mSuspensionSupport() {
     difference() {
          rounded_ring(inner_diameter=2 * (kSuspensionLinkBarLength - kSuspensionSupportWidth/2),
                       outer_diameter=2 * (kSuspensionLinkBarLength + kSuspensionSupportWidth/2),
                       angles=[0, 155]);
          translate([kSuspensionLinkBarLength, 0])
          circle(d=kBushingInnerDiameter);
          for(angle = [20:10:140]) {
               rotate([0, 0, angle])
               translate([kSuspensionLinkBarLength, 0])
               circle(d=4);
          }
          for(angle = [15:10:145]) {
               rotate([0, 0, angle]) {
                    hull() {
                         for(theta = [-1, 1]) {
                              rotate([0, 0, theta])
                              translate([kSuspensionLinkBarLength, 0])
                              circle(d=4);
                         }
                    }
               }
          }
          
          /* rounded_ring(inner_diameter=2 * (kSuspensionLinkBarLength - kSuspensionSupportWidth/6), */
          /*              outer_diameter=2 * (kSuspensionLinkBarLength + kSuspensionSupportWidth/6), */
          /*              angles=[-5, 40]); */
          /* rounded_ring(inner_diameter=2 * (kSuspensionLinkBarLength - kSuspensionSupportWidth/6), */
          /*              outer_diameter=2 * (kSuspensionLinkBarLength + kSuspensionSupportWidth/6), */
          /*              angles=[50, 95]); */
     }
}


mSuspensionSupport();

/* rotate_extrude() { */
/*      square(10); */
/*      translate([10, 0]) */
/*           sigmoid_profile(10, 10); */
/* } */
//mSuspensionLink();


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




kSuspensionLinkBarLength = 80;
kSuspensionLinkBarWidth = 10;
kSuspensionLinkBarFillet = 5;
kSuspensionLinkBarThickness = 3;

kAxleJointHeight = kBearingHeight + 1;

kAxleJointDiameter = 35;
kPivotJointDiameter = 20;

kM3ScrewDiameter = 3;

kEncoderMountingDiameter = 25.4;
kEncoderMountingAngles = [-135, -45, 45, 135];
kEncoderMountingHoleDiameter = 2;

kAxleJointFasteningAngles = kEncoderMountingAngles;
kAxleJointFasteningDiameter = kEncoderMountingDiameter;
kAxleJointFasteningHoleDiameter = kEncoderMountingHoleDiameter;

kPivotJointFasteningAngles = kAxleJointFasteningAngles;
kPivotJointFasteningDiameter = (kPivotJointDiameter + kBushingOuterDiameter)/2;
kPivotJointFasteningHoleDiameter = kAxleJointFasteningHoleDiameter;

kSuspensionLinkAssemblyHeight = 2 * kSuspensionLinkBarThickness + kAxleJointHeight;


module mSuspensionLink() {
     translate([0, 0, -kBearingHeight/2]) mBearing();
}

module mSuspensionLinkAxleJointXSection() {
     difference() {
          circle(d=kAxleJointDiameter);
          for (angle = kAxleJointFasteningAngles) {
               rotate([0, 0, angle])
                    translate([kAxleJointFasteningDiameter/2, 0])
                    circle(d=kAxleJointFasteningHoleDiameter);
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
               rotate([0, 0, angle])
                    translate([kPivotJointFasteningDiameter/2, 0])
                    circle(d=kPivotJointFasteningHoleDiameter);
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
                         translate([kSuspensionLinkBarLength/2, 0])
                         square([kSuspensionLinkBarLength, kSuspensionLinkBarWidth], center=true);
                         circle(d=kAxleJointDiameter);
                         translate([kSuspensionLinkBarLength, 0])
                         circle(d=kPivotJointDiameter);
                    }
               }
               circle(d=(kBearingOuterDiameter + kRoundShaftDiameter)/2);
               for (angle = kAxleJointFasteningAngles) {
                    rotate([0, 0, angle])
                         translate([kAxleJointFasteningDiameter/2, 0])
                         circle(d=kAxleJointFasteningHoleDiameter);
               }
               translate([kSuspensionLinkBarLength, 0]) {
                    circle(d=(kBushingOuterDiameter + kBushingInnerDiameter)/2);
                    for (angle = kPivotJointFasteningAngles) {
                         rotate([0, 0, angle])
                         translate([kPivotJointFasteningDiameter/2, 0])
                         circle(d=kPivotJointFasteningHoleDiameter);
                    }
               }
               for (x = steps(kAxleJointDiameter/2+5, kSuspensionLinkBarLength-kPivotJointDiameter/2-5, 6)) {
                    translate([x, 0, 0]) circle(d=kM3ScrewDiameter);
               }
          }
     }
}

mSuspensionLinkBar();


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





kWheelCaseWidth = 50;
kWheelCaseDiameter = 140;
kWheelCaseOffset = 13;
kWheelCaseThickness = 3;

kCurvedLinkSupportHoleDiameter = 4;
kCurvedLinkSupportDiameter = 10;
kCurvedLinkSupportBaseWidth = 16;
kCurvedLinkSupportFilletRadius = 4;

module mCurvedLinkSupportXSection() {
     rotate([0, 0, 180])
     difference() {
          window(4*kCurvedLinkSupportDiameter) {
               curved_bench_fillet(kCurvedLinkSupportFilletRadius, bench_radius=kWheelCaseDiameter/2) {
                    hull() {
                         translate([(kCurvedLinkSupportDiameter + kWheelCaseThickness)/2, 0]) {
                              circle(d=kCurvedLinkSupportDiameter);
                         }
                         translate([kWheelCaseDiameter/2 + kWheelCaseThickness/2, 0])
                              ring(inner_diameter=kWheelCaseDiameter, outer_diameter=kWheelCaseDiameter + 2 * kWheelCaseThickness, angles=[170, 190]);
                    }
                    translate([kWheelCaseDiameter/2 + kWheelCaseThickness/2, 0])
                         ring(inner_diameter=kWheelCaseDiameter, outer_diameter=kWheelCaseDiameter + 2 * kWheelCaseThickness, angles=[150, 210]);
               }
          }
          translate([(kCurvedLinkSupportDiameter + kWheelCaseThickness)/2, 0]) {
               circle(d=kCurvedLinkSupportHoleDiameter);
          }
     }
}


module mWheelCase() {
     linear_extrude(height=kWheelCaseWidth, center=true) {
          translate([kWheelCaseOffset, 0]) {
               ring(inner_diameter=kWheelCaseDiameter,
                    outer_diameter=kWheelCaseDiameter + 2 * kWheelCaseThickness,
                    angles=[-90, 90]);
               for(angle=[-45, 45]) {
                    rotate([0, 0, angle]) {
                         translate([kWheelCaseDiameter/2 + kWheelCaseThickness, 0])
                              mCurvedLinkSupportXSection();
                    }
               }
          }
          duplicate([0, 1, 0]) {
               translate([0, -kWheelCaseDiameter/2 - kWheelCaseThickness]) {
                    square([kWheelCaseOffset, kWheelCaseThickness]);
                    square([kWheelCaseThickness, kWheelCaseOffset]);
               }
          }
     }
}

//mWheelCase();

