
#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_textureSrc;
uniform float u_Degree;
uniform vec2 u_AspectRatio;

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * u_AspectRatio;
    v2TxCoord = v2TxCoord * (1.0 - u_Degree);

    gl_FragColor = texture2D(u_textureSrc, v2TxCoord / u_AspectRatio + vec2(0.5));
}