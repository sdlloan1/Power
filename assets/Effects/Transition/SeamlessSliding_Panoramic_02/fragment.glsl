#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform vec2 u_AspectRatio;
uniform vec2 u_MotionDistance;

uniform vec2 u_OffsetProgress;

uniform vec2 u_TexelSize;
uniform int u_SampleCount;
uniform float u_GaussianWeight[31];

uniform vec2 u_Center;
uniform vec2 u_Radius;
uniform float u_Curvature;
uniform vec2 u_CurvatureRadius;

uniform int u_DirectionXY;

uniform float u_MixRate;

varying vec2 v_texCoords;

void main(){
    vec2 v2TxCoord = v_texCoords * u_AspectRatio;
    vec2 v2Center = u_Center * u_AspectRatio;

    vec2 dis = abs(v2TxCoord - v2Center);
    float theta;
    vec2 v2Ratio;
    if(u_DirectionXY == 0) // X
    {
        theta = dis.x * u_Curvature / u_Radius.x;
        v2Ratio = vec2(sin(theta) * u_CurvatureRadius.x / dis.x, cos(theta));
    }
    else
    {
        theta = dis.y * u_Curvature / u_Radius.y;
        v2Ratio = vec2(cos(theta), sin(theta) * u_CurvatureRadius.y / dis.y);
    }

    v2TxCoord = ((v2TxCoord - v2Center) * v2Ratio + v2Center) / u_AspectRatio;

    vec2 v2TxCoordSrc1 = v2TxCoord + u_MotionDistance * u_OffsetProgress.x;
    vec2 v2TxCoordSrc2 = v2TxCoord + u_MotionDistance * u_OffsetProgress.y;

    vec4 v4Src1 = texture2D(u_texture0, v2TxCoordSrc1) * u_GaussianWeight[0];
    vec4 v4Src2 = texture2D(u_texture1, v2TxCoordSrc2) * u_GaussianWeight[0];

    vec2 v2SampleOffset = u_TexelSize;
    for(int index = 1 ; index <= u_SampleCount ; ++index)
    {
        v4Src1 += texture2D(u_texture0, v2TxCoordSrc1 + v2SampleOffset) * u_GaussianWeight[index];
        v4Src1 += texture2D(u_texture0, v2TxCoordSrc1 - v2SampleOffset) * u_GaussianWeight[index];
        v4Src2 += texture2D(u_texture1, v2TxCoordSrc2 + v2SampleOffset) * u_GaussianWeight[index];
        v4Src2 += texture2D(u_texture1, v2TxCoordSrc2 - v2SampleOffset) * u_GaussianWeight[index];
        v2SampleOffset += u_TexelSize;
    }

    gl_FragColor = mix(v4Src1, v4Src2, u_MixRate);
}