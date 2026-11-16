
uniform sampler2D u_texture0;

precision mediump float;

uniform float u_texelOffsetY;
uniform int u_Height;
varying vec2 v_texCoords;

void main()
{
    float maxR = 0.0;
    float maxG = 0.0;
    float maxB = 0.0;
    vec4 v4Pixel;

    float txPosY = u_texelOffsetY / 2.0;
    for(int index = 0 ; index < u_Height ; ++index)
    {
        v4Pixel = texture2D(u_texture0, vec2(v_texCoords.x, txPosY));
        txPosY += u_texelOffsetY;

        maxR = max(v4Pixel.r, maxR);
        maxG = max(v4Pixel.g, maxG);
        maxB = max(v4Pixel.b, maxB);
    }

    maxR = max(maxG, maxR);
    maxR = max(maxB, maxR);

	gl_FragColor = vec4(maxR, maxR, maxR, 1.0);
}