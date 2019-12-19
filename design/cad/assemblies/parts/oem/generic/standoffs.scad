include <lib.scad>;

use <third_party/threads.scad>;

function pvMetricHexStandoffDatasheet(length, width, hole_diameter=0, thread_pitch=0) =
     assert(length > 0)
     assert(width > 0)
     assert(hole_diameter >= 0)
     assert(width > hole_diameter)
     assert(thread_pitch >= 0)
     [["length", length], ["width", width], ["hole_diameter", hole_diameter], ["thread_pitch", thread_pitch]];


module pmMetricHexStandoff(datasheet) {
     width = property(datasheet, "width");
     length = property(datasheet, "length");
     hole_diameter = property(datasheet, "hole_diameter");
     thread_pitch = property(datasheet, "thread_pitch");
     difference() {
          cylinder(d=width / cos(30), h=length, $fn=6);
          translate([0, 0, -length/2]) {
               if (hole_diameter > 0) {
                    if (thread_pitch > 0) {
                         metric_thread(diameter=hole_diameter, pitch=thread_pitch,
                                       length=2 * length, internal=true);
                    } else {
                         cylinder(d=hole_diameter, h=2 * length);
                    }
               }
          }
     }
}

pmMetricHexStandoff(
     datasheet=pvMetricHexStandoffDatasheet(
          length=20, width=5, hole_diameter=3, thread_pitch=1
     )
);
