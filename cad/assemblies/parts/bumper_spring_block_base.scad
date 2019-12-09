include <generic/lib.scad>;

use <oem/f066_sae1070_spring.scad>;

use <chassis_base.scad>;

function vBumperSpringBlockBaseDatasheet() =
     let(chassis_datasheet=vChassisBaseDatasheet(),
         spring_datasheet=vF066SAE1070SpringDatasheet(),
         thickness=property(chassis_datasheet, "thickness"),
         slot_width=property(spring_datasheet, "pitch"),
         seat_thickness=thickness, spring_travel_distance=2,
         spring_max_length=spring_travel_distance + 2 * (slot_width + seat_thickness))
     assert(spring_max_length < property(spring_datasheet, "free_length"))
     [["height", 10], ["width", 22], ["depth", 50], ["thickness", thickness], ["angular_offset", 70],
      ["spring_outer_diameter", property(spring_datasheet, "outer_diameter")],
      ["spring_inner_diameter", property(spring_datasheet, "inner_diameter")],
      ["spring_seat_thickness", seat_thickness], ["spring_slot_width", slot_width],
      ["spring_lock_size", 0], ["spring_travel_distance", spring_travel_distance],
      ["spring_max_length", spring_max_length]];


module mBumperSpringBlockSeatComplement() {
     datasheet = vBumperSpringBlockBaseDatasheet();
     height = property(datasheet, "height");
     width = property(datasheet, "width");
     depth = property(datasheet, "depth");
     thickness = property(datasheet, "thickness");
     angular_offset = property(datasheet, "angular_offset");

     spring_outer_diameter = property(datasheet, "spring_outer_diameter");
     spring_inner_diameter = property(datasheet, "spring_inner_diameter");
     spring_lock_size = property(datasheet, "spring_lock_size");
     spring_seat_thickness = property(datasheet, "spring_seat_thickness");
     spring_slot_width = property(datasheet, "spring_slot_width");
     spring_travel_distance = property(datasheet, "spring_travel_distance");
     spring_max_length = property(datasheet, "spring_max_length");

     base_chassis_height = property(vChassisBaseDatasheet(), "base_height");

     translate([spring_seat_thickness - spring_lock_size, width/2, height/2]) {
          rotate([0, 90, 0]) {
               translate([0, 0, -(spring_max_length - spring_slot_width) - kEpsilon]) {
                    cylinder(d=spring_inner_diameter, h=spring_max_length - spring_slot_width + 2 * kEpsilon);
                    translate([-(base_chassis_height - height/2) - kEpsilon, -spring_inner_diameter/2, 0]) {
                         cube([base_chassis_height - height/2 + kEpsilon, spring_inner_diameter,
                               spring_max_length - spring_slot_width + 2 * kEpsilon]);
                    }
                    /* translate([0, 0, spring_seat_thickness - spring_lock_size - kEpsilon]) { */
                    /*      cylinder(d=spring_outer_diameter, h=spring_max_length - spring_slot_width - 2 * (spring_seat_thickness - spring_lock_size) + 2 * kEpsilon); */
                    /*      translate([-(base_chassis_height - height/2) - kEpsilon, -spring_outer_diameter/2, 0]) { */
                    /*           cube([base_chassis_height - height/2 + kEpsilon, spring_outer_diameter, */
                    /*                 spring_max_length - spring_slot_width - 2 * (spring_seat_thickness - spring_lock_size) + 2 * kEpsilon]); */
                    /*      } */
                    /* } */
               }
          }
     }
}

mBumperSpringBlockSeatComplement();

module mBumperSpringBlockXSection() {
     datasheet = vBumperSpringBlockBaseDatasheet();
     height = property(datasheet, "height");
     width = property(datasheet, "width");
     depth = property(datasheet, "depth");
     thickness = property(datasheet, "thickness");
     angular_offset = property(datasheet, "angular_offset");

     spring_lock_size = property(datasheet, "spring_lock_size");
     spring_seat_thickness = property(datasheet, "spring_seat_thickness");
     spring_slot_width = property(datasheet, "spring_slot_width");
     spring_travel_distance = property(datasheet, "spring_travel_distance");
     spring_max_length = property(datasheet, "spring_max_length");

     chassis_outer_diameter = property(vChassisBaseDatasheet(), "outer_diameter");
     difference() {
          translate([-spring_lock_size, width - chassis_outer_diameter/2]) {
               outline(delta=-thickness) {
                    square([depth, chassis_outer_diameter/2]);
               }
               square([spring_seat_thickness, chassis_outer_diameter/2]);
               translate([spring_slot_width + spring_seat_thickness, 0]) {
                    square([depth - spring_slot_width - spring_seat_thickness, chassis_outer_diameter/2]);
               }
               translate([-(spring_max_length - spring_slot_width - 2 * spring_seat_thickness), 0]) {
                    translate([-spring_seat_thickness, 0]) {
                         square([spring_seat_thickness, chassis_outer_diameter/2]);
                         translate([-spring_seat_thickness-spring_slot_width, 0]) {
                              square([spring_seat_thickness, chassis_outer_diameter/2]);
                         }
                    }
               }
          }
          translate([-chassis_outer_diameter/2 * cos(angular_offset), chassis_outer_diameter/2 * sin(angular_offset)]) {
               ring(inner_radius=chassis_outer_diameter/2 - kEpsilon, outer_radius=chassis_outer_diameter);
          }
     }
}

mBumperSpringBlockXSection();
