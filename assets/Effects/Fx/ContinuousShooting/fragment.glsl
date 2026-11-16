uniform sampler2D u_texture0; 

precision mediump float;
varying vec2 v_texCoords;

void main(void)
{
	// Return order -- float4(B, G, R, A)
	// f4.x = R , f4.y = G , f4.z = B , f4.w = A

	gl_FragColor = texture2D(u_texture0, v_texCoords);
}