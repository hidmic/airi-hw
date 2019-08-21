include <specs.scad>;

use <lib.scad>;

$fn = 64;


kChassisDiameter = 450;
kChassisHeight = 120;
kChassisThickness = 2;
kChassisFilletRadius = 5;

kChassisBaseHeight = 100;



kSonarMountingAngles = [-45, 0, 45];
kSonarCount = len(kSonarMountingAngles);

kSonarPolarAngle = 75;
kSonarBracketDistanceToChassis = 2 * kSonarHeight;
kSonarBracketPinWidth = 10;

kCliffSensorMountingAngles = [-30, 30];

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


module mChassisOuterVolumeConstrain() {
     difference() {
          rounded_cylinder(diameter=kChassisDiameter,
                           height=kChassisHeight,
                           fillet_radius=kChassisFilletRadius);
          difference() {
               translate([0, 0, -kEpsilon]) {
                    rounded_cylinder(diameter=kChassisDiameter + kEpsilon,
                                     height=kChassisHeight + 2 * kEpsilon,
                                     fillet_radius=kChassisFilletRadius);
               }
               children();
          }
     }
}


module mChassisBBox() {
     translate([0., 0., kChassisHeight/2]) {
          cube([kChassisDiameter, kChassisDiameter, kChassisHeight], center=true);
     }
}


kWheelBase = 305;

kCasterXOffset = -(kChassisDiameter/2 - kBallCasterDiameter);

kWheelAxleZOffset = kWheelDiameter/2 - kBallCasterHeight - kChassisThickness;

kWheelAxleMinZOffset = kWheelAxleZOffset - 10;

kWheelSlotLength = 2 * sqrt(pow(kWheelDiameter/2 + 8, 2) - pow(kWheelAxleZOffset, 2));
kWheelSlotWidth = kWheelWidth + 8;


kBatteryAPosition = [-120, 50, 0];
kBatteryAOrientation = [0, 0, 60];
kBatteryAPose = [kBatteryAPosition, kBatteryAOrientation];

kBatteryBPosition = [-95, -50, 0];
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
          translate([0, -(kChassisDiameter/2 - kChassisThickness) * sin(kBumperAngularDelta/2), kChassisFilletRadius]) {
               cube([kChassisDiameter/2, (kChassisDiameter - 2 * kChassisThickness) * sin(kBumperAngularDelta/2),
                     kBumperHeight + kEpsilon]);
          }
          linear_extrude(height=kChassisThickness + kEpsilon) {
               duplicate([0, 1, 0]) {
                    translate([0, kWheelBase/2, 0]) {
                         square([kWheelSlotLength, kWheelSlotWidth], center=true);
                    }
                    translate([kCasterXOffset, kBallCasterCenterToHole, 0]) {
                         circle(d=kM4ScrewDiameter);
                    }
               }

          }
     }
     mChassisOuterVolumeConstrain() {
          duplicate([0, 1, 0]) {
               translate([(kChassisDiameter/2 - kChassisThickness) * cos(kBumperAngularDelta/2),
                          (kChassisDiameter/2 - kChassisThickness) * sin(kBumperAngularDelta/2) - kChassisThickness/2,
                          kChassisThickness]) {
                    cube([kChassisThickness + kBumperSpringSlotWidth, kChassisThickness/2, kChassisBaseHeight - kChassisThickness]);
               }
          }
     }
}

/* for (angle = [-30, 30]) { */
/*      rotate([0, 0, angle]) */
/*           translate([kChassisDiameter/2 - kChassisThickness - kBumperRadialWidth/2, 0, kChassisThickness]) { */
/*           cube([kCliffSensorLength, kCliffSensorWidth, 2 * kChassisThickness], center=true); */
/*      } */
/* } */


