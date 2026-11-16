#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;
uniform float u_Ratio;
uniform int u_Direction;

void main(){

    float fTheta = atan(0.5 - v_texCoords.y, (v_texCoords.x - 0.5) * u_Ratio) - 1.5707963268;
    if(fTheta < 0.0)
        fTheta += 6.2831853072;

	if(u_Direction == 0)
	{
    	if(fTheta < (6.2831853072 * fProgress))
    	    gl_FragColor = texture2D(u_texture1, v_texCoords);
    	else
        	gl_FragColor = texture2D(u_texture0, v_texCoords);
	}
	else
	{
    	if(fTheta < (6.2831853072 * (1.0 - fProgress)))
    	    gl_FragColor = texture2D(u_texture0, v_texCoords);
    	else
        	gl_FragColor = texture2D(u_texture1, v_texCoords);
    }
}