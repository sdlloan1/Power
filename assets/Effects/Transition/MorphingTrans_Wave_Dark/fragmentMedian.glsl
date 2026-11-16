
precision highp float;

uniform sampler2D u_textureSrc;

uniform vec2 u_SamplingOffset[9];
uniform float u_Distance;

varying vec2 v_texCoords;

#define sort2(a, b)				temp = a; a = min(a, b); b = max(temp, b);
#define min3(a, b, c)			sort2(a, b); sort2(a, c);
#define max3(a, b, c)			sort2(b, c); sort2(a, c);

#define minmax3(a, b, c)		max3(a, b, c); sort2(a, b);
#define minmax4(a, b, c, d)		sort2(a, b); sort2(c, d); sort2(a, c); sort2(b, d);
#define minmax5(a, b, c, d, e)	sort2(a, b); sort2(c, d); min3(a, c, e); max3(b, d, e);
#define minmax6(a, b, c, d, e, f) sort2(a, d); sort2(b, e); sort2(c, f); min3(a, b, c); max3(d, e, f);

void main(){

    vec4 v4Src[6];
  	v4Src[0] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[0] * u_Distance);
    v4Src[1] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[1] * u_Distance);
    v4Src[2] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[2] * u_Distance);
    v4Src[3] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[3] * u_Distance);
    v4Src[4] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[4] * u_Distance);
    v4Src[5] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[5] * u_Distance);

    vec4 temp;

    // Starting with a subset of size 6, remove the min and max each time
    minmax6(v4Src[0], v4Src[1], v4Src[2], v4Src[3], v4Src[4], v4Src[5]);

    v4Src[5] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[6] * u_Distance);

    minmax5(v4Src[1], v4Src[2], v4Src[3], v4Src[4], v4Src[5]);

    v4Src[5] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[7] * u_Distance);

    minmax4(v4Src[2], v4Src[3], v4Src[4], v4Src[5]);

    v4Src[5] = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[8] * u_Distance);

    minmax3(v4Src[3], v4Src[4], v4Src[5]);

    gl_FragColor = v4Src[4];
}
