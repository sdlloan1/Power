#ifndef HAS_OFFSCREEN_TEXTURE
	#ifdef INPUT_IS_OES_TEXTURE
	#extension GL_OES_EGL_image_external : require
		uniform samplerExternalOES u_texture0;
	#else
		uniform sampler2D u_texture0;
	#endif
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;
uniform sampler2D u_txMask;
uniform sampler2D u_txMask2;
uniform vec4 u_v4FgColor;
uniform float u_Flicker;

varying vec2 v_texCoords;

vec4 f4IntensityConvert = vec4(0.299, 0.587, 0.114, 0.0);

void main(){

    vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4Scratch = texture2D(u_txMask, v_texCoords);
	vec4 v4Dust = texture2D(u_txMask2, v_texCoords);

    vec4 v4Result;
    if(u_v4FgColor.a > 0.0001)
    {
        float fIntensity = dot(v4Src, f4IntensityConvert);
        v4Result = (u_v4FgColor - fIntensity) * u_v4FgColor.a + fIntensity + v4Scratch.r + u_Flicker + v4Dust;
    }
    else
    {
        v4Result = v4Src + v4Scratch.r + u_Flicker + v4Dust;
    }

    gl_FragColor = vec4(v4Result.rgb, v4Src.a);
}
