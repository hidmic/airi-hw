
function vGT2Pulley20T8mmBore6mmWideDatasheet() =
     [["body_diameter", 16], ["body_length", 16], ["bore_diameter", 8],
      ["belt_width", 6], ["belt_diameter", 12.22], ["base_length", 7.1],
      ["tooth_length", 7.4]];

module mGT2Pulley20T8mmBore6mmWide() {
     import("stl/gt2_20t_b8_w6.stl");
}

mGT2Pulley20T8mmBore6mmWide();
