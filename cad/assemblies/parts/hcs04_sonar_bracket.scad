include <generic/lib.scad>;

use <oem/hcs04_sonar.scad>;

use <chassis_base.scad>;

kHCS04SonarDatasheet = vHCS04SonarDatasheet();
kChassisBaseDatasheet = vChassisBaseDatasheet();

function vHCS04SonarBracketDatasheet() =
     [["width", property(kHCS04SonarDatasheet, "width") + 5],
      ["length", property(kHCS04SonarDatasheet, "length") + 5],
      ["connector_width", 12], ["pin_width", 10],
      ["thickness", 2], ["mounting_polar_angle", 75],
      ["distance_to_wall", 2 * property(kHCS04SonarDatasheet, "height")]];


module mHCS04SonarBracket() {
     datasheet = vHCS04SonarBracketDatasheet();
     width = property(datasheet, "width");
     pin_width = property(datasheet, "pin_width");
     length = property(datasheet, "length");
     thickness = property(datasheet, "thickness");
     mounting_polar_angle = property(datasheet, "mounting_polar_angle");
     distance_to_wall = property(datasheet, "distance_to_wall");
     sonar_horizontal_fov = property(kHCS04SonarDatasheet, "horizontal_fov");
     sonar_hole_to_hole_width = property(kHCS04SonarDatasheet, "hole_to_hole_width");
     sonar_hole_to_hole_length = property(kHCS04SonarDatasheet, "hole_to_hole_length");
     sonar_hole_diameter = property(kHCS04SonarDatasheet, "hole_diameter");

     color($default_color) {
          render(convexity = 10) {
               rotate([0, -mounting_polar_angle, 0])
               difference() {
                    rotate([0, mounting_polar_angle, 0]) {
                         let(extrusion_scale=(4 * distance_to_wall * tan(sonar_horizontal_fov/2) + width  + 2 * thickness)/(width + 2 * thickness)) {
                              linear_extrude(height=2 * distance_to_wall, scale=extrusion_scale) {
                                   difference() {
                                        square([length, width + 2 * thickness], center=true);
                                        square([length + kEpsilon, width], center=true);
                                   }
                              }
                         }
                         let(extrusion_scale=(2 * thickness * tan(sonar_horizontal_fov/2) + width  + 2 * thickness)/(width + 2 * thickness)) {
                              linear_extrude(height=thickness, scale=extrusion_scale) {
                                   difference() {
                                        square([length, width], center=true);
                                        for (x = [-sonar_hole_to_hole_length/2, sonar_hole_to_hole_length/2]) {
                                             for (y = [-sonar_hole_to_hole_width/2, sonar_hole_to_hole_width/2]) {
                                                  translate([x, y, 0]) circle(d=sonar_hole_diameter);
                                             }
                                        }
                                        translate([length/2 - length/6, 0]) {
                                             square([length/3, property(datasheet, "connector_width")], center=true);
                                        }
                                   }
                              }
                         }
                    }
                    let(chassis_height=property(kChassisBaseDatasheet, "height"),
                        chassis_outer_diameter=property(kChassisBaseDatasheet, "outer_diameter"),
                        chassis_inner_diameter=property(kChassisBaseDatasheet, "inner_diameter"),
                        chassis_thickness=property(kChassisBaseDatasheet, "thickness")) {
                         translate([distance_to_wall, 0, 0]) {
                              difference() {
                                   cube(chassis_height, center=true);
                                   translate([-chassis_outer_diameter/2, 0, 0]) {
                                        cylinder(d=chassis_inner_diameter - kEpsilon, h=chassis_height + kEpsilon, center=true);
                                        translate([0, 0, distance_to_wall * sin(90 - mounting_polar_angle)]) {
                                             cylinder(d=chassis_outer_diameter + 3 * kEpsilon, h=pin_width, center=true);
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}

mHCS04SonarBracket();
