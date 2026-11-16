#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;
uniform float u_Ratio;
uniform float u_MaxRadius;

void main(){

    float fDisX = (v_texCoords.x - 0.5) * u_Ratio;
    float fDisY = (v_texCoords.y - 0.5);

    float fBaseRadius = ((fProgress * 1.2) - 0.2) * u_MaxRadius;
    float fRadius = sqrt(fDisX * fDisX + fDisY * fDisY);

    float fMixRatio = clamp((fRadius - fBaseRadius) * 5.0, 0.0, 1.0);

    gl_FragColor = mix(texture2D(u_texture1, v_texCoords), texture2D(u_texture0, v_texCoords), fMixRatio);
}