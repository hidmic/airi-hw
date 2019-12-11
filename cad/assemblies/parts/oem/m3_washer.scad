include <generic/washer.scad>

function vM3WasherDatasheet() =
     pvWasherDatasheet(outer_diameter=8.8, inner_diameter=3.3, thickness=1);

module mM3Washer() {
     pmWasher(vM3WasherDatasheet());
}

mM3Washer();
