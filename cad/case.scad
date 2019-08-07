include <specs.scad>;
use <lib.scad>;

$fn = 64;


kChassisDiameter = 420;
kChassisHeight = 110;
kChassisThickness = 2;
kChassisFilletRadius = 5;

kChassisBaseHeight = 100;

kChassisWirewayRadius = 120;
kChassisWirewayDepth = 10;
kChassisWirewayWidth = 10;
kChassisWirewayAngle = 20;

kChassisSlitHeight = kChassisHeight - 9;
kChassisSlitWidth = kA1M8r1WorkingWidth + 2;

kSonarMountingAngles = [-45, 0, 45];
kSonarCount = len(kSonarMountingAngles);

kSonarPolarAngle = 75;
kSonarBracketDistanceToChassis = 2 * kSonarHeight;
kSonarBracketPinWidth = 10;

kChassisBayUpperDiameter = 80;
kChassisBayLowerDiameter = 250;
kChassisBayHeight = 15;

kChassisSlitBlindFOV = 15;
kChassisSlitBlindCount = 4;
kChassisSlitMaxFOV = 360 / kChassisSlitBlindCount;
kChassisSlitFOV = kChassisSlitMaxFOV - kChassisSlitBlindFOV;


module mChassisSlitFOV() {
     linear_extrude(height=kChassisSlitWidth, center=true) {
          for (slitCenterAngle = [kChassisSlitMaxFOV/2:
                                  kChassisSlitMaxFOV:
                                  360 - kChassisSlitMaxFOV/2]) {
               startAngle = slitCenterAngle - kChassisSlitFOV/2;
               endAngle = slitCenterAngle + kChassisSlitFOV/2;
               sector(kLidarRange, [startAngle, endAngle]);
          };
     };
};



module mChassisBottomHalf() {
     difference() {
          mChassis();
          translate([0., 0., kChassisHeight * 0.7]) {
               mChassisBB();
          };
     };
};

module mChassisOuterVolume() {
     rounded_cylinder(diameter=kChassisDiameter,
                      height=kChassisHeight,
                      fillet_radius=kChassisFilletRadius);
}

module mChassisInnerVolume() {
     translate([0, 0, kChassisThickness]) {
          rounded_cylinder(diameter=kChassisDiameter - 2 * kChassisThickness,
                           height=kChassisHeight - 2 * kChassisThickness,
                           fillet_radius=kChassisFilletRadius);
     }
}


module mChassisBBox() {
     translate([0., 0., kChassisHeight/2]) {
          cube([kChassisDiameter, kChassisDiameter, kChassisHeight], center=true);
     }
}

kWheelBase = 280;

kBumperAngularDelta = 90;

kWheelAxleZOffset = kWheelDiameter/2 - kBallCasterHeight - kChassisThickness;

kWheelSlotLength = 2 * sqrt(pow(kWheelDiameter/2 + 4, 2)
                            - pow(kWheelAxleZOffset, 2));
kWheelSlotWidth = kWheelWidth + 6;

module mMotorSupport() {
     exp_nerve(10, 10, 3);
     rotate([0, -90, 0])
          linear_extrude(height=kChassisThickness)
          difference() {
          duplicate([0, 1, 0]) {
               translate([0, -kDCMotorDiameter/2, 0]) {
                    rotate([0, 0,  -90])
                         exp_nerve_xsection(kDCMotorDiameter * 0.75, kDCMotorDiameter/2, decay_rate = 6);
                    square([kDCMotorDiameter * 0.75, kDCMotorDiameter/2]);
               }
          }
          translate([kDCMotorDiameter, 0])
               circle(d=kDCMotorDiameter);
     }
}

kBatteryAPosition = [-125, 50, 0];
kBatteryAOrientation = [0, 0, 60];
kBatteryAPose = [kBatteryAPosition, kBatteryAOrientation];

