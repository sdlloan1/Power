
#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_textureSrc;
uniform float u_Degree;
uniform vec2 u_AspectRatio;

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * u_AspectRatio;

    float fDistance = length(v2TxCoord);
    float fRatio = sin(fDistance * 15.0 - 1.5707963268) * u_Degree / fDistance + 1.0;
    v2TxCoord = v2TxCoord * fRatio;

    gl_FragColor = texture2D(u_textureSrc, v2TxCoord / u_AspectRatio + vec2(0.5));
}