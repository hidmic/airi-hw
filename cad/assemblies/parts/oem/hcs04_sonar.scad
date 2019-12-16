include <generic/lib.scad>;

function vHCS04SonarDatasheet() =
     [["horizontal_fov", 30], ["range", 4000], ["width", 43],
      ["length", 20], ["height", 15], ["hole_to_hole_width", 40],
      ["hole_to_hole_length", 17], ["hole_diameter", 2]];

module mHCS04SonarFrustum() {
     datasheet = vHCS04SonarDatasheet();
     sonar_length = property(datasheet, "length");
     sonar_width = property(datasheet, "width");
     sonar_range = property(datasheet, "range");
     sonar_horizontal_fov = property(datasheet, "horizontal_fov");
     linear_extrude(height=sonar_range, scale=(2 * sonar_range * tan(sonar_horizontal_fov/2) + sonar_width)/sonar_width) {
          square([sonar_length, sonar_width], center=true);
     }
}

module mHCS04Sonar() {
     color("darkblue") {
          rotate([0, 0, 90]) {
               render() import("stl/HC-SR04.stl");
          }
     }
}

mHCS04Sonar();
