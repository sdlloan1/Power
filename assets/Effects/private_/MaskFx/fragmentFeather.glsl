uniform sampler2D u_texture0;

precision mediump float;

varying vec2 v_texCoords;

uniform float texelWidthOffset;
uniform float texelHeightOffset;
uniform float iDegree;

void main(void)
{
	vec2 singleStepOffset = vec2(texelWidthOffset, texelHeightOffset) * iDegree * 0.125;

	vec4 sum = vec4(0.0);

	sum += texture2D(u_texture0, v_texCoords) * 0.132;
	sum += (texture2D(u_texture0, (v_texCoords + singleStepOffset * 1.0)) +
	        texture2D(u_texture0, (v_texCoords - singleStepOffset * 1.0))) * 0.126;
	sum += (texture2D(u_texture0, (v_texCoords + singleStepOffset * 2.0)) +
	        texture2D(u_texture0, (v_texCoords - singleStepOffset * 2.0))) * 0.107;
    sum += (texture2D(u_texture0, (v_texCoords + singleStepOffset * 3.0)) +
	        texture2D(u_texture0, (v_texCoords - singleStepOffset * 3.0))) * 0.081;
    sum += (texture2D(u_texture0, (v_texCoords + singleStepOffset * 4.0)) +
	        texture2D(u_texture0, (v_texCoords - singleStepOffset * 4.0))) * 0.055;
    sum += (texture2D(u_texture0, (v_texCoords + singleStepOffset * 5.0)) +
	        texture2D(u_texture0, (v_texCoords - singleStepOffset * 5.0))) * 0.034;
    sum += (texture2D(u_texture0, (v_texCoords + singleStepOffset * 6.0)) +
	        texture2D(u_texture0, (v_texCoords - singleStepOffset * 6.0))) * 0.018;
    sum += (texture2D(u_texture0, (v_texCoords + singleStepOffset * 7.0)) +
  	        texture2D(u_texture0, (v_texCoords - singleStepOffset * 7.0))) * 0.009;
    sum += (texture2D(u_texture0, (v_texCoords + singleStepOffset * 8.0)) +
   	        texture2D(u_texture0, (v_texCoords - singleStepOffset * 8.0))) * 0.004;


    gl_FragColor = sum;
}