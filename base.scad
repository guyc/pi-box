use <pibase.scad>

small = 0.1;

board_x = 85.0;
board_y = 56.0;

clearance = 0.4;
base_thickness = 0.7;
base_x = board_x + base_thickness*2 + clearance*2;
base_y = 70.0;
base_height = 15.0;

board_dx = base_thickness + clearance;
board_dy = (base_y-board_y)/2 + base_thickness + clearance;
board_dz = 4.0+2.0;

module base_volume()
{
  cube([base_x,base_y,base_height]);
}

module wall(length)
{
  cube([length, base_thickness, base_height]);
}

module floor()
{
  width = 7.0;
  difference() {
    cube([base_x, base_y, base_thickness]);
    translate([width,width,-small]) {
      cube([base_x-width*2, base_y-width*2, base_thickness+small*2]);
    }
  }
}

module walls()
{
  wall(base_x);        
  rotate([0,0,180]) {
    translate([-base_x,-base_y,0]) {
      wall(base_x);
    }
  }
  rotate([0,0,90]) {
    translate([0,-base_x,0]) {
      wall(base_y);
    }
  }
  rotate([0,0,270]) {
    translate([-base_y,0,0]) {
      wall(base_y);
    }
  }
}

module base()
{
  translate([board_dx,board_dy,board_dz]) pibase();
  floor();
  difference() 
  {
    walls();
    translate([board_dx,board_dy,board_dz]) board();
  }
}

translate([board_dx, board_dy, board_dz]) %board();
base();
//%base_volume();
