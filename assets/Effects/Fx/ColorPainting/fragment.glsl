
#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureSrc;
uniform sampler2D u_textureEdge;

precision mediump float;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_textureSrc, v_texCoords);
    vec4 v4Edge = texture2D(u_textureEdge, v_texCoords);

    if(v4Src.r <= 0.5)
        v4Src.r = v4Src.r * v4Edge.r * 2.0;
    else
        v4Src.r = 1.0 - (2.0 * (1.0 - v4Src.r) * (1.0 - v4Edge.r));

    if(v4Src.g <= 0.5)
        v4Src.g = v4Src.g * v4Edge.g * 2.0;
    else
        v4Src.g = 1.0 - (2.0 * (1.0 - v4Src.g) * (1.0 - v4Edge.g));

    if(v4Src.b <= 0.5)
        v4Src.b = v4Src.b * v4Edge.b * 2.0;
    else
        v4Src.b = 1.0 - (2.0 * (1.0 - v4Src.b) * (1.0 - v4Edge.b));

	gl_FragColor = vec4(v4Src.rgb, texture2D(u_texture0, v_texCoords).a);
}