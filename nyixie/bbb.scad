$fn = 32;

small = 0.1;
inch = 25.4; 
boardLength = 3.400 * inch;
boardWidth  = 2.150 * inch;
boardHeight  = 1.5;
boardSize = [boardLength, boardWidth, boardHeight];
boardColor = [0.3,0.3,0.3];

ethSize     = [21.0,17.0,13.5];
ethOffset   = [-2.5,21.25,boardHeight+0.8];

usbHostSize     = [14.0,15.5,7.0];
usbHostOffset   = [boardLength-usbHostSize[0],9,boardHeight+0.7];

usbSize         = [7.0,7.8,4.5];
usbOffset       = [-.2,40,-usbSize[2]+0.5];

hdmiSize        = [8.0,8.0,3.5];
hdmiOffset      = [boardLength-hdmiSize[0]+0.5,20.8,-hdmiSize[2]+0.5];

sdSize   = [15.0,14.0,1.6];
sdOffset = [boardLength-sdSize[0],30,-sdSize[2]];

powerSize = [14.0,9.5,11.0];
powerOffset = [-2.5,4.75,boardHeight];

headerSize = [58.6,5.0,8.8];
headerOffset1 = [18.3,0.3,boardHeight];
headerOffset2 = [18.3,boardWidth-0.3-headerSize[1],boardHeight];

clearanceLength = 10;
clearanceColor = [0.5,0.5,0.8,0.4];

holeR = 0.125/2 * inch;
hole1Pos = [0.575 * inch, 0.125 * inch, 0];
hole2Pos = [0.575 * inch, 2.025 * inch, 0];
hole3Pos = [3.175 * inch, 0.250 * inch, 0];
hole4Pos = [3.175 * inch, 1.900 * inch, 0];

module board()
{
  cube([boardLength, boardWidth, boardHeight]);
  translate(headerOffset1) cube(headerSize);
  translate(headerOffset2) cube(headerSize);
}


module cornerNegative(centre, radius, rotation)
{
  translate(centre) {
    rotate([0,0,rotation])
    {
      difference()
      {
        translate([-small,-small,-small/2]) {
          cube([radius+small,radius+small,boardHeight+small]);
        }
        translate([radius,radius,-small]) {
          cylinder(h=boardHeight+small*2,r=radius, center=false);
        }
      }
    }
  }
}

module mountingHole(centre)
{
   translate(centre) {
     translate([0,0,boardHeight/2]) {
       cylinder(r=holeR,h=boardHeight+small,center=true);
     }
   }
}

module ethernetBlock()
{
  translate(ethOffset) 
  {
    cube(ethSize);
    translate([-clearanceLength,0,0]) {
      color(clearanceColor) cube([clearanceLength+small,ethSize[1],ethSize[2]]);
    }
  }
}


module usbHostBlock()
{
  translate(usbHostOffset) 
  {
    cube(usbHostSize);
    translate([usbHostSize[0]-small,0,0]) {
      color(clearanceColor) cube([clearanceLength+small,usbHostSize[1],usbHostSize[2]]);
    }
  }
}

module usbBlock()
{
  translate(usbOffset)
  {
    cube(usbSize);
    translate([-clearanceLength,0,0]) {
      color(clearanceColor) cube([clearanceLength+small,usbSize[1],usbSize[2]]);
    }
  }
}

module sdBlock()
{
  translate(sdOffset)
  {
    cube(sdSize);
    translate([sdSize[0]-small,0,0]) {
      color(clearanceColor) cube([clearanceLength+small,sdSize[1],sdSize[2]]);
    }
  }        
}

module hdmiBlock()
{
  translate(hdmiOffset)
  {
    cube(hdmiSize);
    translate([hdmiSize[0]-small,0,0]) {
      color(clearanceColor) cube([clearanceLength+small,hdmiSize[1],hdmiSize[2]]);
    }

  }
}

module powerBlock()
{
  translate(powerOffset)
  {
    cube(powerSize);
    translate([-clearanceLength,0,0]) {
      color(clearanceColor) cube([clearanceLength+small,powerSize[1],powerSize[2]]);
    }
  }
}

module boardNegative()
{
   cornerNegative([0,0,0], 0.250 * inch, 0);
   cornerNegative([0,boardWidth,0], 0.250 * inch, 270);
   cornerNegative([boardLength,0,0], 0.500 * inch, 90);
   cornerNegative([boardLength,boardWidth,0], 0.500 * inch, 180);
   mountingHole(hole1Pos);
   mountingHole(hole2Pos);
   mountingHole(hole3Pos);
   mountingHole(hole4Pos);
}

module beagleboneblack() 
{
  color(boardColor) {
    render();
    difference() {
      board();
      boardNegative();
    }
  }
  ethernetBlock();
  usbHostBlock();
  usbBlock();
  hdmiBlock();
  sdBlock();
  powerBlock();
}

//beagleboneblack();


