$fa=5;$fs=1;

a=100;
h=120;
r=10;
t=1;

print=1;

module bin(){
	difference(){
		linear_extrude(h)minkowski(){
			square(a-r*2,center=true);
			circle(r);
		}
		translate([0,0,r])minkowski(){
			linear_extrude(h+r)square(a-r*2,center=true);
			sphere(r-t);
		}
		linear_extrude(.4,center=true)scale([.5,-.5])offset(.01)import("lib/icon.svg",center=true);
	}
}

module sep(){
	linear_extrude(1,center=true)difference(){
		minkowski(){
			square([(a-r*2)*sqrt(2),h-r*2+t],center=true);
			circle(r-t);
		}
		translate([-t/2,0])square([t,h]);
	}
}

module main(){
	bin();
	translate([0,0,((h-t)/2+t)*(1-print)]){
		translate([a*1.3*print,0,t/2*print])rotate([ 90*(1-print),0, 45*(1-print)])sep();
		translate([0,a*1.3*print,t/2*print])rotate([-90*(1-print),0,-45*(1-print)])sep();
	}
}
main();