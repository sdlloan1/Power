#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureMask;

precision mediump float;
uniform float u_Degree;
uniform highp float u_TexelWidth;
uniform highp float u_TexelHeight;
varying vec2 v_texCoords;

void main()
{
	vec4 f4Center = texture2D(u_texture0, v_texCoords);
	vec4 f4Up = texture2D(u_texture0, v_texCoords + vec2(0.0, -u_TexelHeight)) * -u_Degree;
	vec4 f4Down = texture2D(u_texture0, v_texCoords + vec2(0.0, u_TexelHeight)) * -u_Degree;
	vec4 f4Left = texture2D(u_texture0, v_texCoords + vec2(-u_TexelWidth, 0.0)) * -u_Degree;
	vec4 f4Right = texture2D(u_texture0, v_texCoords + vec2(u_TexelWidth, 0.0)) * -u_Degree;

	vec4 f4Result = f4Center * ((u_Degree * 4.0) + 1.0);

    gl_FragColor = vec4(mix(f4Center, (f4Result + f4Up + f4Down + f4Left + f4Right), texture2D(u_textureMask, v_texCoords).a).rgb, f4Result.a);
}