include <specs.scad>;
include <lib.scad>

kJointHeight=10;
kJointDiameter=30;
kJointFilletRadius=5;
kJointBarLength=30;
kJointBarWidth=15;

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
          ring(od=kCasterJointYokeInnerDiameter,
               id=kCasterJointPinDiameter + 2 * kCasterJointGap);
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

kSuspensionLinkLength = 100;

module mSuspensionLink() {
     mBearingSupportedJoint();
     translate([kSuspensionLinkLength, 0, 0])
     rotate([0, 0, 180])
     mBushingSupportedJoint();
     translate([kJointBarLength, -kJointBarWidth/2, 0]) {
          cube([kSuspensionLinkLength - 2 * kJointBarLength,
                kJointBarWidth, kJointHeight]);
     }
}

mSuspensionLink();
//mCasterJoint();
