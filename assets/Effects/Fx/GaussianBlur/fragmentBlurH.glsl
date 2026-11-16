#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

precision highp float;

uniform vec2 u_TexelSize;
uniform int u_Radius;
uniform float u_GaussianWeight[31];

varying vec2 v_texCoords;

void main(void)
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);

	vec4 sum = v4Src * u_GaussianWeight[0];
	vec2 v2texCoordOffset = u_TexelSize;

    for(int index = 1 ; index <= u_Radius ; ++index)
    {
    	sum += texture2D(u_texture0, v_texCoords + v2texCoordOffset) * u_GaussianWeight[index];
    	sum += texture2D(u_texture0, v_texCoords - v2texCoordOffset) * u_GaussianWeight[index];
    	v2texCoordOffset += u_TexelSize;
    }

	gl_FragColor = vec4(sum.rgb, v4Src.a);
}