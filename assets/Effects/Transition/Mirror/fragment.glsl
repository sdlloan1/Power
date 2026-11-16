#extension GL_OES_EGL_image_external : require
precision mediump float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_DistortionMask;
uniform sampler2D u_Mask;

varying vec2 v_maskCoords;
varying vec2 v_texCoords;

void main(){

    vec4 v4Distortion = texture2D(u_DistortionMask, v_maskCoords);
    vec4 v4Mask = texture2D(u_Mask, v_maskCoords);
    float fDistortionX = (v4Distortion.r + v4Distortion.g / 256.0) - 0.5;
    float fDistortionY = (v4Distortion.b + v4Distortion.a / 256.0) - 0.5;

    if(v4Mask.r > 0.7)
        gl_FragColor = texture2D(u_texture0, v_texCoords + vec2(fDistortionX, fDistortionY));
    else if(v4Mask.r > 0.2)
        gl_FragColor = texture2D(u_texture0, v_texCoords);
    else
        gl_FragColor = texture2D(u_texture1, v_texCoords);
}