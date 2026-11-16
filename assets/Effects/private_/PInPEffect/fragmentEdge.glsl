
uniform sampler2D u_textureSrc;

precision mediump float;

uniform vec2 u_TexelSize;

varying vec2 v_texCoords;

void main(){

    vec4 v4DiffX = texture2D(u_textureSrc, v_texCoords + vec2(u_TexelSize.x, 0.0)) - texture2D(u_textureSrc, v_texCoords - vec2(u_TexelSize.x, 0.0));
    vec4 v4DiffY = texture2D(u_textureSrc, v_texCoords + vec2(0.0, u_TexelSize.y)) - texture2D(u_textureSrc, v_texCoords - vec2(0.0, u_TexelSize.y));

    float fVal = abs(v4DiffX.a) + abs(v4DiffY.a);

    gl_FragColor = vec4(fVal, fVal, fVal, 1.0);
}