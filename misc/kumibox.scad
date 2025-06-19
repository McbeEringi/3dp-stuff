// https://akizukidenshi.com/catalog/g/gP-17641/
$fa=6;
$fs=.5;
g=.15;
// use <../Zen Maru Gothic.ttf>
module rcube(w=[10,10,10],r=1){translate([r,r,r])minkowski(){cube([w[0]-r-r,w[1]-r-r,w[2]-r-r]);sphere(r);}}

module panel(){
	translate([-50,-50,-3]){
	difference(){
		scale([1,1,-1])translate([0,0,-3])intersection(){
		rcube([100,100,10],3);
		cube([100,100,3]);
		}
		for(i=[1:4])translate([0,(i)/5*100,0])cube([6+g+g,10+g,10],center=true);
			translate([0,4,0])cube([6+g+g,2+g,10],center=true);
				translate([3+g,0,0])rotate([0,-135,0])cube(3+g);
				translate([0,3+g,0])rotate([135,0,0])cube(3+g);
			translate([0,100-4,0])cube([6+g+g,2+g,10],center=true);
				translate([3+g,100,0])rotate([0,45,180])cube(3+g);
				translate([0,100-3-g,0])rotate([-45,0,0])cube(3+g);

		for(i=[1:4])translate([100,(i)/5*100,0])cube([6+g+g,10+g,10],center=true);
			translate([100,4,0])cube([6+g+g,2+g,10],center=true);
				translate([100-3-g,0,0])rotate([0,45,0])cube(3+g);
				translate([100,3+g,0])rotate([-45,0,180])cube(3+g);
			translate([100,100-4,0])cube([6+g+g,2+g,10],center=true);
				translate([100-3-g,100,0])rotate([0,-135,180])cube(3+g);
				translate([100,100-3-g,0])rotate([135,0,180])cube(3+g);

		for(i=[0:4])translate([(i+.5)/5*100,0,0])cube([10+g,6+g+g,10],center=true);
		for(i=[0:4])translate([(i+.5)/5*100,100,0])cube([10+g,6+g+g,10],center=true);
	}
}
}

module assembled(){
	rotate([0,0,0]){translate([0,0,-50])rotate([180,0,0])panel();translate([0,0,50])panel();}
	rotate([90,90,0]){translate([0,0,-50])rotate([180,0,0])panel();translate([0,0,50])panel();}
	rotate([90,0,90]){translate([0,0,-50])rotate([180,0,0])panel();translate([0,0,50])panel();}
}

module stack(){for(i=[0:5])translate([0,0,3.2*i])panel();}

panel();
