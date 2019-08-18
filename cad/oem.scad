kEpsilon = 1e-1;

kLidarWorkingWidth = 6;
kLidarRange = 6000;

module mLidar() {
     translate([-35.14, 35, 0])
     rotate([90, 0, 0])
     import("oem/RPLIDAR-A1M8-R1.stl");
}

kSonarFOV = 30;
kSonarRange = 4000;
kSonarWidth = 43;
kSonarHoleToHoleWidth = 40;
kSonarLength = 20;
kSonarHoleToHoleLength = 17;
kSonarHeight = 15;


module mSonar() {
     rotate([0, 0, 90])
     import("oem/HC-SR04.stl");
}


kGY521Width = 15.24;
kGY521Length = 25.4;
kGY521Thickness = 1.6;

module mIMU() {
     translate([-kGY521Length/2, -kGY521Width/2, 0])
     import("oem/GY521.stl");
}

kComputerLength = 100;
kComputerWidth = 81.021973;
kComputerHeight = 30.506195;

module mComputer() {
     translate([0, 0, kComputerHeight/2 - 2.2])
     rotate([90, 0, 0])
     translate([-2.51098442, -41.02810287, 13.])
     import("oem/Jetson-Nano-DK.stl");
}

kControllerWidth = 66;
kControllerLength = 97;
kControllerThickness = 1.6;

module mController() {
     translate([-kControllerWidth/2, -kControllerLength/2])
     difference() {
          linear_extrude(height=kControllerThickness, center=true) {
               square([kControllerWidth, kControllerLength]);
          }
          linear_extrude(height=1.1 * kControllerThickness, center=true) {
               for(x = [6.33, 66 - 6.33]) {
                    for(y = [97 - 3.34 - 2.54, 97 - 3.34]) {
                         translate([x, y]) {
                              circle(d=1.5, $fn = 64);
                         }
                    }
               }
               for(x = [6.33, 6.33 + 2.54, 66 - 6.33 - 2.54, 66 - 6.33]) {
                    for(y = [0:2.54:60.96]) {
                         translate([x, y + 2.22]) {
                              circle(d=1.5, $fn=64);
                         }
                    }
               }
          }
     }
}

kWheelDiameter = 96;
kWheelWidth = 32;

module mWheel() {
     translate([0, 16, 0])
     rotate([-90, 0, 0])
     import("oem/3601-0014-0096.stl");
}

kRoundBeltPulleyWidth = 6;

module mRoundBeltPulley() {
     import("oem/3400-0014-0032.stl");
}

kClampingHubWidth = 8;

module mClampingHub() {
     translate([0.5, 0, 3.3303027798233593])
     rotate([0, -180, 90])
     translate([26.56210756, 12.11835694, -22.16415906])
     import("oem/1301-0016-0008.stl");
}

kBearingHeight = 7;
kBearingOuterDiameter = 22;
kBearingOuterRingDiameter = 19.1;
kBearingInnerDiameter = 8;

module mBearing() {
     rotate([90, 0, 0])
     import("oem/608.stl", convexity=10);
}

module mBearingHull(center=false) {
     z_offset = -kEpsilon/2 - (center ? kBearingHeight/2 : 0);
     translate([0, 0, z_offset])
     cylinder(d=kEpsilon + kBearingOuterDiameter,
              h=kEpsilon + kBearingHeight);
}

kThrustBearingInnerDiameter=10;
kThrustBearingOuterDiameter=24;
kThrustBearingHeight = 9;

module mThrustBearing() {
     rotate([0, -90, 0])
     import("oem/51100.stl");
}

kBushingHeight = 8;
kBushingOuterDiameter = 8;
kBushingInnerDiameter = 6;

module mBushing() {
     rotate([0, -90, 0])
     import("oem/PCM_060808_E.stl");
}

module mBushingHull(center=false) {
     z_offset = -kEpsilon/2 - (center ? kBushingHeight/2 : 0);
     translate([0, 0, z_offset])
     cylinder(d=kEpsilon + kBushingOuterDiameter,
              h=kEpsilon + kBushingHeight);
}

kShockAbsorberLength = 68;
kShockAbsorberDiameter = 17;

module mShockAbsorber() {
     translate([0.0, 0.07597303, -33.29282761])
     import("oem/shock_absorber_1_10_70.stl");
}

kRoundShaftDiameter = 8;

