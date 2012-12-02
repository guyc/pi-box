small = 0.1;
peg_bite  =  1.0;
bite_extra = 0.2;  // extra clearance for edge of board
peg_gap   =  2.0;
peg_width =  5.0;
peg_depth =  3.0;
peg_sep   =  56 - 2;
peg_raise =  4.0;

board_x = 85.0;
board_y = 56.0;
board_z =  1.1;

//   _
//  | \
//  |  \
//  |   \
//  |  /
//  |  |
//  |  o-|  <- origin
//  |    |
//  |    |
//  ------
module peg()
{
  extra = 1;

  translate([0, -peg_depth+peg_bite,-peg_raise])
  {
    cube([peg_width,peg_depth,peg_raise], center=false);
  }

  translate([0, -peg_depth+peg_bite,0])
  {
    cube([peg_width,peg_depth-peg_bite-bite_extra,peg_gap+peg_bite+peg_bite], center=false);
  }

  translate([0,-peg_depth+peg_bite+extra-extra,peg_gap])
  {
    //cube([peg_width,peg_depth-peg_bite-extra,peg_bite+extra], center=false);
  }

  peg_dxy = peg_depth;
  polyhedron(
    points = [
      [0, peg_bite, peg_gap+peg_bite],
      [0, peg_bite-peg_dxy, peg_gap+peg_bite-peg_dxy],
      [0, peg_bite-peg_dxy, peg_gap+peg_bite+peg_dxy],
      [peg_width, peg_bite, peg_gap+peg_bite],
      [peg_width, peg_bite-peg_dxy, peg_gap+peg_bite-peg_dxy],
      [peg_width, peg_bite-peg_dxy, peg_gap+peg_bite+peg_dxy],
    ],
    triangles = [ 
      [0,2,1],  // right
      [3,4,5],  // left
      [0,3,2],  // top
      [2,3,5],
      [1,2,4],  // back
      [4,2,5],
      [0,1,3],  // bottom
      [3,1,4]
    ]
  );
}

module front_peg(x)
{
  translate([x,0,0]) 
  {
    peg();
  }
}

module back_peg(x)
{
  translate([x,board_y,0])
  {
    mirror([0,1,0])
    {
      peg();
    }
  }
}


module board()
{
  color([0,1,0]) {
    cube([board_x,board_y,board_z],center=false);
  }
  // ethernet block
  translate([-1,37.5,board_z]) 
  {
    cube([21,16,14.0]);
    translate([-10.0+small,0,0]) cube([10.0,16,14]);  // clearance volume - keep clear
  }

  // usb block
  translate([0,18,board_z]) 
  {
    translate([-7.5,0,1]) cube([18,14,15]);
    translate([-3,2,0]) cube([13,10,1+small]);
  }

  // hdmi block
  translate([board_x-5.0,44.0,board_z])
  {
    cube([6.0,9.0,4.0]);
    translate([6.0-small,0,0]) cube([10.0,9.0,4.0]);  // clearance volume - keep clear
  }

  // SD Card clearance
  translate([board_x-small,14.0,-3.5])
  {
    cube([17.0+small, 25.0, 3.0]);  // clearance volume - keep clear
  }
}

module pair()
{
  foot_height = 2.0;
  foot_x = peg_width;
  foot_y = board_y + (peg_depth-peg_bite) * 2;
  translate([0,-peg_depth+peg_bite,-peg_raise-foot_height])
  {
    cube([foot_x,foot_y,foot_height],center=false);
  }
}

module pibase()
{
  front_peg(3.0);
  back_peg(3.0);
  front_peg(board_x-peg_width-3.0);
  back_peg(board_x-peg_width-3.0);

  pair();
  translate([board_x-peg_width,0,0])
  {
    pair();
  }

  // more pegs

  front_peg(25.0);
  front_peg(board_x-25.0-peg_width);
  back_peg(25.0);
  back_peg(board_x-25.0-peg_width);


  peg3_offet = 25.0;
  
  
  spar_width = peg_width;
  spar_height = 2.0;
  translate([0,-peg_depth+peg_bite,-peg_raise-spar_height]) {
    cube([board_x, spar_width, spar_height]);
  }
  translate([0,board_y-spar_width+peg_depth-peg_bite,-peg_raise-spar_height]) {
    cube([board_x, spar_width, spar_height]);
  }
}

pibase();
%board();


