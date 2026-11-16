#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureMask;

precision mediump float;

uniform vec4 u_v4RGBAdjust;
uniform vec4 u_v4TintAdjust;
uniform int u_Compare;

varying vec2 v_texCoords;

void main()
{
	vec4 f4Src = texture2D(u_texture0, v_texCoords);

    if((u_Compare > 0) && (v_texCoords.x < 0.5))
       	gl_FragColor = f4Src;
    else
    {
        float fMask = texture2D(u_textureMask, v_texCoords).a;

        // Y = int(0.257f * R + 0.504f * G + 0.098f * B + 16);
		float fIntensity = dot(f4Src, vec4(0.257, 0.504, 0.098, 0.0)) + 0.062745;
		if(fIntensity > 0.78431372549) // 200
		{
            vec4 f4Temp = (((1.0 - fIntensity) * f4Src * u_v4RGBAdjust) + ((fIntensity - 0.78431372549) * f4Src)) / 0.2156862745;
            vec4 f4Result = (((1.0 - fIntensity) * f4Temp * u_v4TintAdjust) + ((fIntensity - 0.78431372549) * f4Temp)) / 0.2156862745;
            gl_FragColor = min(vec4(mix(f4Src, f4Result, fMask).rgb, f4Src.a), 1.0);
    	}
		else
		{
            vec4 f4Result = f4Src * u_v4RGBAdjust * u_v4TintAdjust;
            gl_FragColor = min(vec4(mix(f4Src, f4Result, fMask).rgb, f4Src.a), 1.0);
		}
    }
}