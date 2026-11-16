#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_TxDistortion;
uniform float u_fDistortionWeight;
uniform float fProgress;
uniform float u_fShiftProgress;

void main(){

    vec4 v4Distortion = texture2D(u_TxDistortion, v_texCoords);

    float fTxCoordX = v_texCoords.x + ((v4Distortion.r + v4Distortion.g / 256.0) - 0.5) * u_fDistortionWeight;

    if((fTxCoordX < 0.0) || (fTxCoordX > 1.0))
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else
    {
       	if(v_texCoords.y < (1.0 - u_fShiftProgress))
       	    gl_FragColor = texture2D(u_texture0, vec2(fTxCoordX, v_texCoords.y + u_fShiftProgress));
       	else
           	gl_FragColor = texture2D(u_texture1, vec2(fTxCoordX, v_texCoords.y - 1.0 + u_fShiftProgress));
    }
}