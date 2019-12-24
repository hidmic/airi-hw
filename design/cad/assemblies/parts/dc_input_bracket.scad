include <generic/lib.scad>;

use <oem/pj_082bh_connector.scad>;


function vDCInputBracketDatasheet() =
     let(dc_conn_datasheet=vPJ082BHConnectorDatasheet(),
         dc_conn_width=property(dc_conn_datasheet, "width"),
         dc_conn_height=property(dc_conn_datasheet, "height"),
         dc_conn_length=property(dc_conn_datasheet, "length"),
         opening_cut_angle=25, opening_cut_width=20, thickness=2, pin_diameter=3,
         pin_length=2 * sqrt(pow(pin_diameter/2, 2) - pow(thickness/2, 2)),
         x_min=-dc_conn_height/sin(opening_cut_angle), z_min=0,
         x_max=dc_conn_length * cos(opening_cut_angle) + 1,
         z_max=x_max * tan(opening_cut_angle) + dc_conn_height/cos(opening_cut_angle),
         main_length=(x_max - x_min)/cos(opening_cut_angle))
     [["main_length", main_length], ["x_min", x_min], ["x_max", x_max],
      ["z_min", z_min], ["z_max", z_max], ["opening_cut_angle", opening_cut_angle],
      ["opening_cut_width", opening_cut_width], ["pin_length", pin_length],
      ["thickness", thickness]];


module mDCInputOpeningArea() {
     datasheet = vDCInputBracketDatasheet();
     x_min = property(datasheet, "x_min");
     x_max = property(datasheet, "x_max");
     opening_cut_width = property(datasheet, "opening_cut_width");
     polygon([[x_min, -opening_cut_width/2], [0, -opening_cut_width/2],
              [0, opening_cut_width/6], [x_max, opening_cut_width/6],
              [x_max, opening_cut_width/2], [x_min, opening_cut_width/2]]);
}

module mDCInputBracket() {
     datasheet = vDCInputBracketDatasheet();
     thickness = property(datasheet, "thickness");
     main_length = property(datasheet, "main_length");

     x_min = property(datasheet, "x_min");
     x_max = property(datasheet, "x_max");
     z_min = property(datasheet, "z_min");
     z_max = property(datasheet, "z_max");

     opening_cut_width = property(datasheet, "opening_cut_width");
     opening_cut_angle = property(datasheet, "opening_cut_angle");

     pin_length = property(datasheet, "pin_length");


     color($default_color) {
          duplicate([0, 1, 0]) {
               translate([0, -opening_cut_width/2, 0]) {
                    rotate([90, 0, 0]) {
                         linear_extrude(height=thickness) {
                              polygon([[x_min, z_min], [x_max, z_min], [x_max, z_max]]);
                              for(l = [main_length/4, main_length/2, 3*main_length/4]) {
                                   translate([l * cos(opening_cut_angle) + x_min, l * sin(opening_cut_angle)]) {
                                        rotate(opening_cut_angle) {
                                             translate([-pin_length/2, 0]) {
                                                  square([pin_length, thickness]);
                                             }
                                        }
                                   }
                              }
                         }
                    }
               }
          }

          translate([x_max + thickness/2, 0, 0]) {
               linear_extrude(height=z_max - z_min) {
                    square([thickness, opening_cut_width + 2 * thickness], center=true);
               }
          }
     }
}

mDCInputBracket();
