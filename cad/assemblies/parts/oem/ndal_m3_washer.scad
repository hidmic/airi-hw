include <generic/washer.scad>

function vNdAlM3WasherDatasheet() =
     pvWasherDatasheet(outer_diameter=10, inner_diameter=4, thickness=3);

module mNdAlM3Washer() {
     color("silver") pmWasher(vNdAlM3WasherDatasheet());
}

mNdAlM3Washer();