kBatteryBPosition = [-100, -50, 0];
kBatteryBOrientation = [0, 0, -120];
kBatteryBPose = [kBatteryBPosition, kBatteryBOrientation];

kBatterySupportHeight = 30;
kBatterySupportLength = 10;
kBatterySupportWidth = 20;

module mBatteryCornerSupport() {
     exp_corner_nerve(kBatterySupportHeight, kBatterySupportLength, [0, 90], decay_rate=3);
     translate([0, -kBatterySupportWidth/2, 0])
     exp_nerve(kBatterySupportHeight, kBatterySupportLength, kBatterySupportWidth);
     translate([-kBatterySupportWidth/2, 0, 0])
     rotate([0, 0, 90])
     exp_nerve(kBatterySupportHeight, kBatterySupportLength, kBatterySupportWidth);
}

kChassisNerveAngles = [60:20:300];
kChassisNerveHeight = 50;
kChassisNerveLength = 20;

module mChassisBase() {
     difference() {
          mChassisOuterVolume();
          translate([0, 0, kChassisBaseHeight]) {
               mChassisBBox();
          }
          mChassisInnerVolume();
          translate([kChassisDiameter/2 * (1 + cos(kBumperAngularDelta/2)), 0, 0]) {
               mChassisBBox();
          }
          linear_extrude(height=kChassisThickness + kEpsilon) {
               duplicate([0, 1, 0]) {
                    translate([0, kWheelBase/2, 0]) {
                         square([kWheelSlotLength, kWheelSlotWidth], center=true);
                    }
               }
          }
     }
     translate([0, 0, kChassisThickness])
          for(angle = kChassisNerveAngles) {
               rotate([0, 0, angle]) {
                    exp_corner_nerve(height=kChassisNerveHeight,
                                     radius=kChassisNerveLength,
                                     angles=[-180/PI * 2 * kChassisThickness/kChassisDiameter,
                                             180/PI * 2 * kChassisThickness/kChassisDiameter],
                                     corner_radius=-(kChassisDiameter/2 - kChassisThickness));
               }
          }
          for (pose = [kBatteryAPose, kBatteryBPose]) {
               let(position = pose[0], orientation = pose[1]) {
                    translate(position) {
                         rotate(orientation) {
                              duplicate([1, 0, 0]) {
                                   duplicate([0, 1, 0]) {
                                        translate([kBatteryLength/2, kBatteryWidth/2, 0]) {
                                             mBatteryCornerSupport();
                                        }
                                   }
                              }
                         }
                    }
               }
          }
}



//mChassisBase();

module mChassisCover() {
     difference() {
          mChassisHull();
          translate([0, 0, kChassisHeight - kChassisWirewayDepth]) {
               cylinder(r1=(kChassisWirewayRadius + kChassisWirewayWidth/2),
                        r2=(kChassisWirewayRadius + kChassisWirewayWidth/2 +
                            kGrowthFactor * kChassisWirewayDepth * tan(kChassisWirewayAngle)),
                        h=kGrowthFactor * kChassisWirewayDepth);
          }
          for (i = [-(kSonarCount-1)/2:(kSonarCount-1)/2]) {
               rotate([0, 0, i * kHCSR04FOV])
                    translate([kChassisRadius - kGrowthFactor * kHCSR04Width/2 * cos(kSonarPolarAngle),
                               0., kSonarWedgeHeight]) {
                    rotate([0, kSonarPolarAngle, 0]) {
                         mSonarCone();
                    }
               }
          }

     }
     translate([0, 0, kChassisHeight - kChassisWirewayDepth]) {
          cylinder(r1=(kChassisWirewayRadius - kChassisWirewayWidth/2),
                   r2=(kChassisWirewayRadius - kChassisWirewayWidth/2 -
                       kChassisWirewayDepth * tan(kChassisWirewayAngle)),
                   h=kChassisWirewayDepth);
     }
}


kSonarBracketWidth = kSonarWidth + 5;
kSonarBracketLength = kSonarLength + 5;
kSonarBracketHeight = kChassisHeight/2;

