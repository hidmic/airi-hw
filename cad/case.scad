include <specs.scad>;
use <lib.scad>;

$fn = 64;


kCaseBayUpperDiameter = 80;
kCaseBayLowerDiameter = 250;
kCaseBayHeight = 15;

kCaseSlitBlindFOV = 15;
kCaseSlitBlindCount = 4;
kCaseSlitMaxFOV = 360 / kCaseSlitBlindCount;
kCaseSlitFOV = kCaseSlitMaxFOV - kCaseSlitBlindFOV;


module mCaseSlitFOV() {
     linear_extrude(height=kCaseSlitWidth, center=true) {
          for (slitCenterAngle = [kCaseSlitMaxFOV/2:
                                  kCaseSlitMaxFOV:
                                  360 - kCaseSlitMaxFOV/2]) {
               startAngle = slitCenterAngle - kCaseSlitFOV/2;
               endAngle = slitCenterAngle + kCaseSlitFOV/2;
               sector(kLidarRange, [startAngle, endAngle]);
          };
     };
};


module mCaseBB() {
     translate([0., 0., kCaseHeight/2]) {
          cube([kCaseDiameter, kCaseDiameter, kCaseHeight], center=true);
     };
}





module mCaseBottomHalf() {
     difference() {
          mCase();
          translate([0., 0., kCaseHeight * 0.7]) {
               mCaseBB();
          };
     };
};



//mCase();




     /* translate([0, 0, kCaseHeight/2]) { */
     /*      difference() */
     /*      difference() { */
     /*           cylinder(d1=kCaseBayLowerDiameter, */
     /*                    d2=kCaseBayUpperDiameter, */
     /*                    h=kCaseBayHeight); */
     /*           cylinder(d=kCaseBayLowerDiameter, */
     /*                    h=kLidarWorkingWidth); */
     /*      }; */
     /* }; */
     /* minkowski() { */
     /*      cylinder(d=(kCaseDiameter - 2 * kCaseFillet), */
     /*               h=(kCaseHeight - 2 * kCaseFillet), */
     /*               center=true); */

     /*      sphere(r=kCaseFillet); */
     /* }; */

//mCase();



module mCaseHull() {
     translate([0, 0, kCaseHeight/2]) {
          minkowski() {
               cylinder(d=(kCaseDiameter - 2 * kCaseFillet),
                        h=(kCaseHeight - 2 * kCaseFillet),
                        center=true);
               sphere(r=kCaseFillet);
          }
     }
}

mCaseHull();

module mCase() {
     difference() {
          mCaseHull();
          translate([0, 0, kCaseHeight - kCaseWirewayDepth]) {
               cylinder(r1=(kCaseWirewayRadius + kCaseWirewayWidth/2),
                        r2=(kCaseWirewayRadius + kCaseWirewayWidth/2 +
                            kGrowthFactor * kCaseWirewayDepth * tan(kCaseWirewayAngle)),
                        h=kGrowthFactor * kCaseWirewayDepth);
          }
          for (i = [-(kSonarCount-1)/2:(kSonarCount-1)/2]) {
               rotate([0, 0, i * kHCSR04FOV])
                    translate([kCaseRadius - kGrowthFactor * kHCSR04Width/2 * cos(kSonarPolarAngle),
                               0., kSonarWedgeHeight]) {
                    rotate([0, kSonarPolarAngle, 0]) {
                         mSonarCone();
                    }
               }
          }

     }
     translate([0, 0, kCaseHeight - kCaseWirewayDepth]) {
          cylinder(r1=(kCaseWirewayRadius - kCaseWirewayWidth/2),
                   r2=(kCaseWirewayRadius - kCaseWirewayWidth/2 -
                       kCaseWirewayDepth * tan(kCaseWirewayAngle)),
                   h=kCaseWirewayDepth);
     }
}


//mCase();


/* translate([0, 0, kCaseSlitHeight]) { */
/*      difference() { */
/*           cylinder(r=kGrowthFactor * kCaseRadius, h=kCaseSlitWidth, center=true); */
/*           cylinder(r=kCaseRadius - 10, h=kCaseSlitWidth, center=true); */
/*      } */
/* } */


