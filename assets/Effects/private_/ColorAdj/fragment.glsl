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

uniform sampler2D u_textureMask;

precision mediump float;
varying vec2 v_texCoords;
uniform int u_brightness;
uniform int u_contrast;
uniform int u_saturation;

float brightnessAdjust(float originalColor, float adjustParameter, float ratio) {
	float tempColor = 1.0-pow(1.0-originalColor, adjustParameter);
	float newColor = (originalColor+(tempColor-originalColor)*ratio);

	return newColor;
}

float contrastAdjust(float originalColor, float adjustParameter, float ratio) {
	float tempColor;
	if (originalColor<0.5) {
		tempColor= (pow((2.0*originalColor), adjustParameter))/2.0;
	} else {
		tempColor= 0.5+(1.0-(pow((2.0-2.0*originalColor), adjustParameter)))/2.0;
	}
	float newColor = (originalColor+(tempColor-originalColor)*ratio);

	return newColor;
}

void main(){
	vec4 sourceColor = texture2D(u_texture0, v_texCoords);

	float A = sourceColor.a;

	// For some video clips that are extremely bright or drak, the
	// RGB values may be exceed the 0.0~1.0 range, and may cause
	// the following pow operation be undefined.
	// Adding the clamp here to avoid such a problem.
	float R = clamp(sourceColor.r, 0.0, 1.0);
	float G = clamp(sourceColor.g, 0.0, 1.0);
	float B = clamp(sourceColor.b, 0.0, 1.0);

	if(u_brightness>0) {
		float brightnessAdjustment = float(u_brightness)/100.0;
		R = brightnessAdjust(R, 3.75, brightnessAdjustment);
		G = brightnessAdjust(G, 3.75, brightnessAdjustment);
		B = brightnessAdjust(B, 3.75, brightnessAdjustment);
    } else if (u_brightness<0) {
		float brightnessAdjustment = -float(u_brightness)/100.0;
		R = brightnessAdjust(R, 0.247, brightnessAdjustment);
        G = brightnessAdjust(G, 0.247, brightnessAdjustment);
        B = brightnessAdjust(B, 0.247, brightnessAdjustment);
    }

    if(u_contrast>0) {
		float contrastAdjustment = float(u_contrast)/100.0;
		R = contrastAdjust(R , 1.54, contrastAdjustment);
		G = contrastAdjust(G , 1.54, contrastAdjustment);
		B = contrastAdjust(B , 1.54, contrastAdjustment);
    } else if (u_contrast<0) {
		float contrastAdjustment = -float(u_contrast)/100.0;
		R = contrastAdjust(R , 0.662, contrastAdjustment);
   		G = contrastAdjust(G , 0.662, contrastAdjustment);
   		B = contrastAdjust(B , 0.662, contrastAdjustment);
    }

    if ( u_saturation != 100 ) {
    	float saturationAdjustment = float(u_saturation)/100.0;
		float colorMax, colorMin;

		if(R>G) {
			colorMax = max(R, B);
			colorMin = min(G, B);
		} else {
			colorMax = max(G, B);
			colorMin = min(R, B);
		}
  		float diff = colorMax-colorMin;
  		float lightness = (colorMax+colorMin)/2.0;
		float newSaturationAdjustment;

		if ( diff > 0.0 ) {
			float originalSaturation = diff / (1.0-abs(2.0*lightness-1.0));
			float newSaturation = clamp(originalSaturation*saturationAdjustment, 0.0, 1.0 );
			newSaturationAdjustment = newSaturation / originalSaturation;
		} else {
			newSaturationAdjustment = 0.0;
		}


  		R = (lightness + (R-lightness)*newSaturationAdjustment);
  		G = (lightness + (G-lightness)*newSaturationAdjustment);
  		B = (lightness + (B-lightness)*newSaturationAdjustment);
    }

	gl_FragColor = vec4(mix(sourceColor.rgb, vec3(R, G, B), texture2D(u_textureMask, v_texCoords).a), A);
}