module mRoundShaftL100() {
     translate([0, -50, 0])
     import("oem/2100-0008-0100.stl");
}

kClampingCollarWidth = 8;

module mClampingCollar() {
     translate([6.99622047,  4.8345592 , -6.97633803])
     import("oem/2910-0818-0008.stl");
}

kDCMotorTerminalHoleDiameter = 1.6;
kDCMotorTerminalThickness = 0.45;
kDCMotorTerminalLength = 5.7;
kDCMotorTerminalWidth = 3.75;
kDCMotorPlusGearBoxLength = 100.5;
kDCMotorDiameter = 37;
kDCMotorAirwayToBottom = 16.7;
kDCMotorShaftHoleDiameter = 3;
kDCMotorShaftToShaftHole = 10.7;
kDCMotorShaftLength = 28;
kDCMotorShaftDiameter = 8;
kDCMotorBearingDiameter = 16;
kDCMotorGearBoxLength = 42;
kDCMotorGearBoxDiameter = 34;

kDCMotorFasteningAngles = [-135, -45, 45, 135];
kDCMotorFasteningDiameter = 24;
kDCMotorFasteningHoleDiameter = 4;

module mDCMotor() {
     rotate([-19, 0, 0])
     rotate([0, 90, 0])
     // TODO(hidmic): revisar!
     translate([0.02841282, 0, 28-144.04437256])
     import("oem/MR08D-024022.stl");
}


kM3x4_8ThreadedInsertDiameter = 4;
kM3x4_8ThreadedInsertLength = 4.8;

module mM3x4_8ThreadedInsert() {
     rotate([90, 0, 0])
     import("oem/90742A121.stl");
}

module mM3x6SetScrew() {
     translate([0, 0, -2.75306201])
     import("oem/92015A104.stl");
}

kM15BevelGearMountingDistance = 30;
kM15BevelGearLength = 20.6;
kM15BevelGearHubLength = 10;
kM15BevelGearHubDiameter = 20;

module mM15BevelGear() {
     difference() {
          rotate([0, 0, 180]) {
               import("oem/2810N4.stl", convexity=10);
          }
          translate([-(kM15BevelGearLength - kM15BevelGearHubLength/2), 0, 0])
          cylinder(d=kM3x4_8ThreadedInsertDiameter, h=kM15BevelGearHubDiameter/2);
     }
     translate([-(kM15BevelGearLength - kM15BevelGearHubLength/2),
                0, kM15BevelGearHubDiameter/2])
     union() {
          mM3x4_8ThreadedInsert();
          translate([0, 0, -0.2])
          mM3x6SetScrew();
     }
}


module mMountedRoundBeltPulley() {
     mClampingHub();
     translate([kRoundBeltPulleyWidth/2 + kClampingHubWidth/2, 0, 0]) {
          mRoundBeltPulley();
     }
}

kBallCasterHeight = 15.5;

module mBallCaster() {
     rotate([180, 0, 0])
     import("oem/cy-15a.stl");
}

kEncoderHeight = 10.34;
kEncoderWidth = 28.58;
kEncoderLength = 37.25;
kEncoderAxleToTop = 15.33;
kEncoderMountingDiameter = 25.4;
kEncoderMountingAngles = [-135, -45, 45, 135];
kEncoderMountingHoleDiameter = 2;

module mEncoder() {
     rotate([0, 0, 180])
     translate([-kEncoderWidth/2, 0, -(kEncoderLength - kEncoderAxleToTop)])
     rotate([90, 0, 0])
     import("oem/CUI_AMT112S-4096-8000-S.STL");
}

kBatteryLength = 150;
kBatteryWidth = 60;
kBatteryHeight = 90;

module mBattery() {
     import("oem/Batterie.stl");
}

kCliffSensorWidth = 5.5;
kCliffSensorLength = 10;

kCliffSensorBoardWidth = 14;
kCliffSensorBoardLength = 31.18;
kCliffSensorBoardThickness = 1.6;
kCliffSensorDistanceToBoard = 11.5 - kCliffSensorBoardThickness;
kCliffSensorAssemblyHeight = kCliffSensorDistanceToBoard + 6.3 - kCliffSensorBoardThickness;

module mCliffSensor() {

}

kLedDiameter = 5;


kM8WasherThickness = 1.6;
kM8WasherInnerDiameter = 8.4;
kM8WasherOuterDiameter = 16;


kM3ScrewDiameter = 3;
kM2ScrewDiameter = 2;



