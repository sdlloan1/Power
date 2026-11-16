
uniform sampler2D u_texture0;

precision mediump float;

uniform vec2 uTexelSize;
uniform int uRegionSize;

varying vec2 v_texCoords;

void main()
{
    vec2 v2TxCoord = v_texCoords - (uTexelSize * float(uRegionSize) * 0.5);
    vec4 v4Pixel = vec4(0.0, 0.0, 0.0, 0.0);
    float nCount = 0.0;
    for(int index = 0 ; index < uRegionSize ; ++index)
    {
        if((v2TxCoord.x < 0.0) || (v2TxCoord.x > 0.999) || (v2TxCoord.y < 0.0) || (v2TxCoord.y > 0.999))
        {
        }
        else
        {
            v4Pixel += texture2D(u_texture0, v2TxCoord);
            nCount += 1.0;
        }

        v2TxCoord += uTexelSize;
    }

    v4Pixel /= max(1.0, nCount);

	gl_FragColor = vec4(v4Pixel.rgb, 1.0);
}