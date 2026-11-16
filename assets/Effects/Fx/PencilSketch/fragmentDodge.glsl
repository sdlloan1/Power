
uniform sampler2D u_textureBlur;
uniform sampler2D u_textureHSL;

precision mediump float;

vec4 v4One = vec4(1.0, 1.0, 1.0, 1.0);
vec4 v4Zero = vec4(0.00392, 0.00392, 0.00392, 0.00392);

varying vec2 v_texCoords;

void main()
{
    vec4 v4HSL = texture2D(u_textureHSL, v_texCoords);
    vec4 v4Blur = texture2D(u_textureBlur, v_texCoords);

    float fDodge = max(0.00392, (1.0 - v4Blur.b));
    fDodge = max(0.0, min(v4HSL.b / fDodge, 1.0) - 0.21568627); // Adjust Brightness -55

    if(v4HSL.b < 0.12549)
        fDodge = (v4HSL.b * (0.12549 - v4HSL.b) + fDodge * v4HSL.b) / 0.12549;

    gl_FragColor = vec4(fDodge, fDodge, fDodge, 1.0);
}