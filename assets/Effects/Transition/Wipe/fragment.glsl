#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;
uniform int u_Direction;

void main(){

	if(u_Direction == 0)
	{
    	if(v_texCoords.y < (1.0 - fProgress))
    	    gl_FragColor = texture2D(u_texture0, v_texCoords);
    	else
        	gl_FragColor = texture2D(u_texture1, v_texCoords);
	}
	else if(u_Direction == 1)
	{
    	if(v_texCoords.y < fProgress)
    	    gl_FragColor = texture2D(u_texture1, v_texCoords);
    	else
        	gl_FragColor = texture2D(u_texture0, v_texCoords);
    }
	else if(u_Direction == 2)
	{
    	if(v_texCoords.x < (1.0 - fProgress))
    	    gl_FragColor = texture2D(u_texture0, v_texCoords);
    	else
        	gl_FragColor = texture2D(u_texture1, v_texCoords);
	}
	else if(u_Direction == 3)
	{
    	if(v_texCoords.x < fProgress)
    	    gl_FragColor = texture2D(u_texture1, v_texCoords);
    	else
        	gl_FragColor = texture2D(u_texture0, v_texCoords);
	}
}