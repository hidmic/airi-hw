include <specs.scad>;

use <lib.scad>;

$fn = 64;


kChassisDiameter = 440;
kChassisHeight = 110;
kChassisThickness = 2;
kChassisFilletRadius = 5;

kChassisBaseHeight = 100;

kChassisWirewayRadius = 120;
kChassisWirewayDepth = 10;
kChassisWirewayWidth = 10;
kChassisWirewayAngle = 20;


kSonarMountingAngles = [-45, 0, 45];
kSonarCount = len(kSonarMountingAngles);

kSonarPolarAngle = 75;
kSonarBracketDistanceToChassis = 2 * kSonarHeight;
kSonarBracketPinWidth = 10;

kCliffSensorMountingAngles = [-30, 30];


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


kWheelBase = 305;

kBumperAngularDelta = 135;
kBumperTravelDistance = 5;

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

kChassisNerveAngles = [80:20:280];
kChassisNerveHeight = 50;
kChassisNerveLength = 20;

module mChassisBase() {
     difference() {
          mChassisOuterVolume();
          translate([0, 0, kChassisBaseHeight]) {
               mChassisBBox();
          }
          mChassisInnerVolume();
          for (x=[0:kBumperTravelDistance]) {
               translate([-x, 0, 0]) mBumperHull();
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
     translate([0, 0, kChassisThickness]) {
          linear_extrude(height=kSonarRange, scale=(2 * kSonarRange * tan(kSonarFOV/2) + kSonarWidth)/kSonarWidth) {
               square([kSonarLength, kSonarWidth], center=true);
          }
     }
}


kBumperHeight = kChassisBaseHeight - kChassisFilletRadius;

kChassisSupportDiameter = 8;
kChassisSupportAngles = [-62.5, -22.5, 22.5, 62.5];


module mBumperImpl() {
     translate([0, 0, kChassisHeight/2]) {
          difference() {
               translate([0, 0, kChassisFilletRadius + kBumperHeight/2 - kChassisHeight/2]) {
                    difference() {
                         union() {
                              translate([0, 0, -kChassisFilletRadius - kBumperHeight/2]) {
                                   difference() {
                                        mChassisOuterVolume();
                                        mChassisInnerVolume();
                                   }
                              }
                              duplicate([0, 0, 1]) duplicate([0, 1, 0])
                                   translate([kChassisDiameter/2 * cos(kBumperAngularDelta/2),
                                              -kChassisDiameter/2 * sin(kBumperAngularDelta/2),
                                              -kBumperHeight/2]) {
                                   mBumperSpringBlock();
                              }
                         }
                         translate([0, 0, -kChassisHeight - kBumperHeight/2]) {
                              mChassisBBox();
                         }
                         translate([0, 0, kBumperHeight/2]) {
                              mChassisBBox();
                         }
                         translate([0, 0, -kChassisFilletRadius - kBumperHeight/2]) {
                              difference() {
                                   mChassisOuterVolume();
                                   translate([kChassisDiameter/2 * cos(kBumperAngularDelta/2),
                                              -(kChassisDiameter/2 - kChassisThickness) * sin(kBumperAngularDelta/2),
                                              0]) {
                                        cube([kChassisDiameter/2 * (1 - cos(kBumperAngularDelta/2)),
                                              (kChassisDiameter - 2 * kChassisThickness) * sin(kBumperAngularDelta/2),
                                              kChassisHeight]);
                                   }
                              }
                         }
                    }
               }
               for (angle = kSonarMountingAngles) {
                    rotate([0, 0, angle]) {
                         translate([kChassisDiameter/2 - kSonarBracketDistanceToChassis, 0, 0])  {
                              rotate([0, kSonarPolarAngle, 0]) {
                                   mSonarBracket();
                                   mSonarFrustum();
                              }
                         }
                    }
               }
          }
     }
}
//mChassisBase();

kBumperSpringBlockHeight = 17.5;
kBumperSpringBlockWidth = 17.5;
kBumperSpringBlockDepth = 30;
kBumperSpringBlockSlotDepth = 5;
kBumperSpringOuterDiameter = 8;

module mBumperSpringBlock() {
     difference() {
          linear_extrude(height=kBumperSpringBlockHeight) {
               difference() {
                    union(){
                         translate([kChassisThickness, 0]) {
                              outline(delta=kChassisThickness) {
                                   square([kBumperSpringBlockDepth, kBumperSpringBlockWidth]);
                              }
                         }
                         translate([kBumperSpringBlockSlotDepth + kChassisThickness, 0]) {
                              square([kBumperSpringBlockDepth, kBumperSpringBlockWidth]);
                         }
                    }
                    translate([-kChassisDiameter/2 * cos(kBumperAngularDelta/2),
                               kChassisDiameter/2 * sin(kBumperAngularDelta/2)]) {
                         ring(inner_radius=kChassisDiameter/2 - kEpsilon, outer_radius=kChassisDiameter);
                    }
               }
          }
          translate([0, kBumperSpringBlockWidth/2 + kChassisThickness, kBumperSpringBlockHeight/2]) {
               rotate([0, 90, 0]) {
                    cylinder(d=kBumperSpringOuterDiameter,
                             h=4 * kChassisThickness,
                             center=true);
               }
               translate([0, 0, kBumperSpringBlockHeight/4]) {
                    cube([4 * kChassisThickness,
                          kBumperSpringOuterDiameter,
                          kBumperSpringBlockHeight/2 + kEpsilon], center=true);
               }
          }
     }

}

kBumperPinHeight = 4;
kBumperPinDiameter = 4;

module mBumperBottomHalf() {
     difference() {
          translate([0, 0, -kChassisFilletRadius]) mBumperImpl();
          translate([0, 0, kBumperHeight/2]) mChassisBBox();
     }
     translate([0, 0, kEpsilon]) {
          linear_extrude(height=kBumperHeight/2 - kEpsilon) {
               for(angle = kChassisSupportAngles) {
                    rotate(angle) {
                         translate([(kChassisDiameter - kChassisThickness)/2 + kEpsilon, 0, 0]) {
                              curved_support_xsection(
                                   support_radius=kChassisSupportDiameter/2,
                                   fillet_radius=kChassisFilletRadius,
                                   wall_outer_radius=kChassisDiameter/2,
                                   wall_inner_radius=kChassisDiameter/2 - kChassisThickness);
                         }
                    }
               }
          }
     }
     for(angle = kChassisSupportAngles) {
          rotate(angle) {
               translate([(kChassisDiameter - kChassisThickness)/2 - kChassisSupportDiameter/2 + kEpsilon,
                          0, kBumperHeight/2]) {
                    cylinder(d=kBumperPinDiameter, h=kBumperPinHeight);
               }
          }
     }
}

module mBumperUpperHalf() {
     difference() {
          translate([0, 0, -kChassisFilletRadius]) mBumperImpl();
          translate([0, 0, -kChassisHeight + kBumperHeight/2]) mChassisBBox();
     }
     translate([0, 0, kBumperHeight/2]) {
          linear_extrude(height=kBumperHeight/2 - kEpsilon) {
               for(angle = kChassisSupportAngles) {
                    rotate(angle) {
                         translate([(kChassisDiameter - kChassisThickness)/2 + kEpsilon, 0]) {
                              difference() {
                                   curved_support_xsection(
                                        support_radius=kChassisSupportDiameter/2,
                                        fillet_radius=kChassisFilletRadius,
                                        wall_outer_radius=kChassisDiameter/2,
                                        wall_inner_radius=kChassisDiameter/2 - kChassisThickness);
                                   translate([-kChassisSupportDiameter/2, 0]) {
                                        circle(d=kBumperPinDiameter);
                                   }
                              }
                         }
                    }
               }
          }
     }
}

module mBumperHull() {
     translate([0, 0, kChassisFilletRadius])
     linear_extrude(height=kBumperHeight + kEpsilon) {
          offset(delta=3 * kEpsilon) {
               projection() mBumperImpl();
          }
     }
}

module mBumper() {
     mBumperImpl();
     translate([0, 0, kChassisFilletRadius + kEpsilon]) {
          linear_extrude(height=kBumperHeight - 2 * kEpsilon) {
               for(angle = kChassisSupportAngles) {
                    rotate(angle) {
                         translate([(kChassisDiameter - kChassisThickness)/2 + kEpsilon, 0, 0]) {
                              curved_support_xsection(
                                   support_radius=kChassisSupportDiameter/2,
                                   fillet_radius=kChassisFilletRadius,
                                   wall_outer_radius=kChassisDiameter/2,
                                   wall_inner_radius=kChassisDiameter/2 - kChassisThickness);
                         }
                    }
               }
          }
     }
     for (angle = kSonarMountingAngles) {
          rotate([0, 0, angle]) {
               translate([kChassisDiameter/2 - kSonarBracketDistanceToChassis, 0,
                          kChassisFilletRadius + kBumperHeight/2]) {
                    rotate([0, kSonarPolarAngle, 0]) {
                         mSonarBracket();
                    }
               }
          }
     }
}


mChassisBase();
mBumper();


include <links.scad>;

duplicate([0, 1, 0]) {
     translate([120, kWheelBase/2 - kWheelBlockCenterToPulleyDistance, 0]) {
          translate([0, -kBeltDriveToPulleyDistance, 0]) mBeltDrive();
          translate([-120, kWheelBlockCenterToPulleyDistance, 0]) mWheelBlock();
     }
}


/* for (angle = [-30, 30]) { */
/*      rotate([0, 0, angle]) */
/*           translate([kChassisDiameter/2 - kChassisThickness - kBumperRadialWidth/2, 0, kChassisThickness]) { */
/*           cube([kCliffSensorLength, kCliffSensorWidth, 2 * kChassisThickness], center=true); */
/*      } */
/* } */

//mBumperHull();



kChassisBayWidth = 15;
kChassisBayHeight = kLidarWorkingWidth + 2;
kChassisBayOuterRadius = kChassisDiameter/2;
kChassisBayInnerRadius = kChassisBayOuterRadius - kChassisBayWidth;

kChassisBayLightningSourceAngles = [22.5:45:337.5];
kChassisBayFasteningAngles = [-135, -45, 45, 135];

module mChassisBayXSection() {
     difference() {
          ring(inner_radius=kChassisBayInnerRadius, outer_radius=kChassisBayOuterRadius);
          for (angle = kChassisBayLightningSourceAngles) {
               rotate(angle) {
                    translate([kChassisBayOuterRadius - kChassisBayWidth/2, 0]) {
                         circle(d=kLedDiameter);
                    }
               }
          }
          for (angle = kChassisBayFasteningAngles) {
               rotate(angle) {
                    translate([kChassisBayOuterRadius - kChassisBayWidth/2, 0]) {
                         circle(d=kM3ScrewDiameter);
                    }
               }
          }
     }
}

module mChassisBay() {
     color("white", 0.3)
     linear_extrude(height=kChassisBayHeight) {
          mChassisBayXSection();
     }
}

//mChassisBay();
