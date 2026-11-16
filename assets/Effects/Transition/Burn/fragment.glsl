precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform sampler2D u_masktexture;

uniform float fCompareDegree;
uniform float fCompareRange;

void main(){
	vec4 result;
	
	float progress = fCompareDegree;

	vec4 f4PixelMask = texture2D(u_masktexture, v_texCoords);

	if ( f4PixelMask.x < ( progress - fCompareRange )) {
		result = texture2D(u_texture1, v_texCoords);
	}
	else if ( f4PixelMask.x > progress ) {
		result = texture2D(u_texture0, v_texCoords);
	}
	else {
		float fRatio = ( progress - f4PixelMask.x ) / fCompareRange;
		result.x = 1.0;
		if ( fRatio > 0.5 ) {
			result.y = 0.410 + ( 1.0 - fRatio ) * 1.18;
		}
		else {
			result.y = 0.410 + fRatio * 1.18;
		}
		result.z = 0.0;
		result.w = 1.0;
	}
	gl_FragColor = result;
}