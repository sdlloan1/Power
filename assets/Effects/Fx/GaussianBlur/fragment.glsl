
#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureBlur;
uniform sampler2D u_textureMask;

precision mediump float;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec4 v4Blur = texture2D(u_textureBlur, v_texCoords);
    float fMask = texture2D(u_textureMask, v_texCoords).a;

	gl_FragColor = vec4(mix(v4Src, v4Blur, fMask).rgb, v4Src.a);
}
