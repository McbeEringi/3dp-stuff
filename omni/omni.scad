$fn=32;
subc=12;
// https://akizukidenshi.com/catalog/g/gM-12917/

//隙間は0.3mm弱縮む
module radial(x,s,n){// x=直径[始端,終端],s=断面[x,y],n=放射数
	for(i=[0:n-1])rotate([0,0,i/n*360])translate([x[0]/2,-s[1]/2,s[0]])rotate([0,90,0])cube([s[0],s[1],(x[1]-x[0])/2]);
}
module ring(x,h){// x=直径[始端,終端],h=高さ
	difference(){cylinder(d=x[1],h=h);cylinder(d=x[0],h=h*2+1,center=true);}
}

module shaft(l=4){
	intersection(){
		cylinder(d=3,h=l,$fn=32);
		translate([.5,0,3])cube([3,3,l+2],center=true);
	}
}
module motor(){
	shaft();
	translate([0,0,-1])cylinder(d=4,h=1);
	translate([-6,-5,-25.25])cube([12,10,24.25]);
}

module sub(){
	ring([2.1,3],3);// hub
	radial([2.5,9],[3,1],3);// spoke
	ring([8,10],3);// wheel
}
module main(){
	difference(){// hub
		cylinder(d=8,h=3);
		union(){
			translate([0,0,-1])scale(1.10)shaft(5);
			translate([2,0,0])cube([8,.5,10],center=true);
		}
	}
	rotate([0,0,180])radial([7,24],[2,2],3);// spoke
	difference(){// wheel
		ring([23,45],3);
		union(){
			// subspace
			for(i=[1:subc])rotate([0,0,i/subc*360])translate([19.7,0,3/2])cube([12,4,50],center=true);
			// subshaft
			rotate_extrude()translate([19.7,3-.7,0])scale(1.16)circle(d=1.75);
		}
	}
	// sub
	%for(i=[1:subc])rotate([0,0,i/subc*360])translate([19.4,3/2,3-.7])rotate([90,0,0])sub();
	%rotate_extrude()translate([19.7,3-.7,0])circle(d=1.75);
}

%motor();
main();
//translate([40,0,0])for(i=[0:subc-1])translate([(floor(i/4)-i%4/2)*12,i%4/2*sqrt(3)*12,0])sub();
for(i=[0:subc-1])translate([cos(i/subc*360)*30,sin(i/subc*360)*30,0])sub();