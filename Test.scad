x = -3;
y = 2;
z = 4;
array=[for (i = [0 : 1 : 4]) i];
h_cylinders = [for (i = [0.2 : 0.2 : 5]) i];
//[for (i = [r0 : dr: rf]) i];

/*for(i=[x:y:z])
    for(j=[x:y:z])
        for(k=[0:1:15])
            {translate([i,j,k*3])
             cylinders(h_cylinders[k]);
                }
*/        
    

for(i=[0:1:4])
    for(j=[0:1:4])
    {translate([i-2, j-2, 0])cylinders(h_cylinders[4*i+j]);}


module cylinders(h) {
    color("blue")
    translate([0,0,0]) cylinder(h = h, r = .5);
    
}
/*for (i = [0:1:15]) {
    translate([i,i,i])
cylinders(h_cylinders[i]);
}*/