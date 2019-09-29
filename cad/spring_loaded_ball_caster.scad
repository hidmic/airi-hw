include <constants.scad>;
use <lib.scad>;

use <libs/springs.scad>;

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

kSpringLoadedBallCasterGap = 0.5;


$fn=40;

module spring_loaded_ball_support(ball_diameter, ball_protrusion, ball_gap, wall_gap, wall_thickness) {
     support_height = wall_thickness + ball_gap + ball_diameter - ball_protrusion;
     support_diameter = ball_diameter + 2 * wall_thickness;
     ball_zoffset = wall_thickness + ball_gap + ball_diameter/2;
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
               cylinder(h=ball_diameter/4 + ball_gap, d=ball_diameter * sqrt(3)/2);
          }
          cylinder(h=2 * (wall_thickness + kEpsilon), d=kSpringLoadedGuideFasteningHoleDiameter, center=true);
     }
}

use <libs/threads.scad>;

module metric_hex_standoff(diameter, pitch, length, width) {
     difference() {
          cylinder(d=width / cos(30), h=length, $fn=6);
          translate([0, 0, -kEpsilon]) {
               if (pitch > 0) {
                    metric_thread(diameter=diameter, pitch=pitch, length=length + 2 * kEpsilon, internal=true);
               } else {
                    cylinder(d=diameter, h=length + 2 * kEpsilon);
               }
          }
     }
}

kSpringLoadedBallCasterSupportRadius = 5;
kSpringLoadedBallCasterSupportHoleDiameter = 3;


module spring_loaded_ball_caster_yoke(ball_diameter, ball_protrusion, ball_travel,
                                      spring_seat_diameter, spring_seat_height, wall_gap,
                                      base_thickness, wall_thickness) {
     wall_inner_radius=ball_diameter/2 + wall_thickness + kSpringLoadedBallCasterGap;
     wall_outer_radius=wall_inner_radius + wall_thickness;
     translate([0, 0, base_thickness]) {
          linear_extrude(height=ball_travel + spring_seat_height) {
               difference() {
                    ring(outer_radius=wall_outer_radius, inner_radius=wall_inner_radius);
                    square([wall_gap, wall_outer_radius * 2 + kEpsilon], center=true);
               }
          }
          linear_extrude(height=spring_seat_height + base_thickness) {
               ring(outer_radius=wall_outer_radius, inner_radius=wall_inner_radius);
          }
          linear_extrude(height=spring_seat_height) {
               ring(outer_radius=spring_seat_diameter/2 + wall_thickness, inner_radius=spring_seat_diameter/2);
          }
     }
     linear_extrude(height=base_thickness) {
          difference() {
               circle(r=wall_outer_radius);
               offset(delta=kEpsilon) {
                    fill() {
                         projection() {
                              metric_hex_standoff(3, 0, 20, 5.5);
                         }
                    }
               }
          }
          duplicate([1, 0, 0]) {
               translate([wall_inner_radius, 0, 0]) {
                    curved_support_xsection(support_radius=kSpringLoadedBallCasterSupportRadius, fillet_radius=5,
                                            hole_radius=kSpringLoadedBallCasterSupportHoleDiameter/2, internal=false,
                                            wall_inner_radius=wall_inner_radius, wall_outer_radius=wall_outer_radius);
               }
          }
     }
}

kSpringWireDiameter = 1;

module spring_loaded_ball_caster(ball_diameter, ball_protrusion, ball_travel, ball_gap,
                                 spring_diameter, spring_seat_height, wall_gap,
                                 base_thickness, wall_thickness) {
     guide_length = ball_travel + spring_seat_height + wall_thickness;
     standoff_mounting_radius = ball_diameter/2 + wall_thickness * 3/2 + kSpringLoadedBallCasterGap + kSpringLoadedBallCasterSupportRadius;

     spring_loaded_ball_caster_yoke(ball_diameter, ball_protrusion, ball_travel,
                                    spring_diameter + 2 * kEpsilon, spring_seat_height,
                                    wall_gap, base_thickness, wall_thickness);
     translate([0, 0, wall_thickness]) {
          translate([0, 0, spring_seat_height + ball_travel]) {
               rotate([0, 0, 90]) {
                    spring_loaded_ball_support(ball_diameter, ball_protrusion, ball_gap, wall_gap, wall_thickness);
               }
               translate([0, 0, -guide_length]) metric_hex_standoff(3, 0.5, guide_length, 5.5);
               translate([0, 0, wall_thickness + ball_gap + ball_diameter/2]) sphere(d=ball_diameter);
          }
          spring(Windings=10, R=(spring_diameter-kSpringWireDiameter)/2, r=kSpringWireDiameter/2, h=spring_seat_height+ball_travel, slices=50);
     }
     duplicate([1, 0, 0]) {
          translate([standoff_mounting_radius, 0, wall_thickness]) {
               metric_hex_standoff(3, 0.5, 50, 5.5);
          }
     }
}

spring_loaded_ball_caster(ball_diameter=50, ball_protrusion=20, ball_travel=10, ball_gap=3,
                          spring_diameter=15, spring_seat_height=3, wall_gap=10,
                          base_thickness=3, wall_thickness=2);

//mainShape();

//cutout();
//mountingHoles();
//mBallCasterSupport();
//translate([0, 0, kCasterBallZOffset]) sphere(d=kCasterBallDiameter);
