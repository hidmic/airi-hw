include <generic/lib.scad>;

function vChassisBaseDatasheet() =
     let(outer_diameter=300, thickness=2, inner_diameter=outer_diameter - 2 * thickness,
         base_height=100, cover_height=20, outer_height=base_height + cover_height,
         inner_height=outer_height - 2 * thickness)
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["base_height", base_height], ["height", outer_height],
      ["inner_height", inner_height], ["thickness", thickness],
      ["z_offset", 20], ["fillet_radius", 5]];

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


module mChassisBase() {

}

mChassisBase();
