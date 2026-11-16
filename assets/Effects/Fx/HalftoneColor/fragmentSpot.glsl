
uniform sampler2D u_textureAvg;

precision mediump float;

uniform float u_Intensity;

varying vec2 v_texCoords;
varying vec2 v_Center;

void main()
{
    vec2 v2Distance = v_texCoords - vec2(0.5, 0.5);
    float fDistance = sqrt(dot(v2Distance * v2Distance, vec2(1.0, 1.0)));
    vec4 v4Avg = texture2D(u_textureAvg, v_Center);
    float fRadius = u_Intensity * (1.0 - v4Avg.a) * 0.5;

    if(fDistance < fRadius)
    	gl_FragColor = vec4(v4Avg.rgb, 1.0);
    else
    	gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}