
function vMR08D024022MotorDatasheet() =
     [["terminal_hole_diameter", 1.6], ["terminal_thickness", 0.45],
      ["terminal_length", 5.7], ["terminal_width", 3.75],
      ["length", 100.5], ["motor_diameter", 37], ["bottom_diameter", 36],
      ["airway_to_bottom", 16.7], ["shaft_hole_diameter", 3],
      ["shaft_hole_offset", 10.7], ["shaft_length", 28],
      ["shaft_diameter", 8], ["bearing_diameter", 16],
      ["gear_box_length", 42], ["gear_box_diameter", 34],
      ["mount_angles", [-135, -45, 45, 135]],
      ["mount_r_offset", 24], ["mount_hole_diameter", 3]];

module mMR08D024022Motor() {
     color("dimgray") {
          rotate([-19, 0, 0]) {
               rotate([0, 90, 0]) {
                    translate([0.02841282, 0, 9.5 + 28 - 144.04437256]) {
                         render() import("stl/MR08D-024022-266RPM.stl");
                    }
               }
          }
     }
}

mMR08D024022Motor();
