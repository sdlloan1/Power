#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_textureFrameMask;
uniform vec4 u_FrameColor;
uniform vec2 u_FrameSize;
uniform float fProgress;
uniform int u_FlipSrc2;
uniform vec2 u_BlurDistance;

uniform float u_Offset[3];
uniform vec2 u_Direction;
uniform float u_SubDirection[3];
uniform float u_Scale;

varying vec2 v_texCoords;

void main(){

    vec2 v2CoordRotate = (v_texCoords - vec2(0.5)) * 2.5 + vec2(0.5);

    int rowIndex = int(mod(floor(((v2CoordRotate.x * u_Direction.y + v2CoordRotate.y * u_Direction.x) - 0.5) / u_Scale + 0.5) + 1.0, 3.0));
    float fOffset = u_Offset[rowIndex];
    float fSubDirection = u_SubDirection[rowIndex];

    vec2 v2Center = vec2(0.5, 0.5) - u_Direction * (fOffset * fSubDirection);
    vec2 v2TxCoord = (v2CoordRotate - (u_Direction * (fOffset * fSubDirection)) - v2Center) / u_Scale + v2Center;
    float fIndex = floor(dot(v2TxCoord, u_Direction));
    vec2 v2TexLocal = fract(v2TxCoord + vec2(5.0));

    vec2 v2txCoordFrame = vec2(0.5);
    if(v2TexLocal.x < u_FrameSize.x)
        v2txCoordFrame.x = v2TexLocal.x / u_FrameSize.x * 0.5;
    else if(v2TexLocal.x > (1.0 - u_FrameSize.x))
        v2txCoordFrame.x = (v2TexLocal.x - 1.0 + u_FrameSize.x) / u_FrameSize.x * 0.5 + 0.5;

    if(v2TexLocal.y < u_FrameSize.y)
        v2txCoordFrame.y = v2TexLocal.y / u_FrameSize.y * 0.5;
    else if(v2TexLocal.y > (1.0 - u_FrameSize.y))
        v2txCoordFrame.y = (v2TexLocal.y - 1.0 + u_FrameSize.y) / u_FrameSize.y * 0.5 + 0.5;

	vec4 v4FrameColor = vec4(u_FrameColor.rgb, u_FrameColor.a * texture2D(u_textureFrameMask, v2txCoordFrame).a);

    if(abs(fIndex) < 3.0)
    {
    	vec4 v4Res = texture2D(u_texture0, v2TexLocal);
    	vec2 v2Offset = u_BlurDistance;
        v4Res += texture2D(u_texture0, v2TexLocal + v2Offset);
        v4Res += texture2D(u_texture0, v2TexLocal - v2Offset);
        v2Offset += u_BlurDistance;
        v4Res += texture2D(u_texture0, v2TexLocal + v2Offset);
        v4Res += texture2D(u_texture0, v2TexLocal - v2Offset);
        v2Offset += u_BlurDistance;
        v4Res += texture2D(u_texture0, v2TexLocal + v2Offset);
        v4Res += texture2D(u_texture0, v2TexLocal - v2Offset);
    	gl_FragColor = mix(v4Res * 0.142857142857, v4FrameColor, v4FrameColor.a);
    }
   	else if(u_FlipSrc2 > 0)
    {
        vec2 v2TexFlip = vec2(1.0 - v2TexLocal.x, 1.0 - v2TexLocal.y);
    	vec4 v4Res = texture2D(u_texture1, v2TexFlip);
    	vec2 v2Offset = u_BlurDistance;
        v4Res += texture2D(u_texture1, v2TexFlip + v2Offset);
        v4Res += texture2D(u_texture1, v2TexFlip - v2Offset);
        v2Offset += u_BlurDistance;
        v4Res += texture2D(u_texture1, v2TexFlip + v2Offset);
        v4Res += texture2D(u_texture1, v2TexFlip - v2Offset);
        v2Offset += u_BlurDistance;
        v4Res += texture2D(u_texture1, v2TexFlip + v2Offset);
        v4Res += texture2D(u_texture1, v2TexFlip - v2Offset);

    	gl_FragColor = mix(v4Res * 0.142857142857, v4FrameColor, v4FrameColor.a);
    }
   	else
    {
    	vec4 v4Res = texture2D(u_texture1, v2TexLocal);
    	vec2 v2Offset = u_BlurDistance;
        v4Res += texture2D(u_texture1, v2TexLocal + v2Offset);
        v4Res += texture2D(u_texture1, v2TexLocal - v2Offset);
        v2Offset += u_BlurDistance;
        v4Res += texture2D(u_texture1, v2TexLocal + v2Offset);
        v4Res += texture2D(u_texture1, v2TexLocal - v2Offset);
        v2Offset += u_BlurDistance;
        v4Res += texture2D(u_texture1, v2TexLocal + v2Offset);
        v4Res += texture2D(u_texture1, v2TexLocal - v2Offset);

    	gl_FragColor = mix(v4Res * 0.142857142857143, v4FrameColor, v4FrameColor.a);
    }
}