module mSonarBracket() {
     render(convexity = 10) {
          rotate([0, -kSonarPolarAngle, 0])
          difference() {
               rotate([0, kSonarPolarAngle, 0]) {
                    linear_extrude(height=2 * kSonarBracketDistanceToChassis,
                                   scale=(4 * kSonarBracketDistanceToChassis * tan(kSonarFOV/2) + kSonarBracketWidth  + 2 * kChassisThickness)/(kSonarBracketWidth + 2 * kChassisThickness)) {
                         difference() {
                              square([kSonarBracketLength, kSonarBracketWidth + 2 * kChassisThickness], center=true);
                              square([kSonarBracketLength + kEpsilon, kSonarBracketWidth], center=true);
                         }
                    }
                    linear_extrude(height=kChassisThickness) {
                         difference() {
                              square([kSonarBracketLength, kSonarBracketWidth + 2 * kChassisThickness], center=true);
                              for (x = [-kSonarHoleToHoleLength/2, kSonarHoleToHoleLength/2]) {
                                   for (y = [-kSonarHoleToHoleWidth/2, kSonarHoleToHoleWidth/2]) {
                                        translate([x, y, 0]) circle(d=kM2ScrewDiameter);
                                   }
                              }
                         }
                    }
               }
               translate([kSonarBracketDistanceToChassis, 0, 0])
               difference() {
                    cube(kChassisHeight, center=true);
                    translate([-kChassisDiameter/2, 0, 0]) {
                         cylinder(d=kChassisDiameter - 2 * kChassisThickness - kEpsilon, h=kChassisHeight + kEpsilon, center=true);
                         translate([0, 0, kSonarBracketDistanceToChassis * sin(90 - kSonarPolarAngle)])
                              cylinder(d=kChassisDiameter + 3 * kEpsilon, h=kSonarBracketPinWidth, center=true);

                    }
               }
          }
     }
}

module mSonarFrustum() {
     rotate([0, kSonarPolarAngle, 0]) {
          translate([0, 0, kChassisThickness]) {
               linear_extrude(height=kSonarRange, scale=(2 * kSonarRange * tan(kSonarFOV/2) + kSonarWidth)/kSonarWidth) {
                    square([kSonarLength, kSonarWidth], center=true);
               }
          }
     }
}


/* difference() { */
/* linear_extrude(height=kChassisHeight) */
/* ring(inner_radius=kChassisDiameter/2 - kChassisThickness, outer_radius=kChassisDiameter/2); */
/* for (angle = kSonarMountingAngles) { */
/*      rotate([0, 0, angle]) mSonarBracket(); */
/* } */
/* } */
/* difference() { */
/*      linear_extrude(height=kChassisHeight) */
/*      ring(inner_radius=kChassisDiameter/2 - kChassisThickness, outer_radius=kChassisDiameter/2); */
/*      for (angle = kSonarMountingAngles) { */
/*           rotate([0, 0, angle]) mSonarBracket(); */
/*      } */
/* } */

module mBumper() {
     render(convexity=10) {
          difference() {
               linear_extrude(height=kChassisHeight - 4 * kChassisFilletRadius, center=true)
                    ring(inner_radius=kChassisDiameter/2 - kChassisThickness, outer_radius=kChassisDiameter/2);
               for (angle = kSonarMountingAngles) {
                    rotate([0, 0, angle]) {
                         translate([kChassisDiameter/2 - kSonarBracketDistanceToChassis, 0, 0])  {
                              mSonarBracket();
                              mSonarFrustum();
                         }
                    }
               }
          }
          for (angle = kSonarMountingAngles) {
               rotate([0, 0, angle]) {
                    translate([kChassisDiameter/2 - kSonarBracketDistanceToChassis, 0, 0]) {
                         mSonarBracket();
                    }
               }
          }
     }
}

//mBumper();
