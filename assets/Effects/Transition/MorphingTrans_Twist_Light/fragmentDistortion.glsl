
#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_textureSrc;
uniform float u_Degree;
uniform vec2 u_AspectRatio;

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * u_AspectRatio;
    float fTheta = u_Degree * (sin(length(v2TxCoord) / length(u_AspectRatio) * 15.0 - 1.5707963268) + 1.0);
    float fSin = sin(fTheta);
    float fCos = cos(fTheta);

    vec2 v2TxCoordDistortion = vec2(v2TxCoord.x * fCos - v2TxCoord.y * fSin, v2TxCoord.x * fSin + v2TxCoord.y * fCos);

    gl_FragColor = texture2D(u_textureSrc, v2TxCoordDistortion / u_AspectRatio + vec2(0.5));
}