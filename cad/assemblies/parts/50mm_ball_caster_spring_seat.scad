include <generic/lib.scad>;

use <oem/f2276_sae1070_spring.scad>;
use <oem/m3x5mm_threaded_insert.scad>;
use <oem/m3_nut.scad>;

use <50mm_ball_caster_yoke.scad>;

k50mmBallCasterYokeDatasheet = v50mmBallCasterYokeDatasheet();
kM3x5mmThreadedInsertDatasheet = vM3x5mmThreadedInsertDatasheet();

function v50mmBallCasterSpringSeatDatasheet() =
     [["seat_height", property(kM3x5mmThreadedInsertDatasheet, "length")],
      ["seat_diameter", property(k50mmBallCasterYokeDatasheet, "seat_diameter")],
      ["seat_thickness", property(k50mmBallCasterYokeDatasheet, "seat_thickness")],
      ["main_diameter", property(k50mmBallCasterYokeDatasheet, "seat_diameter") + 10],
      ["main_height", property(k50mmBallCasterYokeDatasheet, "base_thickness") +
                      property(kM3x5mmThreadedInsertDatasheet, "length")],
      ["base_thickness", property(k50mmBallCasterYokeDatasheet, "base_thickness")]];


module m50mmBallCasterSpringSeat() {
     datasheet = v50mmBallCasterSpringSeatDatasheet();
     main_diameter = property(datasheet, "main_diameter");
     seat_height = property(datasheet, "seat_height");
     seat_diameter = property(datasheet, "seat_diameter");
     seat_thickness = property(datasheet, "seat_thickness");
     base_thickness = property(datasheet, "base_thickness");
     linear_extrude(height=base_thickness) {
          ring(outer_radius=main_diameter/2, inner_radius=3 / 2);
     }
     translate([0, 0, base_thickness]) {
          linear_extrude(height=seat_height) {
               outer_threaded_insert_diameter = property(kM3x5mmThreadedInsertDatasheet, "outer_diameter");
               ring(outer_radius=seat_diameter / 2 - kEpsilon, inner_radius=outer_threaded_insert_diameter / 2);
          }
     }
}


m50mmBallCasterSpringSeat();
