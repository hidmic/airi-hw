
function vGT220T8mmBore6mmWidePulleyDatasheet() =
     [["body_diameter", 16], ["body_length", 16], ["bore_diameter", 8], ["belt_width", 6]];

module mGT220T8mmBore6mmWidePulley() {
     import("stl/gt2_20t_b8_w6.stl");
}

mGT220T8mmBore6mmWidePulley();
