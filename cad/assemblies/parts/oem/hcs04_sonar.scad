
function vHCS04SonarDatasheet() =
     [["horizontal_fov", 30], ["range", 4000], ["width", 43],
      ["length", 20], ["height", 15], ["hole_to_hole_width", 40],
      ["hole_to_hole_length", 17]];

module mHCS04Sonar() {
     rotate([0, 0, 90]) import("stl/HC-SR04.stl");
}

mHCS04Sonar();
