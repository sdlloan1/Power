
uniform sampler2D u_textureSrc;
uniform sampler2D u_textureBlur;

precision mediump float;
varying vec2 v_texCoords;

void main(){
	vec4 v4GrayConvert = vec4(0.299, 0.587, 0.114, 0.0);
//	vec4 v4ColorForeground = vec4(215.0/255.0, 210.0/255.0, 204.0/255.0, 1.0);
	vec4 v4ColorForeground = vec4(0.8431372549, 0.8235294117647, 0.8, 1.0);

//	float fMean = 0.5;			// In C-code version, the mean is the avergae of all pixels
											// This is hard to get by PS, thus I use a constant value 0.5

//	float fContrast = 20.0;	// range from -100.0 ~ 100.0; 
											// If the value is 100.0 or -100.0, need special handling of
											//	the below tan operations.
//	float fRadian = 1.57079632679489661923 * ( fContrast + 100.0 ) / 200.0;	// M_PI_2  0.942477796076937971538
//	float fTangent = tan ( fRadian );//1.3763819201149794569540327849571

	float fGray = dot(texture2D(u_textureBlur, v_texCoords), v4GrayConvert);

	// Contrast adjustment
//	fGray = fMean + ( fGray - fMean ) * fTangent;
	fGray = 0.5 + ( fGray - 0.5 ) * 2.7527638402299589139080655699142;
    fGray = clamp(fGray, 0.0, 1.0);

	// BlendLayerMultiply ( colorForeGround, Contrast-Adjusted_Gray );
	vec4 v4Composition = v4ColorForeground * fGray;

	// BlendLayerOverlay ( composition, colorWhite );
	// The original algorithm is ( composition <= 0.5 )? (2.0*composition*colorWhite) : (1.0-(2.0*(1.0-composition)*(1.0-colorWhite))
	// Since colorWhite is 1.0, thus it can be simplified as the below instructions with auto-saturation.
	v4Composition = 2.0 * v4Composition;

	gl_FragColor = vec4(v4Composition.rgb, texture2D(u_textureSrc, v_texCoords).a);
}