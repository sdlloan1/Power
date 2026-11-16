
uniform sampler2D u_texture0;

precision mediump float;
varying vec2 v_texCoords;

uniform highp float texelWidthOffset;
uniform highp float texelHeightOffset;

void main(){
//    vec4 v4Left = texture2D(u_texture0, vec2(v_texCoords.x - texelWidthOffset, v_texCoords.y));
//    vec4 v4Right = texture2D(u_texture0, vec2(v_texCoords.x + texelWidthOffset, v_texCoords.y));
//    vec4 v4Top = texture2D(u_texture0, vec2(v_texCoords.x, v_texCoords.y - texelHeightOffset));
//    vec4 v4Down = texture2D(u_texture0, vec2(v_texCoords.x, v_texCoords.y + texelHeightOffset));;
    vec4 v4DiffX = texture2D(u_texture0, vec2(v_texCoords.x + texelWidthOffset, v_texCoords.y)) - texture2D(u_texture0, vec2(v_texCoords.x - texelWidthOffset, v_texCoords.y));
    vec4 v4DiffY = texture2D(u_texture0, vec2(v_texCoords.x, v_texCoords.y + texelHeightOffset)) - texture2D(u_texture0, vec2(v_texCoords.x, v_texCoords.y - texelHeightOffset));
    gl_FragColor = vec4(distance(vec2(v4DiffX.r, v4DiffY.r), vec2(0.0, 0.0)), distance(vec2(v4DiffX.g, v4DiffY.g), vec2(0.0, 0.0)), distance(vec2(v4DiffX.b, v4DiffY.b), vec2(0.0, 0.0)), 1.0);
}