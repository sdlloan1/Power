#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif

uniform sampler2D u_TextureBlur;
uniform sampler2D u_TextureMask;

precision mediump float;

uniform vec2 u_ChannelShift;

varying vec2 v_texCoords;

void main() {

	float fMask = texture2D(u_TextureMask, v_texCoords).r;
	vec4 v4Blur = texture2D(u_TextureBlur, v_texCoords);
	vec4 v4BlurShift1 = texture2D(u_TextureBlur, v_texCoords - u_ChannelShift * fMask);
	vec4 v4BlurShift2 = texture2D(u_TextureBlur, v_texCoords + u_ChannelShift * fMask);

	gl_FragColor = mix(texture2D(u_texture0, v_texCoords), vec4(v4BlurShift1.r, v4Blur.g, v4BlurShift2.b, v4Blur.a), fMask);

}