
uniform sampler2D u_texture0;

precision mediump float;

uniform float u_Threshold;
uniform vec4 u_FGColor;
uniform vec4 u_BKColor;
uniform vec2 u_TexelSize;

varying vec2 v_texCoords;

void main()
{
    float fLT = texture2D(u_texture0, v_texCoords - u_TexelSize).r;
    float fRT = texture2D(u_texture0, v_texCoords + vec2(u_TexelSize.x, -u_TexelSize.y)).r;
    float fLB = texture2D(u_texture0, v_texCoords + vec2(-u_TexelSize.x, u_TexelSize.y)).r;
    float fRB = texture2D(u_texture0, v_texCoords + u_TexelSize).r;

    float fL = texture2D(u_texture0, v_texCoords + vec2(-u_TexelSize.x, 0.0)).r;
    float fT = texture2D(u_texture0, v_texCoords + vec2(0.0, -u_TexelSize.y)).r;
    float fR = texture2D(u_texture0, v_texCoords + vec2(u_TexelSize.x, 0.0)).r;
    float fB = texture2D(u_texture0, v_texCoords + vec2(0.0, u_TexelSize.y)).r;

    float fVertical = fLT + fT + fRT - fLB - fB - fRB;
    float fHorizontal = fLT + fL + fLB - fRT - fR - fRB;

    if((fVertical* fVertical + fHorizontal * fHorizontal) * 255.0 > u_Threshold)
	    gl_FragColor = vec4(u_FGColor.rgb, texture2D(u_texture0, v_texCoords).a);
    else
	    gl_FragColor = vec4(u_BKColor.rgb, texture2D(u_texture0, v_texCoords).a);
}