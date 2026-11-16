#extension GL_OES_EGL_image_external : require
precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform vec2 u_AspectRatio;
uniform vec2 u_Direction;

uniform int u_SampleCount[4];
uniform vec2 u_Distance[80];

uniform float u_MixRate[4];
uniform vec2 u_RegionInfo[6];

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * u_AspectRatio;

    vec2 v2Direction = u_Direction;

    float fX = v_texCoords.x;
    if(fX > 0.5)
        fX = 1.0 - fX;

    float fDistance = v_texCoords.y - fX * 0.5;

    int nRegionIndex = 5;
    if(fDistance < -0.1)
        nRegionIndex = 0;
    else if(fDistance < 0.2)
        nRegionIndex = 1;
    else if(fDistance < 0.3)
        nRegionIndex = 2;
    else if(fDistance < 0.6)
        nRegionIndex = 3;
    else if(fDistance < 0.75)
        nRegionIndex = 4;

    v2Direction *= u_RegionInfo[nRegionIndex].x;

    int nTimeIndex = int(u_RegionInfo[nRegionIndex].y + 0.1);
    int nBaseIndex = nTimeIndex * 20;
    int nCount = u_SampleCount[nTimeIndex];

    vec2 v2TxCoordOffset;
    vec4 v4Result0 = vec4(0.0);
    vec4 v4Result1 = vec4(0.0);

    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - v2Direction * u_Distance[nBaseIndex + index].x;
            v4Result0 += texture2D(u_texture0, v2TxCoordOffset / u_AspectRatio + vec2(0.5)) * u_Distance[nBaseIndex + index].y;
        }
    }

    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - v2Direction * u_Distance[nBaseIndex + index].x;
            v4Result1 += texture2D(u_texture1, v2TxCoordOffset / u_AspectRatio + vec2(0.5)) * u_Distance[nBaseIndex + index].y;
        }
    }

    gl_FragColor = mix(v4Result0, v4Result1, u_MixRate[nTimeIndex]);
}