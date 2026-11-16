
uniform sampler2D u_textureSrc;

precision mediump float;

uniform float u_Opacity;

varying vec2 v_texCoords;

void main(void)
{
    vec4 v4Src = texture2D(u_textureSrc, v_texCoords);
    gl_FragColor = vec4(v4Src.rgb, v4Src.a * u_Opacity);
}
