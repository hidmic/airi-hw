
function vM3x5mmThreadedInsertDatasheet() =
     [["outer_diameter", 5.3], ["length", 5]];

module mM3x5mmThreadedInsert() {
     import("stl/m3x5mm_threaded_insert.stl");
}

mM3x5mmThreadedInsert();
