#ifndef HAS_OFFSCREEN_TEXTURE
	#ifdef INPUT_IS_OES_TEXTURE
	#extension GL_OES_EGL_image_external : require
		uniform samplerExternalOES u_texture0;
	#else
		uniform sampler2D u_texture0;
	#endif
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;
varying vec2 v_texCoords;
uniform float u_RegionLeft;
uniform float u_RegionRight;
uniform float u_OrientationAngle;

void main(){
	vec2 v1 = v_texCoords;
	
	if (u_OrientationAngle == 0.25 || u_OrientationAngle == 0.75) {
	    float coorY = v_texCoords.y;
	
		float regionLeft = u_RegionLeft;
		float regionRight = u_RegionRight;
		
		if (u_OrientationAngle == 0.25) {
			regionLeft = 1.0 - u_RegionRight;
			regionRight = 1.0 - u_RegionLeft;
		}
		if (( coorY < regionLeft ) || ( coorY > regionRight ))
		{
			float regionDistance = regionRight - regionLeft; 
			float disY = coorY - regionLeft;
			int quoY = int(floor(disY/regionDistance));
			float fracY = disY - float(quoY) * regionDistance; 
	
			int rem = quoY - ( quoY / 2 ) * 2; 
			if ( 0 == rem )
		    	v1.y = regionLeft + fracY;
			else
				v1.y = regionRight - fracY;
		}
	}
	else {
		float coorX = v_texCoords.x;
	
		if (( coorX < u_RegionLeft ) || ( coorX > u_RegionRight ))
		{
			float regionDistance = u_RegionRight - u_RegionLeft; 
			float disX = coorX - u_RegionLeft;
			int quoX = int(floor(disX/regionDistance));
			float fracX = disX - float(quoX) * regionDistance; 
	
			int rem = quoX - ( quoX / 2 ) * 2; 
			if ( 0 == rem )
		    	v1.x = u_RegionLeft + fracX;
			else
				v1.x = u_RegionRight - fracX;
		}
	}
	
	gl_FragColor = texture2D(u_texture0, v1);
}
