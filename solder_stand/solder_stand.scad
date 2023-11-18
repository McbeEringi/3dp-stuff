$fa=6;
$fs=.5;

module spacer()difference(){
	circle(d=15);
	circle(d=3.5);
}


module stand(a=50,d=5)difference(){
    minkowski(){
        circle(d=a,$fn=3);
        circle(d=d);
    }
    circle(d=a-2*d,$fn=3);
    for(i=[0:2])rotate(i*120)translate([a/2,0,0])rotate(60){
        circle(d=2.6);
        translate([0,-5])square([0.5,10]);
    }
}
    

module print(){
	linear_extrude(3){spacer();stand();translate([-10,0])square([8,.2]);}
}
print();