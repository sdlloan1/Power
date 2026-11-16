#ifndef HAS_OFFSCREEN_TEXTURE
	#ifdef INPUT_IS_OES_TEXTURE
	#extension GL_OES_EGL_image_external : require
		uniform samplerExternalOES u_texture0;
	#else
		uniform sampler2D u_texture0;
	#endif
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;
varying vec2 v_texCoords;

uniform float fProgress;
const float PI = 3.1415926535897932384626433832795028841971693993751;

/** Functionality of parameters sync to PDR12
 *  Value of parameters NOT mapping exactly the same.
 *  Currently not support "Vertical Mirror Center", and "Inverse".
 */
uniform float waveInterval; // 2.~8.
uniform float wavelet; // .1~.5
uniform float speed; // 5.~40.
uniform float mirrorCenter; // 0~0.5
uniform float inverse;
uniform float waveBrightness;

void main(){

    float fMirrorCenter = mirrorCenter * 0.5;

	vec2 v1 = v_texCoords;

    if(inverse > 0.5)
    {
#ifdef ORIENTATION_NONE
        v1.y = 1.0 - v1.y;
#endif

#ifdef ORIENTATION_90
        v1.x = 1.0 - v1.x;
#endif

        float f = floor(speed*20.0);
        float lambda = wavelet/200.0+(v1.y-.5)/waveInterval;
        float omega = PI*2.*f;
    //	float vw = f*lambda;
    //	float k = omega/vw;
        float k = PI*2./lambda;
        float dist = v1.y-(0.5+fMirrorCenter);

        float lambdaX = wavelet/200.0+(v1.x-.5)/waveInterval;
    //	float vwX = f*lambdaX;
    //	float kX = omega/vwX;
        float kX = PI*2./lambdaX;
        float distX = v1.x-(0.5+fMirrorCenter);

#ifdef ORIENTATION_NONE
        if (dist < 0.0) {
            gl_FragColor = texture2D(u_texture0, v_texCoords);
        } else {
            v1.y = fMirrorCenter * 2.0 - v1.y + sin(k*(1.5-v1.y)-omega*(1.-fProgress))/30.;
            v1.y = abs(v1.y);
            vec4 v4Res = texture2D(u_texture0, v1);
            gl_FragColor = vec4((v4Res+(waveBrightness*dist/10.0)).rgb, v4Res.a);
        }

        return;
#endif

#ifdef ORIENTATION_270
        if (distX < 0.0) {
            gl_FragColor = texture2D(u_texture0, v_texCoords);
        } else {
            v1.x = 1.0 + fMirrorCenter * 2.0 - v1.x + sin(kX*(1.5-v1.x)-omega*(1.-fProgress))/30.;
            v1.x = abs(v1.x);
            vec4 v4Res = texture2D(u_texture0, v1);
            gl_FragColor = vec4((v4Res+(waveBrightness*dist/10.0)).rgb, v4Res.a);
        }
        return;
#endif

#ifdef ORIENTATION_90
        if (distX < 0.0) {
            gl_FragColor = texture2D(u_texture0, v_texCoords);
        } else {
            v1.x = fMirrorCenter * 2.0 - v1.x + sin(kX*(1.5-v1.x)-omega*(1.-fProgress))/30.;
            v1.x = abs(v1.x);
            vec4 v4Res = texture2D(u_texture0, v1);
            gl_FragColor = vec4((v4Res+(waveBrightness*dist/10.0)).rgb, v4Res.a);
        }
        return;
#endif

        if (dist < 0.0) {
            gl_FragColor = texture2D(u_texture0, v_texCoords);
        } else {
            v1.y = 1.0 + fMirrorCenter * 2.0 - v1.y + sin(k*(1.5-v1.y)-omega*(1.-fProgress))/30.;
            v1.y = abs(v1.y);
            vec4 v4Res = texture2D(u_texture0, v1);
            gl_FragColor = vec4((v4Res+(waveBrightness*dist/10.0)).rgb, v4Res.a);
        }

        return;
    }

#ifdef ORIENTATION_180
    v1.y = 1.0 - v1.y;
#endif

#ifdef ORIENTATION_270
    v1.x = 1.0 - v1.x;
#endif

	float f = floor(speed*20.0);
	float lambda = wavelet/200.0+(v1.y-.5)/waveInterval;
	float omega = PI*2.*f;
//	float vw = f*lambda;
//	float k = omega/vw;
	float k = PI*2./lambda;
	float dist = v1.y-(0.5+fMirrorCenter);
	
	float lambdaX = wavelet/200.0+(v1.x-.5)/waveInterval;
//	float vwX = f*lambdaX;
//	float kX = omega/vwX;
	float kX = PI*2./lambdaX;
	float distX = v1.x-(0.5+fMirrorCenter);

#ifdef ORIENTATION_180
	if (dist < 0.0) {
		gl_FragColor = texture2D(u_texture0, v_texCoords);
	} else {
		v1.y = fMirrorCenter * 2.0 - v1.y + sin(k*(1.5-v1.y)-omega*(1.-fProgress))/30.;
		v1.y = abs(v1.y);
        vec4 v4Res = texture2D(u_texture0, v1);
        gl_FragColor = vec4((v4Res+(waveBrightness*dist/10.0)).rgb, v4Res.a);
	}

	return;
#endif

#ifdef ORIENTATION_90
	if (distX < 0.0) {
		gl_FragColor = texture2D(u_texture0, v_texCoords);
	} else {
		v1.x = 1.0 + fMirrorCenter * 2.0 - v1.x + sin(kX*(1.5-v1.x)-omega*(1.-fProgress))/30.;
		v1.x = abs(v1.x);
        vec4 v4Res = texture2D(u_texture0, v1);
        gl_FragColor = vec4((v4Res+(waveBrightness*dist/10.0)).rgb, v4Res.a);
	}
	return;
#endif

#ifdef ORIENTATION_270
	if (distX < 0.0) {
		gl_FragColor = texture2D(u_texture0, v_texCoords);
	} else {
		v1.x = fMirrorCenter * 2.0 - v1.x + sin(kX*(1.5-v1.x)-omega*(1.-fProgress))/30.;
		v1.x = abs(v1.x);
        vec4 v4Res = texture2D(u_texture0, v1);
        gl_FragColor = vec4((v4Res+(waveBrightness*dist/10.0)).rgb, v4Res.a);
	}
	return;
#endif

	if (dist < 0.0) {
		gl_FragColor = texture2D(u_texture0, v_texCoords);
	} else {
		v1.y = 1.0 + fMirrorCenter * 2.0 - v1.y + sin(k*(1.5-v1.y)-omega*(1.-fProgress))/30.;
		v1.y = abs(v1.y);
        vec4 v4Res = texture2D(u_texture0, v1);
        gl_FragColor = vec4((v4Res+(waveBrightness*dist/10.0)).rgb, v4Res.a);
	}
}
