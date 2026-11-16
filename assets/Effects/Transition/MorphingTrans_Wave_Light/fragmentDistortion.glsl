
#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_textureSrc;
uniform float u_Degree;
uniform vec2 u_AspectRatio;

varying vec2 v_texCoords;

void main(){

    float fOffsetX = (cos(v_texCoords.y * 11.0) + cos(v_texCoords.y * 6.28) * 0.3) * u_Degree;
    float fOffsetY = (sin(v_texCoords.x * 12.0) + sin(v_texCoords.x * 6.28) * 0.3) * u_Degree;

    gl_FragColor = texture2D(u_textureSrc, v_texCoords + vec2(fOffsetX, fOffsetY));
}