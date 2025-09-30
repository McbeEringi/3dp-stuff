clamp=function(x,a,b)min(max(x,a),b);
saturate=function(x)clamp(x,0,1);
mix=function(a,b,x)a*(1-x)+b*x;
smoothstep=function(a,b,x)let(x=saturate((x-a)/(b-a)))x*x*(3-2*x);