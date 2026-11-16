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
uniform float u_ArctanOrg;
uniform float u_Tolerance;

varying vec2 v_texCoords;

vec4 v4YUVOffset = vec4(0.062745, 0.5, 0.5, 0.0);

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fAlpha = v4Src.a;
    v4Src.a = 1.0;
    vec4 v4SrcYUV = u_RGB2YUV * v4Src;

    float fArctanCur = atan( v4SrcYUV.g - 0.5, v4SrcYUV.b - 0.5);
	float fLengthCur = sqrt((v4SrcYUV.g - 0.5) * (v4SrcYUV.g - 0.5) + (v4SrcYUV.b - 0.5) * (v4SrcYUV.b - 0.5));

	float fAngleDiff = abs(fArctanCur - u_ArctanOrg);

	if(fAngleDiff > 3.14159265359)
	    fAngleDiff -= 3.14159265359;

	if(fAngleDiff <= u_Tolerance )
	{
        v4SrcYUV.g = u_DstYUV.g;
        v4SrcYUV.b = u_DstYUV.b;
	}

    gl_FragColor = vec4((u_YUV2RGB * (v4SrcYUV - v4YUVOffset)).rgb, fAlpha);
}
