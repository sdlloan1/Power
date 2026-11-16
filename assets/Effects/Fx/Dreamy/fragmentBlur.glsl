
uniform sampler2D u_texture0;
uniform sampler2D gaussianTableTexture;

precision mediump float;

varying vec2 v_texCoords;
uniform highp float texelWidthOffset;
uniform highp float texelHeightOffset;

uniform mediump float blurSize;

void main()
{
    vec2 singleStepOffset = vec2(texelWidthOffset, texelHeightOffset);
    vec2 blurOffset;
    vec4 sum = vec4(0.0);
    vec4 v4GaussianWeight = texture2D(gaussianTableTexture, vec2(0.0, 0.0));
    float fGaussianWeight = v4GaussianWeight.r + v4GaussianWeight.g / 256.0;
    sum = texture2D(u_texture0, v_texCoords) * fGaussianWeight;

    int nSize = int(blurSize);
    for(int index = 1 ; index <= nSize ; index++)
    {
        v4GaussianWeight = texture2D(gaussianTableTexture, vec2(float(index) / blurSize, 0.0));
        fGaussianWeight = v4GaussianWeight.r + v4GaussianWeight.g / 256.0;

        blurOffset = singleStepOffset * float(index);
        sum += texture2D(u_texture0, v_texCoords + blurOffset) * fGaussianWeight;
        sum += texture2D(u_texture0, v_texCoords - blurOffset) * fGaussianWeight;
    }

	gl_FragColor = vec4(sum.rgb, 1.0);
}