include <generic/lib.scad>;

module mM8x50mmThreadedStud() {
     color("silver") {
          resize([50, 0, 0], auto=true) {
               import_mesh("stl/m8x50mm_threaded_stud.stl");
          }
     }
}


mM8x50mmThreadedStud();
