#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0;
#endif 

uniform sampler2D u_DistortionMask;

precision highp float;

varying vec2 v_texCoords;
varying vec2 v_MaskCoords1;
varying vec2 v_MaskCoords2;

void main()
{
    vec4 v4TxOffset1 = texture2D(u_DistortionMask, v_MaskCoords1);
    vec4 v4TxOffset2 = texture2D(u_DistortionMask, v_MaskCoords2);

    vec2 v2Offset1 = vec2((v4TxOffset1.r + v4TxOffset1.g / 256.0) - 0.5, (v4TxOffset1.b + v4TxOffset1.a / 256.0) - 0.5);
    vec2 v2Offset2 = vec2((v4TxOffset2.r + v4TxOffset2.g / 256.0) - 0.5, (v4TxOffset2.b + v4TxOffset2.a / 256.0) - 0.5);

	gl_FragColor = texture2D(u_texture0, v_texCoords + v2Offset1 + v2Offset2);
}