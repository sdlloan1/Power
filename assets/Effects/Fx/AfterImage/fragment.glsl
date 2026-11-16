
#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif

uniform sampler2D u_textureBlur;

precision mediump float;

uniform float u_Saturation;
uniform float u_TrailScale1;
uniform float u_TrailScale2;

varying vec2 v_texCoords;

void main() {

	vec2 v2Trail1 = vec2((v_texCoords.x - 1.0) * u_TrailScale1 + 1.0, v_texCoords.y);
	vec2 v2Trail2 = vec2(v_texCoords.x * u_TrailScale2, v_texCoords.y);

	vec4 v4Res = texture2D(u_texture0, v_texCoords) * 0.4 + texture2D(u_texture0, v2Trail1) * 0.3 + texture2D(u_texture0, v2Trail2) * 0.3;
	vec4 v4ResBlur = texture2D(u_textureBlur, v_texCoords) * 0.4 + texture2D(u_textureBlur, v2Trail1) * 0.3 + texture2D(u_textureBlur, v2Trail2) * 0.3;
	vec4 v4ResMix = v4Res * 0.5 + v4ResBlur * 1.0;

	float fGray = dot(v4ResMix, vec4(0.299, 0.587, 0.114, 0.0));

	gl_FragColor = mix(vec4(fGray), v4ResMix, u_Saturation);
}