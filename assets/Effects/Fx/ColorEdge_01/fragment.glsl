#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureEdge;

precision mediump float;

uniform float u_Opacity;
uniform float u_Scale;
uniform vec2 u_Offset;
uniform vec2 u_ChannelShift;

varying vec2 v_texCoords;

void main(void)
{
	vec2 v2EdgeCoord = (v_texCoords - vec2(0.5)) * u_Scale + vec2(0.5);
	vec4 v4ColorEdge = vec4(texture2D(u_textureEdge, v2EdgeCoord - (u_Offset + u_ChannelShift)).r,
							texture2D(u_textureEdge, v2EdgeCoord - u_Offset).g,
							texture2D(u_textureEdge, v2EdgeCoord - (u_Offset - u_ChannelShift)).b,
							0.0);
	gl_FragColor = texture2D(u_texture0, v_texCoords) + v4ColorEdge * u_Opacity;
}
