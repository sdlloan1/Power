#extension GL_OES_EGL_image_external : require
precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform vec2 u_AspectRatio;
uniform vec2 u_Center;

uniform int u_SampleCount[4];
uniform float u_MixRate[4];
uniform float u_AngleTable[80];
uniform vec2 u_RingInfo[4];

varying vec2 v_texCoords;

void main()
{
    vec2 v2TxCoord = (v_texCoords - u_Center) * u_AspectRatio;

    float fLength = length(v2TxCoord);

    int nRingIndex = 0;
    if(fLength > 1.4)
        nRingIndex = 3;
    else if(fLength > 0.85)
        nRingIndex = 2;
    else if(fLength > 0.35)
        nRingIndex = 1;

    float fInverseDirection = u_RingInfo[nRingIndex].x;
    int nTimeIndex = int(u_RingInfo[nRingIndex].y + 0.1);
    int nBaseIndex = nTimeIndex * 20;
    int nCount = u_SampleCount[nTimeIndex];

    vec2 v2TxCoordRotate;
    vec4 v4Result0 = vec4(0.0);
    vec4 v4Result1 = vec4(0.0);

    float fAngle;
    float fSinVal;
    float fCosVal;
    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            fAngle = u_AngleTable[nBaseIndex + index] * fInverseDirection;
            fSinVal = sin(fAngle);
            fCosVal = cos(fAngle);
            v2TxCoordRotate.x = v2TxCoord.x * fCosVal - v2TxCoord.y * fSinVal;
            v2TxCoordRotate.y = v2TxCoord.x * fSinVal + v2TxCoord.y * fCosVal;
            v4Result0 += texture2D(u_texture0, v2TxCoordRotate / u_AspectRatio + u_Center);
        }
        v4Result0 /= float(nCount);
    }

    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            fAngle = u_AngleTable[nBaseIndex + index] * fInverseDirection;
            fSinVal = sin(fAngle);
            fCosVal = cos(fAngle);
            v2TxCoordRotate.x = v2TxCoord.x * fCosVal - v2TxCoord.y * fSinVal;
            v2TxCoordRotate.y = v2TxCoord.x * fSinVal + v2TxCoord.y * fCosVal;
            v4Result1 += texture2D(u_texture1, v2TxCoordRotate / u_AspectRatio + u_Center);
        }
        v4Result1 /= float(nCount);
    }

    gl_FragColor = mix(v4Result0, v4Result1, u_MixRate[nTimeIndex]);
}