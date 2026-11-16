#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;

void main(){

    if(fProgress <= 0.4)
    {
        vec4 v4Src1 = texture2D(u_texture0, v_texCoords);

        float blackDegree = fProgress * 2.5;
        float blackDegree2 = 1.0 - blackDegree;
        float lightLevel = 1.0 - dot(v4Src1, vec4(0.299, 0.587, 0.114, 0.0));

        gl_FragColor = vec4((v4Src1 * (1.0 - blackDegree) + (lightLevel * blackDegree)).rgb, 1.0);
	}
    else if(fProgress <= 0.8)
    {
        vec4 v4Src1 = texture2D(u_texture0, v_texCoords);
        float embossDegree = fProgress * 2.5 - 1.0;
        float lightLevel = 1.0 - dot(v4Src1, vec4(0.299, 0.587, 0.114, 0.0));

        float k2 = lightLevel * 4.0 + embossDegree * 4.0 - 3.0;
        float res = max(k2, lightLevel);
        gl_FragColor = vec4(res, res, res, 1.0);
    }
    else
    {
        vec4 v4Src2 = texture2D(u_texture1, v_texCoords);
        float whiteDegree = fProgress * 5.0 - 4.0;

        gl_FragColor = vec4((v4Src2 * whiteDegree + (1.0 - whiteDegree)).rgb, 1.0);
    }
}