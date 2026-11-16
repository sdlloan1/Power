#extension GL_OES_EGL_image_external : require

precision mediump float;

uniform sampler2D u_texture0;
uniform float u_Alpha;

varying vec2 v_texCoords;

void main(){

    vec4 v4Mask = texture2D(u_texture0, v_texCoords);
    gl_FragColor = vec4(0.0, 0.0, 0.0, v4Mask.r * u_Alpha);
}