#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform vec2 u_AspectRatio;
uniform vec2 u_RotationAngle;
uniform vec2 u_RotationCenter;

uniform float u_SampleAngleStep;
uniform int u_SampleCount;
uniform float u_GaussianWeight[31];

uniform vec2 u_FishEyeCenter;
uniform float u_Radius;
uniform float u_Curvature;
uniform float u_CurvatureRadius;

uniform float u_MixRate;

varying vec2 v_texCoords;

void main(){
    vec2 v2TxCoord = v_texCoords * u_AspectRatio;
    vec2 v2FishEyeCenter = u_FishEyeCenter * u_AspectRatio;
    vec2 v2RotationCenter = u_RotationCenter * u_AspectRatio;

    float dis = distance(v2TxCoord, v2FishEyeCenter);
    if(dis <= u_Radius)
    {
        float ratio = dis / (sin(dis * u_Curvature / u_Radius) * u_CurvatureRadius);
        v2TxCoord = ((v2TxCoord - v2FishEyeCenter) * ratio + v2FishEyeCenter);
    }

    v2TxCoord -= v2RotationCenter;

    vec2 v2TxCoordSrc1;
    vec2 v2TxCoordSrc2;
    v2TxCoordSrc1.x = v2TxCoord.x * cos(u_RotationAngle.x) - v2TxCoord.y * sin(u_RotationAngle.x);
    v2TxCoordSrc1.y = v2TxCoord.x * sin(u_RotationAngle.x) + v2TxCoord.y * cos(u_RotationAngle.x);

    v2TxCoordSrc2.x = v2TxCoord.x * cos(u_RotationAngle.y) - v2TxCoord.y * sin(u_RotationAngle.y);
    v2TxCoordSrc2.y = v2TxCoord.x * sin(u_RotationAngle.y) + v2TxCoord.y * cos(u_RotationAngle.y);

    vec4 v4Src1 = texture2D(u_texture0, (v2TxCoordSrc1 + v2RotationCenter) / u_AspectRatio) * u_GaussianWeight[0];
    vec4 v4Src2 = texture2D(u_texture1, (v2TxCoordSrc2 + v2RotationCenter) / u_AspectRatio) * u_GaussianWeight[0];

    float sampleAngleOffset = u_SampleAngleStep;
    for(int index = 1 ; index <= u_SampleCount ; ++index)
    {
        v2TxCoordSrc1.x = v2TxCoord.x * cos(u_RotationAngle.x + sampleAngleOffset) - v2TxCoord.y * sin(u_RotationAngle.x + sampleAngleOffset);
        v2TxCoordSrc1.y = v2TxCoord.x * sin(u_RotationAngle.x + sampleAngleOffset) + v2TxCoord.y * cos(u_RotationAngle.x + sampleAngleOffset);
        v4Src1 += texture2D(u_texture0, (v2TxCoordSrc1 + v2RotationCenter) / u_AspectRatio) * u_GaussianWeight[index];

        v2TxCoordSrc1.x = v2TxCoord.x * cos(u_RotationAngle.x - sampleAngleOffset) - v2TxCoord.y * sin(u_RotationAngle.x - sampleAngleOffset);
        v2TxCoordSrc1.y = v2TxCoord.x * sin(u_RotationAngle.x - sampleAngleOffset) + v2TxCoord.y * cos(u_RotationAngle.x - sampleAngleOffset);
        v4Src1 += texture2D(u_texture0, (v2TxCoordSrc1 + v2RotationCenter) / u_AspectRatio) * u_GaussianWeight[index];

        v2TxCoordSrc2.x = v2TxCoord.x * cos(u_RotationAngle.y + sampleAngleOffset) - v2TxCoord.y * sin(u_RotationAngle.y + sampleAngleOffset);
        v2TxCoordSrc2.y = v2TxCoord.x * sin(u_RotationAngle.y + sampleAngleOffset) + v2TxCoord.y * cos(u_RotationAngle.y + sampleAngleOffset);
        v4Src2 += texture2D(u_texture1, (v2TxCoordSrc2 + v2RotationCenter) / u_AspectRatio) * u_GaussianWeight[index];

        v2TxCoordSrc2.x = v2TxCoord.x * cos(u_RotationAngle.y - sampleAngleOffset) - v2TxCoord.y * sin(u_RotationAngle.y - sampleAngleOffset);
        v2TxCoordSrc2.y = v2TxCoord.x * sin(u_RotationAngle.y - sampleAngleOffset) + v2TxCoord.y * cos(u_RotationAngle.y - sampleAngleOffset);
        v4Src2 += texture2D(u_texture1, (v2TxCoordSrc2 + v2RotationCenter) / u_AspectRatio) * u_GaussianWeight[index];

        sampleAngleOffset += u_SampleAngleStep;
    }

    gl_FragColor = mix(v4Src1, v4Src2, u_MixRate);

//    vec2 v2TxCoord = v_texCoords * u_AspectRatio;
//    vec2 t_Center = u_AspectRatio * 0.5;
//    float t_Radius = 0.5;
//    float t_CurveRadius = t_Radius;
//
//    float dis = distance(v2TxCoord, t_Center);
//    float theta = asin(dis / t_CurveRadius);
//
//    float ratio = theta * t_Radius * 2.0 / (dis * 3.14159265359);
//    v2TxCoord = (v2TxCoord - t_Center) * ratio + t_Center;
//
//    vec4 v4Tmp = texture2D(u_texture0, v2TxCoord / u_AspectRatio);
//    vec2 v2TxCoordOffset;
//    vec4 v4Result0 = vec4(0.0);
//    vec4 v4Result1 = vec4(0.0);
//
//    {
//        for(int index = 0 ; index < u_SampleCount ; ++index)
//        {
//            v2TxCoordOffset = v2TxCoord - u_Direction * u_Distance[index].x;
//            v4Result0 += texture2D(u_texture0, v2TxCoordOffset / u_AspectRatio) * u_Distance[index].y;
//        }
//    }
//
//    {
//        for(int index = 0 ; index < u_SampleCount ; ++index)
//        {
//            v2TxCoordOffset = v2TxCoord - u_Direction * u_Distance[index].x;
//            v4Result1 += texture2D(u_texture1, v2TxCoordOffset / u_AspectRatio) * u_Distance[index].y;
//        }
//    }
//
//    gl_FragColor = mix(v4Result0, v4Result1, u_MixRate);
}