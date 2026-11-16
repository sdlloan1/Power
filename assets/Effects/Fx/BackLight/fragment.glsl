#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureLight;

precision mediump float;

uniform vec4 u_LightColor;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fLight = texture2D(u_textureLight, v_texCoords).r;

    float fOrgAlpha = dot(v4Src, vec4(0.333333, 0.333333, 0.333333, 0.0));

	gl_FragColor = vec4((v4Src + (u_LightColor * fLight * (1.0 - fOrgAlpha))).rgb, v4Src.a);
}