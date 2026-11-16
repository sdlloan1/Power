#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureIntensity;
uniform sampler2D u_textureMask;

precision mediump float;

varying vec2 v_texCoords;

void main()
{
    float Intensity = texture2D(u_textureIntensity, v_texCoords).r;
    float Mask = texture2D(u_textureMask, v_texCoords).r;
    float Alpha = texture2D(u_texture0, v_texCoords).a;

    float relativeDiff = Intensity / Mask;

	if (relativeDiff < 1.01)
	{
        float multiply = (0.025 - min(0.025, (1.01 - relativeDiff))) / 0.025;
        Intensity *= multiply;
	}

    if(Intensity >= 0.00392156862745)
        gl_FragColor = vec4(1.0, 1.0, 1.0, Alpha);
    else
        gl_FragColor = vec4(0.0, 0.0, 0.0, Alpha);
}