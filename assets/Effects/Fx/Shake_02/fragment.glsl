#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision highp float;

uniform vec2 u_Offset;
uniform vec2 u_ChannelShift;

varying vec2 v_texCoords;

void main(void)
{
	vec4 v4Src = texture2D(u_texture0, v_texCoords - u_Offset);
	vec4 v4SrcShift1 = texture2D(u_texture0, v_texCoords - (u_Offset - u_ChannelShift));
	vec4 v4SrcShift2 = texture2D(u_texture0, v_texCoords - (u_Offset + u_ChannelShift));

	gl_FragColor = vec4(v4SrcShift1.r, v4Src.g, v4SrcShift2.b, v4Src.a);
}