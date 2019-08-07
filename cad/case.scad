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


/* module mSonarBracket() { */
/*      render() */
/*      translate([kCaseDiameter/2 - kSonarBracketDistanceToCase, 0, kSonarBracketHeight]) */
/*      rotate([0, kSonarPolarAngle, 0]) */
/*      difference() { */
/*           translate([0, 0, kCaseThickness/2]) */
/*                rotate([0, -kSonarPolarAngle, 0]) */
/*                translate([-kCaseDiameter/2 + kSonarBracketDistanceToCase, 0]) { */

/*                difference() { */

/*                     difference() { */
/*                          rounded_cylinder(diameter=kCaseDiameter, height=kCaseHeight, fillet_radius=kCaseFillet, center=true); */
/*                          translate([kCaseDiameter/2 - kSonarBracketDistanceToCase, 0, 0]) { */
/*                               rotate([0, kSonarPolarAngle, 0]) { */
/*                                    difference() { */
/*                                         linear_extrude(height=kSonarRange, scale=kSonarFrustumWidth/kSonarWidth) { */
/*                                              square([kSonarLength, kSonarWidth], center=true); */
/*                                         } */
/*                                         translate([0, 0,  -kCaseThickness]) { */
/*                                              linear_extrude(height=kSonarRanges + kCaseThickness + kEpsilon, */
/*                                                             scale=(kSonarFrustumWidth + 2 * kCaseThickness)/(kSonarWidth + 2 * kCaseThickness)) { */
/*                                                   square([kSonarLength - 2 * kCaseThickness * tan(kSonarFOV/2) - kEpsilon, */
/*                                                           kSonarWidth + 2 * kCaseThickness * (1 - tan(kSonarFOV/2))], center=true); */
/*                                              } */
/*                                         } */
/*                                    } */
/*                               } */
/*                          } */
/*                     } */
/*                     difference() { */
/*                          rounded_cylinder(diameter=kCaseDiameter + kEpsilon, height=kCaseHeight+kEpsilon, fillet_radius=kCaseFillet, center=true); */
/*                          translate([kCaseDiameter/2 - kSonarBracketDistanceToCase, 0, 0]) { */
/*                               rotate([0, kSonarPolarAngle, 0]) { */
                                   
/*                               } */
/*                          } */
/*                     } */

/*                     let(x1 = kSonarBracketDistanceToCase - kSonarLength/2 * sin(90 - kSonarPolarAngle), */
/*                         x2 = kSonarBracketDistanceToCase + kSonarLength/2 * sin(90 - kSonarPolarAngle), */
/*                         y1 = -kSonarLength/2 * cos(90 - kSonarPolarAngle), */
/*                         y2 = kSonarLength/2 * cos(90 - kSonarPolarAngle), */
/*                         h = ((x2 + x1) * tan(90 - kSonarPolarAngle) + (y2 + y1))/2) { */

/*                          translate([0, 0, h - kCaseHeight/8 - 5]) { */
/*                               linear_extrude(height=kCaseHeight/4, center=true) { */
/*                                    ring(inner_radius=kCaseDiameter/2 - kCaseThickness, outer_radius=kCaseDiameter/2 + kEpsilon); */
/*                               } */
/*                          } */

/*                          translate([0, 0, h + kCaseHeight/8 + 5]) { */
/*                               linear_extrude(height=kCaseHeight/4, center=true) { */
/*                                    ring(inner_radius=kCaseDiameter/2 - kCaseThickness, outer_radius=kCaseDiameter/2 + kEpsilon); */
/*                               } */
/*                          } */
/*                     } */
/*                } */
/*           } */

/*           for (x = [-8.5, 8.5]) { */
/*                for (y = [-20, 20]) { */
/*                     translate([x, y, 0]) */
/*                          cylinder(d=kM2ScrewDiameter, h=kCaseThickness + kEpsilon, center=true); */
/*                } */
/*           } */
/*      } */
/* } */


