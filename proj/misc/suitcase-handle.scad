$fa=5;$fs=.5;

print=true;

d=134;

w1=12;
w2=5;
h=22;
zh=32;
t=1;

hole1=zh-15.7;
hole2=zh-25.7;

notch_d=16;
notch_zr=12;

pind=3.1;
pinz_up=33.5;
pinz_down=28;
pin_travel=pinz_up-pinz_down;
btnw=20;

pinplate_h=8;
gap=.3;

spring_t=1;
spring_r=50;


module pipebb(){
	difference(){
	linear_extrude(zh)polygon([
			[-w1/2-t,-h/2-t],
			[w1/2+t,-h/2-t],
			[w2/2+t,h/2+t],
			[-w2/2-t,h/2+t]
		]);
		translate([0,0,zh])rotate([0,90,180])linear_extrude(w1/2+t)scale([2*notch_zr/notch_d,1])circle(d=notch_d);
	}
}
module joiner(){
	difference(){
		linear_extrude(zh)polygon([
			[-w1/2,-h/2],
			[-w1/4,-h/2+.5],
			[w1/4,-h/2+.5],
			[w1/2,-h/2],
			[w2/2,h/2],
			[-w2/2,h/2]
		]);
		translate([0,0,hole1])rotate([90,0,0])cylinder(d=2.9,h=h/2);
		translate([0,0,hole2])rotate([90,0,0])cylinder(d=2.9,h=h/2);
	}
}

module half(inv){
	difference(){
		union(){
			translate([d/2,0,0])joiner();
			//notch
			//translate([0,0,zh])rotate([0,90,0])linear_extrude(d/2)scale([2*notch_zr/notch_d,1])circle(d=notch_d);
			//grip
			difference(){
				translate([0,0,zh])rotate([0,90,0])linear_extrude(d/2)circle(d=h+t*2);
				translate([d/2,0,0])pipebb();
			}
			//grip cap
			intersection(){
				translate([d/2,0,zh])rotate([0,90,0])linear_extrude(w1/2+t){
					circle(d=h+t*2);
				}
				translate([d/2,0,zh])pipebb();
			}
		}
		//pinhole
		translate([d/2,0,0])cylinder(d=pind,h=pinz_up);
		//btn key
		translate([0,0,zh])linear_extrude(h/2+t)square([btnw,pind+gap],center=true);
		//btn notch
		translate([0,0,zh+h/2+t])rotate([90,0,0])linear_extrude(h+t*2,center=true)scale([1,2*(pin_travel+1)/btnw])circle(d=btnw);
		
		translate([0,0,pinz_up]){
			linear_extrude(pinplate_h)square([d+pind+gap,pind+gap],center=true);
			scale([1,1,-1])linear_extrude(pin_travel)square([d+pind+gap,pind+gap],center=true);
		}
		//insert window
		if(!inv)translate([0,0,pinz_down]){
			linear_extrude(zh+h/2+t-pinz_up+gap)square([d*2,pind+gap],center=true);
		}
	}
}

module main(){
	difference(){
		half();
		if(!print)cube(d);
	}
	scale([-1,1,1])half(1);
}

module pinplate_half(){
	difference(){
		square([(d+pind)/2,pinplate_h]);
		square([(d-pind)/2,spring_t]);
	}
	intersection(){
		translate([0,spring_t])scale([1,-1])square([(d-pind)/2,pin_travel+spring_t]);
		translate([(d-pind)/2,-spring_r])difference(){
			circle(r=spring_r+spring_t);
			circle(r=spring_r);
		}
	}
}
module pinplate(){
	linear_extrude(pind,center=true){
		pinplate_half();scale([-1,1])pinplate_half();
		translate([-(btnw-gap)/2,pinplate_h])square([btnw-gap,zh+h/2+t-pinz_up-pinplate_h]);
	}

}

if(print){
	rotate([90,0,0])main();
	translate([0,pin_travel,0])pinplate();
}else{
	main();
	translate([0,0,pinz_up])rotate([90,0,0])pinplate();
}