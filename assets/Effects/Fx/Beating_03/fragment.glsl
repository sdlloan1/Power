#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform float u_TrailOpacity;
uniform float u_TrailScale;

varying vec2 v_texCoords;

void main(void)
{
	vec2 v2CoordScale = ((v_texCoords - vec2(0.5)) * u_TrailScale) + vec2(0.5);

	gl_FragColor = mix(texture2D(u_texture0, v_texCoords), texture2D(u_texture0, v2CoordScale), u_TrailOpacity);
}
