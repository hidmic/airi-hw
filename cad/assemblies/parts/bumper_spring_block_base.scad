include <generic/lib.scad>;

use <chassis_base.scad>;

kChassisBaseDatasheet = vChassisBaseDatasheet();

function vBumperSpringBlockBaseDatasheet() =
     let(thickness=property(kChassisBaseDatasheet, "thickness"),
         seat_thickness=3 * thickness, slot_width=5, spring_travel_distance=5,
         spring_max_length=spring_travel_distance + slot_width + 2 * seat_thickness)
     [["height", 20], ["width", 20], ["depth", 35], ["thickness", thickness], ["angular_offset", 70],
      ["spring_outer_diameter", 12], ["spring_inner_diameter", 8], ["spring_lock_size", 2 * thickness],
      ["spring_seat_thickness", seat_thickness], ["spring_slot_width", slot_width],
      ["spring_travel_distance", spring_travel_distance],
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

     base_chassis_height = property(kChassisBaseDatasheet, "base_height");

     translate([spring_seat_thickness - spring_lock_size, width/2, height/2]) {
          rotate([0, 90, 0]) {
               translate([0, 0, -(spring_max_length - spring_slot_width) - kEpsilon]) {
                    cylinder(d=spring_inner_diameter, h=spring_max_length - spring_slot_width + 2 * kEpsilon);
                    translate([-(base_chassis_height - height/2) - kEpsilon, -spring_inner_diameter/2, 0]) {
                         cube([base_chassis_height - height/2 + kEpsilon, spring_inner_diameter,
                               spring_max_length - spring_slot_width + 2 * kEpsilon]);
                    }
                    translate([0, 0, spring_seat_thickness - spring_lock_size - kEpsilon]) {
                         cylinder(d=spring_outer_diameter, h=spring_max_length - spring_slot_width - 2 * (spring_seat_thickness - spring_lock_size) + 2 * kEpsilon);
                         translate([-(base_chassis_height - height/2) - kEpsilon, -spring_outer_diameter/2, 0]) {
                              cube([base_chassis_height - height/2 + kEpsilon, spring_outer_diameter,
                                    spring_max_length - spring_slot_width - 2 * (spring_seat_thickness - spring_lock_size)]);
                         }
                    }
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

     chassis_outer_diameter = property(kChassisBaseDatasheet, "outer_diameter");
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
                    }
               }
          }
          translate([-chassis_outer_diameter/2 * cos(angular_offset), chassis_outer_diameter/2 * sin(angular_offset)]) {
               ring(inner_radius=chassis_outer_diameter/2 - kEpsilon, outer_radius=chassis_outer_diameter);
          }
     }
}

mBumperSpringBlockXSection();