module mChassis() {
     mChassisBase();
     translate([0, 0, kChassisThickness]) {
          for(angle = kChassisNerveAngles) {
               rotate([0, 0, angle]) {
                    exp_corner_nerve(height=kChassisNerveHeight,
                                     radius=kChassisNerveLength,
                                     angles=[-180/PI * 2 * kChassisThickness/kChassisDiameter,
                                             180/PI * 2 * kChassisThickness/kChassisDiameter],
                                     corner_radius=-(kChassisDiameter/2 - kChassisThickness));
               }
          }
     }
     mChassisOuterVolumeConstrain() {
          translate([0, 0, kChassisThickness]) {
               linear_extrude(height=kChassisBaseHeight - kChassisThickness) {
                    for(angle = kChassisCoverFasteningAngles) {
                         rotate(angle) {
                              translate([kChassisDiameter/2 - kChassisThickness/2 + kEpsilon, 0]) {
                                   curved_support_xsection(
                                        support_radius=kChassisSupportDiameter/2,
                                        fillet_radius=kChassisFilletRadius,
                                        hole_radius=kM3ScrewDiameter/2,
                                        wall_outer_radius=kChassisDiameter/2,
                                        wall_inner_radius=kChassisDiameter/2 - kChassisThickness);
                              }
                         }
                    }
               }
          }
          duplicate([0, 1, 0]) {
               translate([kChassisDiameter/2 * cos(kBumperAngularDelta/2),
                          -kChassisDiameter/2 * sin(kBumperAngularDelta/2),
                          0]) {
                    mBumperSpringBlockBSide();
               }
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

kBumperAngularDelta = 130;
kBumperTravelDistance = 5;
kBumperHeight = kChassisBaseHeight - kChassisFilletRadius;

kChassisSupportDiameter = 10;

kBumperSupportAngles = [-kBumperAngularDelta/2+5, -22.5, 22.5, kBumperAngularDelta/2-5];

module mBumperBase() {
     difference() {
          translate([0, 0, kChassisHeight/2]) {
               difference() {
                    translate([0, 0, kChassisFilletRadius + kBumperHeight/2 - kChassisHeight/2]) {
                         difference() {
                              translate([0, 0, -kChassisFilletRadius - kBumperHeight/2]) {
                                   difference() {
                                        mChassisOuterVolume();
                                        mChassisInnerVolume();
                                   }
                              }
                              translate([-kChassisDiameter/2 * (1 - cos(kBumperAngularDelta/2)) - 2 * kChassisThickness,
                                         0, -kChassisHeight/2]) {
                                   mChassisBBox();
                              }
                              translate([0, 0, -kChassisHeight - kBumperHeight/2]) mChassisBBox();
                              translate([0, 0, kBumperHeight/2]) mChassisBBox();
                         }
                         duplicate([0, 1, 0]) {
                              duplicate([0, 0, 1]) {
                                   translate([kChassisDiameter/2 * cos(kBumperAngularDelta/2),
                                              -kChassisDiameter/2 * sin(kBumperAngularDelta/2),
                                              -kBumperHeight/2]) {
                                        mBumperSpringBlockASide();
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
          linear_extrude(height=kChassisBaseHeight + kEpsilon) {
               for (x = [0:kBumperTravelDistance]) {
                    translate([x, 0, 0]) {
                         offset(delta=2 * kEpsilon)
                         projection(cut=true) {
                              translate([0, 0, -kChassisBaseHeight/2]) mChassisBase();
                         }
                    }
               }
          }
     }
}

kBumperSpringBlockHeight = 20;
kBumperSpringBlockWidth = 20;
kBumperSpringBlockDepth = 35;


kBumperSpringInnerDiameter = 8;
kBumperSpringOuterDiameter = 12;
kBumperSpringLockSize = 2 * kChassisThickness;

kBumperSpringSlotWidth = 5;
kBumperSpringSeatThickness = 3 * kChassisThickness;
kBumperSpringLength = kBumperTravelDistance + kBumperSpringSlotWidth + 2 * kBumperSpringSeatThickness;

module mBumperSpringBlockXSection() {
     difference() {
          translate([-kBumperSpringLockSize, kBumperSpringBlockWidth - kChassisDiameter/2]) {
               outline(delta=-kChassisThickness) {
                    square([kBumperSpringBlockDepth, kChassisDiameter/2]);
               }
               square([kBumperSpringSeatThickness, kChassisDiameter/2]);
               translate([kBumperSpringSlotWidth + kBumperSpringSeatThickness, 0]) {
                    square([kBumperSpringBlockDepth - kBumperSpringSlotWidth - kBumperSpringSeatThickness, kChassisDiameter/2]);
               }
               translate([-(kBumperSpringLength - kBumperSpringSlotWidth - 2 * kBumperSpringSeatThickness ), 0]) {
                    translate([-kBumperSpringSeatThickness, 0]) {
                         square([kBumperSpringSeatThickness, kChassisDiameter/2]);
                    }
               }
          }
          translate([-kChassisDiameter/2 * cos(kBumperAngularDelta/2), kChassisDiameter/2 * sin(kBumperAngularDelta/2)]) {
               ring(inner_radius=kChassisDiameter/2 - kEpsilon, outer_radius=kChassisDiameter);
          }
     }
}

module mBumperSpringBlockASideXSection() {
     translate([-kBumperSpringLockSize, -kBumperSpringLockSize]) {
          intersection() {
               translate([kBumperSpringLockSize, kBumperSpringLockSize]) mBumperSpringBlockXSection();
               square([kBumperSpringBlockDepth, kChassisDiameter/2]);
          }
     }
}

module mBumperSpringBlockBSideXSection() {
     translate([-kBumperSpringLockSize, -kBumperSpringLockSize]) {
          difference() {
               translate([kBumperSpringLockSize, kBumperSpringLockSize]) mBumperSpringBlockXSection();
               square([kBumperSpringBlockDepth, kChassisDiameter/2]);
          }
     }
}

module mBumperSpringSeatComplement() {
     translate([kBumperSpringSeatThickness - kBumperSpringLockSize, kBumperSpringBlockWidth/2, kBumperSpringBlockHeight/2]) {
          rotate([0, 90, 0]) {
               translate([0, 0, -(kBumperSpringLength - kBumperSpringSlotWidth) - kEpsilon]) {
                    cylinder(d=kBumperSpringInnerDiameter, h=kBumperSpringLength - kBumperSpringSlotWidth + 2 * kEpsilon);
                    translate([-(kChassisBaseHeight - kBumperSpringBlockHeight/2) - kEpsilon, -kBumperSpringInnerDiameter/2, 0]) {
                         cube([kChassisBaseHeight - kBumperSpringBlockHeight/2 + kEpsilon, kBumperSpringInnerDiameter,
                               kBumperSpringLength - kBumperSpringSlotWidth + 2 * kEpsilon]);
                    }
                    translate([0, 0, kBumperSpringSeatThickness - kBumperSpringLockSize - kEpsilon]) {
                         cylinder(d=kBumperSpringOuterDiameter, h=kBumperSpringLength - kBumperSpringSlotWidth - 2 * (kBumperSpringSeatThickness - kBumperSpringLockSize) + 2 * kEpsilon);
                         translate([-(kChassisBaseHeight - kBumperSpringBlockHeight/2) - kEpsilon, -kBumperSpringOuterDiameter/2, 0]) {
                              cube([kChassisBaseHeight - kBumperSpringBlockHeight/2 + kEpsilon, kBumperSpringOuterDiameter,
                                    kBumperSpringLength - kBumperSpringSlotWidth - 2 * (kBumperSpringSeatThickness - kBumperSpringLockSize)]);
                         }
                    }
               }
          }
     }

}

module mBumperSpringBlockASide() {
     difference() {
          linear_extrude(height=kBumperSpringBlockHeight) {
               mBumperSpringBlockASideXSection();
          }
          mBumperSpringSeatComplement();
     }
     linear_extrude(height=kBumperHeight/2) {
          difference() {
               translate([-kBumperSpringLockSize, 0]) {
                    square([kBumperSpringSeatThickness + kBumperSpringSlotWidth, kBumperSpringBlockWidth/2 - kBumperSpringOuterDiameter/2]);
               }
               translate([-kChassisDiameter/2 * cos(kBumperAngularDelta/2), kChassisDiameter/2 * sin(kBumperAngularDelta/2)]) {
                    ring(inner_radius=kChassisDiameter/2 - kEpsilon, outer_radius=kChassisDiameter);
               }
          }
     }
}

module mBumperSpringBlockBSide() {
     difference() {
          linear_extrude(height=kChassisBaseHeight) {
               mBumperSpringBlockBSideXSection();
          }
          mBumperSpringSeatComplement();
     }
}



kBumperPinHeight = 4;
kBumperPinDiameter = 4;

module mBumperBottomHalf() {
     difference() {
          translate([0, 0, -kChassisFilletRadius]) mBumperBase();
          translate([0, 0, kBumperHeight/2]) mChassisBBox();
     }
     translate([0, 0, kEpsilon]) {
          linear_extrude(height=kBumperHeight/2 - kEpsilon) {
               for(angle = kBumperSupportAngles) {
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
     for(angle = kBumperSupportAngles) {
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
          translate([0, 0, -kChassisFilletRadius]) mBumperBase();
          translate([0, 0, -kChassisHeight + kBumperHeight/2]) mChassisBBox();
     }
     translate([0, 0, kBumperHeight/2]) {
          linear_extrude(height=kBumperHeight/2 - kEpsilon) {
               for(angle = kBumperSupportAngles) {
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

module mBumper() {
     mBumperBase();
     translate([0, 0, kChassisFilletRadius + kEpsilon]) {
          linear_extrude(height=kBumperHeight - 2 * kEpsilon) {
               for(angle = kBumperSupportAngles) {
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




kChassisBayWidth = 20;
kChassisBayHeight = kLidarWorkingWidth + 2;
kChassisBayOuterRadius = kChassisDiameter/2;
kChassisBayInnerRadius = kChassisBayOuterRadius - kChassisBayWidth;

kChassisBayLightningSourceAngles = [30:60:360-30];
kChassisBayLightningRadius = kChassisBayOuterRadius - kChassisBayWidth/2;

kChassisCoverFasteningAngles = [-135, -105, -75, 75, 105, 135];
kChassisCoverFasteningRadius = kChassisDiameter/2 - kChassisSupportDiameter/2 - kChassisThickness;

kChassisBayFasteningAngles = [-45, 45, 180];
kChassisBayFasteningRadius = kChassisBayInnerRadius + (kChassisBayOuterRadius - kChassisCoverFasteningRadius);

module mChassisBayXSection() {
     difference() {
          ring(inner_radius=kChassisBayInnerRadius, outer_radius=kChassisBayOuterRadius);
          for (angle = kChassisBayLightningSourceAngles) {
               rotate(angle) {
                    translate([kChassisBayLightningRadius, 0]) {
                         circle(d=kLedDiameter);
                    }
               }
          }
          for (angle = kChassisBayFasteningAngles) {
               rotate(angle) {
                    translate([kChassisBayFasteningRadius, 0]) {
                         circle(d=kM3ScrewDiameter);
                    }
               }
          }
          for (angle = kChassisCoverFasteningAngles) {
               rotate(angle) {
                    translate([kChassisCoverFasteningRadius, 0]) {
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

kChassisCoverHeight = kChassisHeight - kChassisBaseHeight - kChassisBayHeight;
kChassisCoverPanelDepth = kChassisCoverHeight - kChassisThickness;


kChassisCoverPanelLength = 30;
kChassisCoverPanelWidth = 100;
kChassisCoverPanelAngle = -30;

kChassisWirewayDepth = kChassisCoverHeight - kChassisThickness;
kChassisInnerWirewayRadius = 50;
kChassisOuterWirewayRadius = 190;
kChassisWirewaysConduitAngles = [-90, 0, 90, 180];
kChassisWirewayConduitWidth = 25;
kChassisWirewayWidth = 15;
kChassisWirewayAngle = 30;

kChassisPoleSocketDiameter = 50;
kChassisPoleSocketDepth = kChassisCoverHeight - kChassisThickness;

kChassisPolePlugOuterDiameter = 60;
kChassisPolePlugInnerDiameter = kChassisPoleSocketDiameter - 2 * kEpsilon;
kChassisPolePlugChamferAngle = 45;
kChassisPoleFasteningAngles = [0, 90, 180, 270];
kChassisPoleFasteningRadius = 15;

kChassisSMAConnectorFasteningAngles = [-135, 135];

module mChassisCoverBase() {
     difference() {
          translate([0, 0, kChassisCoverHeight - kChassisWirewayDepth]) {
               difference() {
                    union() {
                         difference() {
                              union() {
                                   difference() {
                                        translate([0, 0, kChassisWirewayDepth - kChassisHeight]) {
                                             difference() {
                                                  mChassisOuterVolume();
                                                  translate([0, 0, -kChassisCoverHeight]) mChassisBBox();
                                             }
                                        }
                                        cylinder(r1=(kChassisOuterWirewayRadius + kChassisWirewayWidth/2),
                                                 r2=(kChassisOuterWirewayRadius + kChassisWirewayWidth/2 +
                                                     (kChassisWirewayDepth + kEpsilon) * tan(kChassisWirewayAngle)),
                                                 h=kChassisWirewayDepth + kEpsilon);
                                   }
                                   cylinder(r1=(kChassisOuterWirewayRadius - kChassisWirewayWidth/2),
                                            r2=(kChassisOuterWirewayRadius - kChassisWirewayWidth/2 -
                                                (kChassisWirewayDepth + kEpsilon) * tan(kChassisWirewayAngle)),
                                            h=kChassisWirewayDepth);
                              }
                              cylinder(r1=(kChassisInnerWirewayRadius + kChassisWirewayWidth/2),
                                       r2=(kChassisInnerWirewayRadius + kChassisWirewayWidth/2 +
                                           (kChassisWirewayDepth + kEpsilon) * tan(kChassisWirewayAngle)),
                                       h=kChassisWirewayDepth + kEpsilon);
                         }
                         cylinder(r1=(kChassisInnerWirewayRadius - kChassisWirewayWidth/2),
                                  r2=(kChassisInnerWirewayRadius - kChassisWirewayWidth/2 -
                                      (kChassisWirewayDepth + kEpsilon) * tan(kChassisWirewayAngle)),
                                  h=kChassisWirewayDepth);
                    }
                    for(angle = kChassisWirewaysConduitAngles) {
                         rotate([0, 0, angle]) {
                              rotate([0, 0, -90])
                                   translate([-kChassisWirewayConduitWidth/2, kChassisInnerWirewayRadius, 0]) {
                                   cube([kChassisWirewayConduitWidth,
                                         kChassisOuterWirewayRadius-kChassisInnerWirewayRadius,
                                         kChassisWirewayDepth + kEpsilon]);
                              }
                         }
                    }
               }
          }
          translate([0, 0, kChassisCoverHeight - kChassisPoleSocketDepth]) {
               cylinder(r1=kChassisPolePlugInnerDiameter/2 - kChassisPoleSocketDepth * tan(kChassisPolePlugChamferAngle),
                        r2=kChassisPolePlugInnerDiameter/2, h=kChassisPoleSocketDepth + kEpsilon);
          }
          cylinder(d=kM3ScrewDiameter, h=2 * kChassisThickness + kEpsilon, center=true);
          rotate([0, 0, kChassisCoverPanelAngle])
          translate([0, -(kChassisInnerWirewayRadius + kChassisOuterWirewayRadius)/2, 0]) {
               translate([0, 0, kChassisCoverHeight - kChassisCoverPanelDepth]) {
                    linear_extrude(height=kChassisCoverPanelDepth + kEpsilon, scale=1.05) {
                         fillet(kChassisFilletRadius) square([kChassisCoverPanelLength, kChassisCoverPanelWidth], center=true);
                    }

               }
               translate([0, 0, -kEpsilon]) {
                    cylinder(d=kPushButtonCutoutDiameter, h=kChassisThickness + 2 * kEpsilon);
               }
               duplicate([0, 1, 0]) {
                    translate([0, (kChassisCoverPanelWidth + kPushButtonCutoutDiameter)/4, 0]) {
                         cube([kUSBPanelConnectorCutoutLength, kUSBPanelConnectorCutoutWidth, 2 * kChassisThickness + kEpsilon], center=true);
                    }
               }
          }
          linear_extrude(height=2 * (kChassisThickness + kEpsilon), center=true) {
               for(angle = kChassisSMAConnectorFasteningAngles) {
                    rotate([0, 0, angle]) {
                         translate([kChassisInnerWirewayRadius, 0, 0]) mSMAConnectorCutuotSection();
                    }
               }
          }
          for (angle = kChassisBayFasteningAngles) {
               rotate([0, 0, angle]) {
                    translate([kChassisBayFasteningRadius, 0, 0]) {
                         cylinder(d=kM3ScrewDiameter, h=2 * (kChassisCoverHeight + kEpsilon), center=true);
                         translate([0, 0, kChassisThickness]) {
                              cylinder(d=kM3ScrewHeadDiameter, h=kChassisCoverHeight - kChassisThickness + kEpsilon);
                         }
                    }
               }
          }
          for (angle = kChassisCoverFasteningAngles) {
               rotate([0, 0, angle]) {
                    translate([kChassisCoverFasteningRadius, 0, 0]) {
                         cylinder(d=kM3ScrewDiameter, h=2 * (kChassisCoverHeight + kEpsilon), center=true);
                         translate([0, 0, kChassisThickness]) {
                              cylinder(d=kM3ScrewHeadDiameter, h=kChassisCoverHeight - kChassisThickness + kEpsilon);
                         }
                    }
               }
          }
     }
}

module mChassisCover() {
     translate([0, 0, kChassisHeight - kChassisCoverHeight]) {
          color("gray")
          mChassisCoverBase();
          rotate([0, 0, kChassisCoverPanelAngle]) {
               translate([0, -(kChassisInnerWirewayRadius + kChassisOuterWirewayRadius)/2, kChassisCoverHeight - kChassisCoverPanelDepth]) {
                    duplicate([0, 1, 0]) {
                         translate([0, (kChassisCoverPanelWidth + kPushButtonCutoutDiameter)/4, 0]) {
                              mUSBPanelConnector();
                         }
                    }
                    m16mmPushbutton();
               }
          }
          for(angle = kChassisSMAConnectorFasteningAngles) {
               rotate([0, 0, angle]) {
                    translate([kChassisInnerWirewayRadius, 0, kChassisThickness]) mSMAConnector();
               }
          }
     }
}

kChassisPoleBlockGap = 1;


kChassisPoleBaseHeight = kM8NutHeight + kChassisThickness;

module mChassisPoleBase() {
     linear_extrude(height=kChassisThickness) {
          difference() {
               circle(d=kChassisPolePlugOuterDiameter);
               circle(d=kM8NutInscribedDiameter);
          }
     }
     translate([0, 0, kChassisThickness]) {
          difference() {
               linear_extrude(height=kM8NutHeight) {
                    difference() {
                         circle(d=kChassisPolePlugOuterDiameter);
                         mM8NutXSection();
                         for(angle = kChassisPoleFasteningAngles) {
                              rotate([0, 0, angle])
                              translate([kChassisPoleFasteningRadius, 0])
                              circle(d=kM3ScrewHeadDiameter);
                         }
                    }
               }
          }
     }
}

kChassisPolePlugHeight = (kChassisPoleSocketDepth + 2 * kChassisThickness -
                          kM3WasherThickness - kM3ScrewHeadHeight -
                          kChassisPoleBlockGap);


module mChassisPolePlug() {
     difference() {
          union() {
               translate([0, 0, 2 * kChassisThickness]) {
                    cylinder(r1=kChassisPolePlugInnerDiameter/2, h=kChassisPolePlugHeight - 2 * kChassisThickness,
                             r2=kChassisPolePlugInnerDiameter/2 - (kChassisPolePlugHeight - 2 * kChassisThickness) * tan(kChassisPolePlugChamferAngle));
               }
               cylinder(d=kChassisPolePlugOuterDiameter, h=2 * kChassisThickness);
          }
          translate([0, 0, kChassisPolePlugHeight - kMagneticM3WasherThickness - kM3ScrewHeadHeight]) {
               cylinder(d=kMagneticM3WasherOuterDiameter + kEpsilon, h=kMagneticM3WasherThickness + kM3ScrewHeadHeight + kEpsilon);
          }
          translate([0, 0, -kEpsilon]) {
               cylinder(d=kM3x4_8ThreadedInsertDiameter, h=kChassisPolePlugHeight + kEpsilon);
          }
          for(angle = kChassisPoleFasteningAngles) {
               rotate([0, 0, angle])
               translate([kChassisPoleFasteningRadius, 0, -kEpsilon])
               cylinder(d=kM3x4_8ThreadedInsertDiameter, h=kChassisPolePlugHeight + 2 * kEpsilon);
          }
     }
}

module mChassisPoleBlock() {
     translate([0, 0, kChassisPoleBaseHeight + kChassisPolePlugHeight])
     rotate([180, 0, 0]) {
          mChassisPoleBase();
          translate([0, 0, kM8NutHeight/2 + kChassisThickness]) mM8Nut();
          for(angle = kChassisPoleFasteningAngles) {
               rotate([0, 0, angle])
                    translate([kChassisPoleFasteningRadius, 0, kChassisPoleBaseHeight])
                    mM3x4_8ThreadedInsert();
          }
          translate([0, 0, kChassisPoleBaseHeight]) mChassisPolePlug();
          translate([0, 0, kChassisPoleBaseHeight + kChassisPolePlugHeight - kM3ScrewHeadHeight - kMagneticM3WasherThickness]) mMagneticM3Washer();
          translate([0, 0, kChassisPoleBaseHeight]) {
               rotate([0, 90, 0]) mM8x50ThreadedStud();
          }
     }
}

//mChassisPoleBlock();

//mBumper();
//mChassis();
//translate([0, 0, kChassisBaseHeight]) mChassisBay();
//translate([0, 0, 150]) {
//color("white", 0.2)
//mChassisCover();

//}

/* translate([kCasterXOffset, 0, 0]) { */
/*      mBallCaster(); */
/* } */
include <links.scad>;

duplicate([0, 1, 0]) {
     translate([120, kWheelBase/2 - kWheelBlockCenterToPulleyDistance, 0]) {
          translate([0, -kBeltDriveToPulleyDistance, 0]) mBeltDrive();
          translate([-120, kWheelBlockCenterToPulleyDistance, 0]) mWheelBlock();
     }
}
