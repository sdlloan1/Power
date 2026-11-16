
uniform sampler2D u_textureSrc;

precision highp float;

uniform float u_TexelOffset_H;
uniform float u_TexelOffset_V;
uniform float u_Threshold;

varying vec2 v_texCoords;

void main(){

    float fLeft = dot(texture2D(u_textureSrc, vec2(v_texCoords.x - u_TexelOffset_H, v_texCoords.y)), vec4(0.299, 0.587, 0.114, 0.0));
    float fRight = dot(texture2D(u_textureSrc, vec2(v_texCoords.x + u_TexelOffset_H, v_texCoords.y)), vec4(0.299, 0.587, 0.114, 0.0));
    float fUp = dot(texture2D(u_textureSrc, vec2(v_texCoords.x, v_texCoords.y - u_TexelOffset_V)), vec4(0.299, 0.587, 0.114, 0.0));
    float fDown = dot(texture2D(u_textureSrc, vec2(v_texCoords.x, v_texCoords.y + u_TexelOffset_V)), vec4(0.299, 0.587, 0.114, 0.0));

    float fEdgeVal = distance(vec2(fLeft - fRight, fUp - fDown), vec2(0.0));
    fEdgeVal = clamp((fEdgeVal - u_Threshold) * 2.5 + u_Threshold, 0.0, 1.0);

    gl_FragColor = vec4(fEdgeVal, fEdgeVal, fEdgeVal, 1.0);
}