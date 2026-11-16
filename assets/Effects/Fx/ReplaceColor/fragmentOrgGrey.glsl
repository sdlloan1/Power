#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform mat4 u_RGB2YUV;
uniform mat4 u_YUV2RGB;

uniform vec4 u_OrgYUV;
uniform vec4 u_DstYUV;
uniform float u_Tolerance;

varying vec2 v_texCoords;

vec4 v4YUVOffset = vec4(0.062745, 0.5, 0.5, 0.0);

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fAlpha = v4Src.a;

    if(u_Tolerance < 0.001)
    {
    	gl_FragColor = v4Src;
    	return;
    }

    v4Src.a = 1.0;
    vec4 v4SrcYUV = u_RGB2YUV * v4Src;

    vec4 v4Diff = abs(u_OrgYUV - v4SrcYUV) - vec4(u_Tolerance, u_Tolerance, u_Tolerance, 0.0);
    if((v4Diff.r > 0.0) || (v4Diff.g > 0.0) || (v4Diff.b > 0.0))
    {
    	gl_FragColor = vec4(v4Src.rgb, fAlpha);
    	return;
    }

    vec4 v4DstYUV = u_DstYUV + ((v4SrcYUV - u_DstYUV) * abs(v4SrcYUV - u_OrgYUV) / u_Tolerance);

    v4DstYUV.r = v4SrcYUV.r;
    v4DstYUV.a = 1.0;

    gl_FragColor = vec4((u_YUV2RGB * (v4DstYUV - v4YUVOffset)).rgb, fAlpha);
}
