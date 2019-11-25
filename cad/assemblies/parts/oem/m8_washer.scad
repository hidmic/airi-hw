include <generic/washer.scad>

function vM8WasherDatasheet() =
     pvWasherDatasheet(outer_diameter=16, inner_diameter=8.4, thickness=1.6);

module mM8Washer() {
     pmWasher(vM8WasherDatasheet());
}

mM8Washer();
