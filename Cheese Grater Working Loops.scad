/*
Phase Mask Project For Optics Research
Is the 3d model for the phase mask to be printed and tested
*/

/* 
3d printer has these max measurements for printing:
Max printing area is about 1cm x 1.5cm x,y, theoretically no limit on Z-direction. 

Print time ~15min per mm in z. 

When modifing file be sure there is plenty of surface area on bottom to adhere to
glass slide that it is printed on.

When finished, render the file and export as a STL, it is then good to print
*/

/* Parameters to use to change size of the project below, everything defaults to
mm unless scaled otherwise. */

// Scalers
px = 0.0076; // Creates a 7.6um scale for x and y directions
layer = 0.01; // Creates a 10um scale for z direction


// XYZ will change the size of the whole object.
/*
x = 6*px;
y = 6*px;
z = 1*layer;
*/
tempX = 6;
tempY = 6;
tempZ = 1;

holeRadius = .4;
holeStartSize = 0.1;

holeEndSize = (1.3);



/* Changes the hole array module to use more or less
Columns or rows */
holeNumColumns = 5;
holeNumRows = 5;

holeIncreaseSize = holeEndSize / (holeNumColumns * holeNumRows);


array=[for (i = [0 : 1 : 4]) i];

// Controls how the cylinders increase in size by Start: Step size: Ending Size
heightCylinders = [for (i = [holeStartSize : holeIncreaseSize : holeEndSize]) i];

// Creates the bulk material to be subtracted from
module Bulk()
{
    cube([tempX,tempY,tempZ]);
}

module SurroundingMembrane()
{

}

// Creates the array of holes that comprise the mask
module HoleArray()
{
    translate([1,1,-.11]) // Translates the entire array of holes around in xyz
    for (i = [0: 1 : holeNumColumns - 1])
    {
        for(j = [0: 1 : holeNumRows - 1])
        {
            translate([i, j, 0]) Holes(heightCylinders[4*i+j], holeRadius); 
            echo(heightCylinders[holeNumColumns*i+j]);
        }
    }
}

// Creates a single hole of height height and radius radius
module Holes(height, radius)
{
    translate([0,0,0]) cylinder(h = height, r = radius, $fn = 20);
}

// Creates the whole object
module BuildObject()
{
    translate([0,0,0]) // Translates the whole object some distance
    difference()
    {
        Bulk();
        HoleArray();
    }
    
}

BuildObject();




/*
for(i=[0:1:4])
    for(j=[0:1:4])
    {translate([i-2, j-2, 0])cylinders(h_cylinders[4*i+j]);}


module cylinders(h) {
    color("blue")
    translate([0,0,0]) cylinder(h = h, r = .5);
    
}