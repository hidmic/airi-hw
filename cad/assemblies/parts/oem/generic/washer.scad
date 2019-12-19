include <lib.scad>;

function pvWasherDatasheet(outer_diameter, inner_diameter, thickness) =
     [["outer_diameter", outer_diameter],
      ["inner_diameter", inner_diameter],
      ["thickness", thickness]];

module pmWasher(datasheet) {
     linear_extrude(height=property(datasheet, "thickness")) {
          ring(outer_radius=property(datasheet, "outer_diameter")/2,
               inner_radius=property(datasheet, "inner_diameter")/2);
     }
}

pmWasher(pvWasherDatasheet(outer_diameter=10, inner_diameter=5, thickness=1));