kSonarBracketWidth = kSonarWidth + 5;
kSonarBracketLength = kSonarLength + 5;
kSonarBracketHeight = kCaseHeight/2;

module mSonarBracket() {
     render(convexity = 10) {
          rotate([0, -kSonarPolarAngle, 0])
          difference() {
               rotate([0, kSonarPolarAngle, 0]) {
                    linear_extrude(height=2 * kSonarBracketDistanceToCase,
                                   scale=(4 * kSonarBracketDistanceToCase * tan(kSonarFOV/2) + kSonarBracketWidth  + 2 * kCaseThickness)/(kSonarBracketWidth + 2 * kCaseThickness)) {
                         difference() {
                              square([kSonarBracketLength, kSonarBracketWidth + 2 * kCaseThickness], center=true);
                              square([kSonarBracketLength + kEpsilon, kSonarBracketWidth], center=true);
                         }
                    }
                    linear_extrude(height=kCaseThickness) {
                         difference() {
                              square([kSonarBracketLength, kSonarBracketWidth + 2 * kCaseThickness], center=true);
                              for (x = [-kSonarHoleToHoleLength/2, kSonarHoleToHoleLength/2]) {
                                   for (y = [-kSonarHoleToHoleWidth/2, kSonarHoleToHoleWidth/2]) {
                                        translate([x, y, 0]) circle(d=kM2ScrewDiameter);
                                   }
                              }
                         }
                    }
               }
               translate([kSonarBracketDistanceToCase, 0, 0])
               difference() {
                    cube(kCaseHeight, center=true);
                    translate([-kCaseDiameter/2, 0, 0]) {
                         cylinder(d=kCaseDiameter - 2 * kCaseThickness - kEpsilon, h=kCaseHeight + kEpsilon, center=true);
                         translate([0, 0, kSonarBracketDistanceToCase * sin(90 - kSonarPolarAngle)])
                              cylinder(d=kCaseDiameter + 3 * kEpsilon, h=kSonarBracketPinWidth, center=true);

                    }
               }
          }
     }
}

module mSonarFrustum() {
     rotate([0, kSonarPolarAngle, 0]) {
          translate([0, 0, kCaseThickness]) {
               linear_extrude(height=kSonarRange, scale=(2 * kSonarRange * tan(kSonarFOV/2) + kSonarWidth)/kSonarWidth) {
                    square([kSonarLength, kSonarWidth], center=true);
               }
          }
     }
}


/* difference() { */
/* linear_extrude(height=kCaseHeight) */
/* ring(inner_radius=kCaseDiameter/2 - kCaseThickness, outer_radius=kCaseDiameter/2); */
/* for (angle = kSonarMountingAngles) { */
/*      rotate([0, 0, angle]) mSonarBracket(); */
/* } */
/* } */
/* difference() { */
/*      linear_extrude(height=kCaseHeight) */
/*      ring(inner_radius=kCaseDiameter/2 - kCaseThickness, outer_radius=kCaseDiameter/2); */
/*      for (angle = kSonarMountingAngles) { */
/*           rotate([0, 0, angle]) mSonarBracket(); */
/*      } */
/* } */

module mBumper() {
render(convexity=10) {
difference() {
linear_extrude(height=kCaseHeight - 4 * kCaseFillet, center=true)
ring(inner_radius=kCaseDiameter/2 - kCaseThickness, outer_radius=kCaseDiameter/2);
for (angle = kSonarMountingAngles) {
     rotate([0, 0, angle]) {
          translate([kCaseDiameter/2 - kSonarBracketDistanceToCase, 0, 0])  {
               mSonarBracket();
               mSonarFrustum();
          }
     }
}
}
for (angle = kSonarMountingAngles) {
     rotate([0, 0, angle]) {
          translate([kCaseDiameter/2 - kSonarBracketDistanceToCase, 0, 0]) {
               mSonarBracket();
          }
     }
}
}
}

mSonarBracket();
translate([0, 0, 8])
mSonar();

rotate([0, kSonarPolarAngle, 0]) {

}
