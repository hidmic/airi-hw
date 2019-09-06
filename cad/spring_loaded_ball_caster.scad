include <lib.scad>;

kCasterBallDiameter = 8;
kCasterBallProtrusion = 2;
kCasterBallAirGap = 1;
kCasterMountingHoleDiameter = 3;
kCasterWallThickness = 2;
kCasterSideGapWidth = 3;
kCasterBaseThickness = 2;

kCasterBallZOffset = kCasterBaseThickness + kCasterBallAirGap + kCasterBallDiameter/2;
kCasterHeight = kCasterBaseThickness + kCasterBallAirGap + kCasterBallDiameter - kCasterBallProtrusion;
kCasterMountingDistance = kCasterBallDiameter + kCasterWallThickness * 4;

kSpringLoadedGuideFasteningHoleDiameter = 3;
//kSpringLoadedGuideDiameter = 
kSpringLoadedBallCasterGap = 0.5;


$fn=40;

module spring_loaded_ball_support(ball_diameter, ball_protrusion, base_gap, wall_gap, wall_thickness) {
     support_height = wall_thickness + base_gap + ball_diameter - ball_protrusion;
     support_diameter = ball_diameter + 2 * wall_thickness;
     ball_zoffset = wall_thickness + base_gap + ball_diameter/2;
     difference() {
          cylinder(support_height, d=support_diameter);
          translate([0, 0, ball_zoffset]) sphere(d=ball_diameter);
          translate([-support_diameter/2 - kEpsilon, -wall_gap/2, wall_thickness]) {
               cube([support_diameter + 2 * kEpsilon, wall_gap, support_height - wall_thickness + kEpsilon]);
          }
          translate([-support_diameter/2 - kEpsilon, 0, support_height - wall_gap/2]) {
               rotate([0, 90, 0]) cylinder(h=support_diameter + 2 * kEpsilon, d=2 * wall_gap, $fn=6);
          }
          translate([0, 0, wall_thickness]) {
               cylinder(h=ball_diameter/4 + base_gap, d=ball_diameter * sqrt(3)/2);
          }
          cylinder(h=2 * (wall_thickness + kEpsilon), d=kSpringLoadedGuideFasteningHoleDiameter, center=true);
     }
}

use <threads.scad>;

//metric_thread(diameter=8, pitch=1, length=4);
module metric_hex_standoff(diameter, pitch, length, width) {
     difference() {
          cylinder(d=width / cos(30), h=length, $fn=6);
          translate([0, 0, -kEpsilon]) {
               metric_thread(diameter=diameter, pitch=pitch, length=length + 2 * kEpsilon, internal=true);
          }
     }
}

//metric_hex_standoff(3, 0.5, 20, 5.5);
kSpringLoadedBallCasterSupportRadius = 5;
kSpringLoadedBallCasterSupportHoleDiameter = 3;
module spring_loaded_ball_caster(ball_diameter, ball_protrusion, ball_travel, base_gap, wall_gap, wall_thickness) {
     wall_inner_radius=ball_diameter/2 + wall_thickness + kSpringLoadedBallCasterGap;
     wall_outer_radius=wall_inner_radius + wall_thickness;
     linear_extrude(ball_travel)
          difference() {
          outline(delta=wall_thickness) {
                    offset(delta=kSpringLoadedBallCasterGap) {
                         fill() {
                              projection() {
                                   spring_loaded_ball_support(ball_diameter, ball_protrusion, base_gap, wall_gap, wall_thickness);
                              }
                         }
                    }
               }
               square([wall_gap, wall_outer_radius * 2 + kEpsilon], center=true);
          }
          duplicate([1, 0, 0]) {
               translate([wall_inner_radius, 0, 0]) {
                    curved_support_xsection(support_radius=kSpringLoadedBallCasterSupportRadius, fillet_radius=5,
                                            hole_radius=kSpringLoadedBallCasterSupportHoleDiameter/2, internal=false,
                                            wall_inner_radius=wall_inner_radius, wall_outer_radius=wall_outer_radius);
               }
          }
}

spring_loaded_ball_caster(50, 15, 2, 10, 2);

//mainShape();

//cutout();
//mountingHoles();
//mBallCasterSupport();
//translate([0, 0, kCasterBallZOffset]) sphere(d=kCasterBallDiameter);
