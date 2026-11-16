
#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif


uniform sampler2D u_textureIntensity;
uniform sampler2D u_textureMask;

precision highp float;

uniform float u_Threshold;

varying vec2 v_texCoords;

void main()
{
    float Intensity = texture2D(u_textureIntensity, v_texCoords).r;
    float Mask = texture2D(u_textureMask, v_texCoords).r;

    float relativeDiff = Intensity / Mask;

	if (relativeDiff < 1.0)
	{
        float multiply = (0.025 - min(0.025, (1.0 - relativeDiff))) / 0.025;
        Intensity *= multiply;
	}

    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fVal;

    if(Intensity >= 0.00392156862745)
    {
        float fEUDistance = sqrt(dot(v4Src * v4Src, vec4(1.0, 1.0, 1.0, 0.0)));

        if(fEUDistance < u_Threshold)
            fVal = fEUDistance / u_Threshold * 0.784314;// * 200.0 / 255.0;
        else
            fVal = 1.0;
    }
    else
    {
        fVal = dot(v4Src, vec4(0.16667, 0.16667, 0.16667, 0.0));
    }

    gl_FragColor = vec4(fVal, fVal, fVal, v4Src.a);
}