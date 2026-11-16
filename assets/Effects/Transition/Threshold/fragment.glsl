#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;

void main(){
	// Return order -- float4(R, G, B, A)
	// f4.x = R , f4.y = G , f4.z = B , f4.w = A

	vec4 f4PixelA = texture2D(u_texture0, v_texCoords);

	if (( f4PixelA.x + f4PixelA.y + f4PixelA.z ) >= ( fProgress * 3.0 )) {
		gl_FragColor = f4PixelA;
	}
	else {
		gl_FragColor = texture2D(u_texture1, v_texCoords);
	}
}
