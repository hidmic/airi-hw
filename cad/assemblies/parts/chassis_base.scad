include <generic/lib.scad>;

function vChassisBaseDatasheet() =
     let(outer_diameter=400, thickness=2, inner_diameter=outer_diameter - 2 * thickness,
         base_height=109.5, height=133, inner_height=height - 2 * thickness)
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["base_height", base_height], ["height", height], ["inner_height", inner_height],
      ["thickness", thickness], ["support_diameter", 10], ["z_offset", 20], ["fillet_radius", 4]];

module mChassisOuterVolume() {
     datasheet = vChassisBaseDatasheet();
     rounded_cylinder(diameter=property(datasheet, "outer_diameter"),
                      height=property(datasheet, "height"),
                      fillet_radius=property(datasheet, "fillet_radius"));
}

module mChassisInnerVolume() {
     datasheet = vChassisBaseDatasheet();
     translate([0, 0, property(datasheet, "thickness")]) {
          rounded_cylinder(diameter=property(datasheet, "inner_diameter"),
                           height=property(datasheet, "inner_height"),
                           fillet_radius=property(datasheet, "fillet_radius"));
     }
}

module mChassisBBox() {
     datasheet = vChassisBaseDatasheet();
     chassis_height = property(datasheet, "height");
     chassis_outer_diameter = property(datasheet, "outer_diameter");
     translate([0., 0., chassis_height/2]) {
          cube([chassis_outer_diameter, chassis_outer_diameter, chassis_height], center=true);
     }
}

module mChassisShell() {
     difference() {
          mChassisOuterVolume();
          mChassisInnerVolume();
     }
}

module mChassisVolumeConstrain() {
     datasheet = vChassisBaseDatasheet();
     height = property(datasheet, "height");
     outer_diameter = property(datasheet, "outer_diameter");
     fillet_radius = property(datasheet, "fillet_radius");
     /* difference() { */
     /*      rounded_cylinder(diameter=outer_diameter, height=height, */
     /*                       fillet_radius=fillet_radius); */
     /*      difference() { */
     /*           translate([0, 0, -kEpsilon]) { */
     /*                rounded_cylinder(diameter=outer_diameter + kEpsilon, */
     /*                                 height=height + 2 * kEpsilon, */
     /*                                 fillet_radius=fillet_radius); */
     /*           } */
     /*           children(); */
     /*      } */
     /* } */
     difference() {
          children();
          difference() {
               translate([0, 0, height/2]) {
                    cube(2 * outer_diameter, center=true);
               }
               rounded_cylinder(diameter=outer_diameter, height=height,
                                fillet_radius=fillet_radius);
          }
     }
}
