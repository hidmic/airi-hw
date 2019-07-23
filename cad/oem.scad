kA1M8r1WorkingWidth = 6;
kA1M8r1Range = 6000;

module mLidar() {
     translate([-35.14, 35, 0])
     rotate([90, 0, 0])
     import("oem/RPLIDAR-A1M8-R1.stl");
}

kHCSR04FOV = 30;
kHCSR04Range = 4000;
kHCSR04Width = 20;
kHCSR04Length = 40;

module mSonarCone() {
     linear_extrude(height=kHCSR04Range, scale=kHCSR04Range * tan(kHCSR04FOV)/kHCSR04Length) {
          square([kHCSR04Width, kHCSR04Length], center=true);
     }
     /* polyhedron(points=[[-kHCSR04Width/2, -kHCSR04Length/2, 0],  //0 */
     /*                    [-kHCSR04Width/2, kHCSR04Length/2, 0],  //1 */
     /*                    [kHCSR04Width/2, kHCSR04Length/2, 0],  //2 */
     /*                    [kHCSR04Width/2, -kHCSR04Length/2, 0],  //3 */
     /*                    [-coneRadius/2, -coneRadius/2, kHCSR04Range],  //4 */
     /*                    [-coneRadius/2, coneRadius/2, kHCSR04Range],  //5 */
     /*                    [coneRadius/2, coneRadius/2, kHCSR04Range],  //6 */
     /*                    [coneRadius/2, -coneRadius/2, kHCSR04Range]], //7 */
     /*            faces=[[0,1,2,3],  // bottom */
     /*                   [4,5,1,0],  // front */
     /*                   [7,6,5,4],  // top */
     /*                   [5,6,2,1],  // right */
     /*                   [6,7,3,2],  // back */
     /*                   [7,4,0,3]]); // left */
     /* rotate_extrude() { */
     /*      hull() { */
     /*           sector(kHCSR04Range, [90-kHCSR04FOV/2, 90]); */
     /*           square(kHCSR04Length/2); */
     /*      } */
     /* } */
}

module mSonar() {
     import("oem/HC-SR04.stl");
}



kGY521Width = 15.24;
kGY521Length = 25.4;
kGY521Thickness = 1.6;

module mIMU() {
     translate([-kGY521Length/2, -kGY521Width/2, 0])
     import("oem/GY521.stl");
}

kJetsonNanoLength = 100;
kJetsonNanoWidth = 81.021973;

module mHighLvlComputer() {
     // BB 81.021973 30.506195 100.000000
     import("oem/Jetson-Nano-DK.stl");
}

kSTM32F407DISCOWidth = 66;
kSTM32F407DISCOLength = 97;
kSTM32F407DISCOThickness = 1.6;

module mLowLvlComputer() {
     difference() {
          linear_extrude(height=kSTM32F407DISCOThickness, center=true) {
               square([kSTM32F407DISCOWidth, kSTM32F407DISCOLength]);
          }
          linear_extrude(height=1.1 * kSTM32F407DISCOThickness, center=true) {
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

module mRubberWheel() {
     translate([0, 12, 0])
     rotate([-90, 0, 0])
     import("oem/3601-0014-0072.stl");
}

kRoundBeltPulleyWidth = 6;

module mRoundBeltPulley() {
     import("oem/3400-0014-0032.stl");
}

module mClampingHub() {
     rotate([0, -90, 0])
     translate([14.01232946, -7.45843506, 8.17303562-1])
     import("oem/1310-0016-0008.stl");
}

k8x22x7BallBearingWidth = 7;

module m8x22x7BallBearing() {
     import("oem/608.stl");
}

module m8x100RoundShaft() {
     rotate([-90, 0, 0])
     import("oem/2100-0008-0100.stl");
}

k12vDCMotorShaftLength = 28;

module m12vDCMotor() {
     translate([-28, 0, 0])
     rotate([0, 90, 0])
     rotate([0, 0, -15])
     translate([0, 0, -92])
     import("oem/MR08D-012004.stl");
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
     translate([-kRoundBeltPulleyWidth/2, 0, 0]) {
          mClampingHub();
     }
     mRoundBeltPulley();
}

module mTransmission() {
     rotate([9, 0, 0])
     mM15BevelGear();
     translate([kM15BevelGearMountingDistance - kM15BevelGearLength,
                -(kM15BevelGearMountingDistance - kM15BevelGearLength), 0])
     union() {
          rotate([0, 0, 90])
          mM15BevelGear();
          rotate([-90, 0, 0])
          m8x100RoundShaft();
          translate([0, -k8x22x7BallBearingWidth-25, 0])
          m8x22x7BallBearing();
          translate([0, -k8x22x7BallBearingWidth-60, 0])
          m8x22x7BallBearing();
          translate([0, -100, 0])
          rotate([0, 0, -90])
          mMountedRoundBeltPulley();
     };
}

$fn=64;

mTransmission();
m12vDCMotor();
