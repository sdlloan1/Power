#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform vec4 u_ColorAdjustment;

varying vec2 v_texCoords;

void main()
{
	// Return order -- float4(B, G, R, A)
	// f4.x = R , f4.y = G , f4.z = B , f4.w = A

	vec4 f4Src = texture2D(u_texture0, v_texCoords);

	vec4 f4Result = f4Src + u_ColorAdjustment;

    if(u_ColorAdjustment.a > 0.5)
    {
        f4Result = max(min(f4Result, vec4(1.0, 1.0, 1.0, 1.0)), vec4(0.0, 0.0, 0.0, 0.0));
        float fGrey = dot(f4Result, vec4(0.333333, 0.333333, 0.333333, 0.0));

    	gl_FragColor = vec4(fGrey, fGrey, fGrey, f4Src.a);
    }
    else
    	gl_FragColor = vec4(f4Result.rgb, f4Src.a);
}