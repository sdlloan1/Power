precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform int imode;

void toLeft(vec2 uv){
	//line normal
	vec2 N = vec2(1.0, 0.2);
	
	//radius
	float R = 0.02;
	float invR = 1.0 / R;
	float halfCylinderCircumference = 3.1415926 * R;
	
	//1.2 & 1.15 are magic number, controlling progress
	float dist = (uv.x*N.x+uv.y*N.y+fProgress*1.2-1.15)/sqrt(N.x*N.x+N.y*N.y);
	
	if (dist > 0.0) {
		vec2 p = vec2((1.0-fProgress)+halfCylinderCircumference - N.x * dist, uv.y - N.y * dist);
		
		if (dist <= halfCylinderCircumference) {
			float alpha = dist * invR;
            float sinAlpha = R * sin(alpha);
			float cosAlpha = R * cos(alpha);
            p.x += p.x*sinAlpha;
            
            //0.03 is magic number
            p.y += p.y*cosAlpha+0.03;
			
            if(p.x < 0.0 || p.x > 1.0 || p.y < 0.0 || p.y > 1.0) {
            	gl_FragColor = texture2D(u_texture0, uv);
            }
			else if(dist < halfCylinderCircumference/2.0) {
				
				gl_FragColor = texture2D(u_texture0, p)+(dist/halfCylinderCircumference-0.5)*0.5;
			}
			else {
				gl_FragColor = texture2D(u_texture0, p)+((halfCylinderCircumference-dist)/halfCylinderCircumference-0.5)*0.5;
			}
		}
		else {
			gl_FragColor = texture2D(u_texture1, uv);
		}
	}
	else {
		gl_FragColor = texture2D(u_texture0, uv);
	}
}

void toRight(vec2 uv){
	vec2 N = vec2(1.0, -0.2);
	float R = 0.02;
	float invR = 1.0 / R;
	float halfCylinderCircumference = 3.1415926 * R;
	float diff = (uv.x*N.x+uv.y*N.y-fProgress*1.2+0.15)/sqrt(N.x*N.x+N.y*N.y);
	if (diff < 0.0) {
		diff = abs(diff);
		vec2 p = vec2((fProgress)-halfCylinderCircumference*1.8, uv.y )+ N * diff;
		
		if (diff <= halfCylinderCircumference) {
			float alpha = diff * invR;
            float sinAlpha = R * sin(alpha);
			float cosAlpha = R * cos(alpha);
            p.x -= p.x*sinAlpha;
            p.y += p.y*cosAlpha+0.03;
			
            if(p.x < 0.0 || p.x > 1.0 || p.y < 0.0 || p.y > 1.0) {
            	gl_FragColor = texture2D(u_texture0, uv);
            }
			else if(diff < halfCylinderCircumference/2.0) {
				
				gl_FragColor = texture2D(u_texture0, p)+(diff/halfCylinderCircumference-0.5)*0.5;
			}
			else {
				gl_FragColor = texture2D(u_texture0, p)+((halfCylinderCircumference-diff)/halfCylinderCircumference-0.5)*0.5;
			}
		}
		else {
			gl_FragColor = texture2D(u_texture1, uv);
		}
	}
	else {
		gl_FragColor = texture2D(u_texture0, uv);
	}
}

void main(){
	if(imode == 0){
		toRight(v_texCoords);
	}
	else {
		toLeft(v_texCoords);
	}
}