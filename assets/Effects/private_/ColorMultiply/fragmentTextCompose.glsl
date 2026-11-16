precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_textureFace;
uniform sampler2D u_textureBorder;
uniform sampler2D u_textureSecondBorder;
uniform sampler2D u_textureShadow;
uniform sampler2D u_textureSecondShadow;
uniform sampler2D u_textureBackdrop;
uniform sampler2D u_textureMask;
uniform float u_baseFaceOpacity;
uniform float u_baseBorderOpacity;
uniform float u_baseSecondBorderOpacity;
uniform float u_baseShadowOpacity;
uniform float u_baseSecondShadowOpacity;
uniform float u_baseBackDropOpacity;
uniform int u_applyMask;
uniform int u_needKeepBlankForeground;

vec4 merge(vec4 colorBackground,
           vec4 colorForeground,
           float baseForegroundOpacity,
           bool keepBlankForeground){
	float foregroundRatio = 0.0;
	if (baseForegroundOpacity > 0.0) {
	    foregroundRatio = colorForeground.a / baseForegroundOpacity;
	} else if (keepBlankForeground) {
        foregroundRatio = colorForeground.a / 0.02;
    }

    if (foregroundRatio > 0.99) {
    	return colorForeground;
	} else if(foregroundRatio < 0.01) {
        return colorBackground;
    } else {
        // fade background according to ratio
        if(keepBlankForeground) {
            colorBackground *= (1.0 - foregroundRatio);
        }

        // the color is pre-multiplied
        float alphaMixed = colorBackground.a + colorForeground.a - colorBackground.a * colorForeground.a;
        float redMixed   = (colorBackground.r * (1.0 - colorForeground.a) + colorForeground.r);
        float greenMixer = (colorBackground.g * (1.0 - colorForeground.a) + colorForeground.g);
        float blueMixer  = (colorBackground.b * (1.0 - colorForeground.a) + colorForeground.b);
        return vec4(redMixed, greenMixer, blueMixer, alphaMixed);
	}
}

void main(){
	vec4 colorBackground = vec4(0.0);
	bool validBackground = false;

    float maskAlpha = 1.0;

    if(u_applyMask > 0) {
        maskAlpha = texture2D(u_textureMask, v_texCoords).a;
    }

	if (u_baseBackDropOpacity > 0.0) {
	    colorBackground = texture2D(u_textureBackdrop, v_texCoords);
	    validBackground = true;
	}

    if (u_baseSecondShadowOpacity > 0.0) {
	    vec4 colorSecondShadow = texture2D(u_textureSecondShadow, v_texCoords);
	    if ( validBackground ) {
	        colorBackground = merge(colorBackground, colorSecondShadow, 1.0, false);
	    } else {
   	        colorBackground = colorSecondShadow;
   	        validBackground = true;
   	    }
   	}

	if (u_baseShadowOpacity > 0.0) {
	    vec4 colorShadow = texture2D(u_textureShadow, v_texCoords);
	    if ( validBackground ) {
	        colorBackground = merge(colorBackground, colorShadow, 1.0, false);
	    } else {
   	        colorBackground = colorShadow;
   	        validBackground = true;
   	    }
   	}

    // compose face+border+secondBorder first
    vec4 colorMixedText = vec4(0.0);
    bool validMixedText = false;
    if (u_baseSecondBorderOpacity > 0.0) {
   	    colorMixedText = texture2D(u_textureSecondBorder, v_texCoords);
   	    validMixedText = true;
    }

    if ((u_baseBorderOpacity > 0.0) || (u_needKeepBlankForeground > 0)) {
        vec4 colorBorder = texture2D(u_textureBorder, v_texCoords);
        bool keepBlankForeground = (u_baseBorderOpacity > 0.0)? false: (u_needKeepBlankForeground > 0);
        if ( validMixedText ) {
            colorMixedText = merge(colorMixedText, colorBorder, u_baseBorderOpacity, keepBlankForeground);
        } else {
            colorMixedText = colorBorder;
            validMixedText = true;
        }
    }

    if ((u_baseFaceOpacity > 0.0) || (u_needKeepBlankForeground > 0)) {
        vec4 colorFace = texture2D(u_textureFace, v_texCoords);
        bool keepBlankForeground = (u_baseFaceOpacity > 0.0)? false: (u_needKeepBlankForeground > 0);
        if ( validMixedText ) {
            colorMixedText = merge(colorMixedText, colorFace, u_baseFaceOpacity, keepBlankForeground);
        } else {
            colorMixedText = colorFace;
            validMixedText = true;
        }
    }

    float alpha;
    vec3 rgb;
    if ( validBackground && validMixedText ) {
        colorMixedText = merge(colorBackground, colorMixedText, 1.0, false);
        alpha = colorMixedText.a * maskAlpha;
        rgb = colorMixedText.rgb;
    } else if (validMixedText){
        alpha = colorMixedText.a * maskAlpha;
        rgb = colorMixedText.rgb;
    } else {
        alpha = colorBackground.a * maskAlpha;
        rgb = colorBackground.rgb;
    }

    if (alpha > 0.0)  {
        float r = min(rgb.r/alpha, 1.0);
        float g = min(rgb.g/alpha, 1.0);
        float b = min(rgb.b/alpha, 1.0);

        gl_FragColor = vec4(r, g, b, alpha);
    } else {
        gl_FragColor = vec4(rgb, alpha);
    }
}



