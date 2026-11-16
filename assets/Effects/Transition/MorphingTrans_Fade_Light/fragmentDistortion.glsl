
#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_textureSrc;
uniform float u_Degree;
uniform vec2 u_AspectRatio;

varying vec2 v_texCoords;

void main(){

    gl_FragColor = texture2D(u_textureSrc, v_texCoords);
}