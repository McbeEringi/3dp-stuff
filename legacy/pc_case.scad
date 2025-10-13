module kanawa(){
	linear_extrude(21){polygon([[0,0],[0,45],[10-4,45],[10-4,50],[10,50],[10+2,25+3],[10-2,25+3],[10-2,25-3],[10,.0001],[10+4,.0001],[10+4,5],[20,5],[20,0],[0,0]]);}
}

module main(){

difference(){
	union(){
		cube([340,20,20]);
		translate([0,86,0])cube([20,20,20]);
		translate([0,10,0])cube([20,86,20]);
		translate([20-20/sqrt(2),86+20-20/sqrt(2),0])rotate(-45)cube([86*sqrt(2),20,20]);
	}
	translate([3,3,0])cube([5,5,100]);
	translate([3,86+10+5-3,0])cube([5,5,100]);
	translate([220,3,0])cube([5,5,100]);

	translate([10,10,15])cube([150,86,140]);
	translate([170,25,0])union(){
		cube([170,10,170]);
		translate([170-6,0,6])rotate([90,0,0])cylinder(d=4,h=100,center=true);
	}
}
}
scale([1,-1,1])print();

module print(){
intersection(){
	main();union(){
cube(150);
translate([150,0,0])rotate([0,0,-90])scale([-1,1,1])kanawa();}
}

translate([-150,-30,0])intersection(){
	main();union(){
	translate([200,0,0])cube(150);
	translate([200,20,20])rotate([180,0,-90])scale(1)kanawa();}
}
}