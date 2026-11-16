
uniform sampler2D u_texture0;

precision mediump float;

uniform vec2 v2StepArray[6];
uniform int nLight;
uniform float fWeight;
uniform float fWeightStep;

uniform int nKernel;

varying vec2 v_texCoords;

void main()
{
	vec4 v4Result = vec4(0.0);
	vec4 v4Pixel;

	vec2 v2Pos;
	float fCurW;

    //Light 1
	v2Pos = v_texCoords;
	fCurW = fWeight;
	for ( int kn = 0; kn < nKernel; kn++ )
	{
    	v2Pos += v2StepArray[0];

    	v4Pixel = texture2D(u_texture0, v2Pos);
    	v4Result += (fCurW * v4Pixel);

		fCurW -= fWeightStep;
	}

    //Light 2
    if(nLight > 1)
    {
        v2Pos = v_texCoords;
    	fCurW = fWeight;
    	for ( int kn = 0; kn < nKernel; kn++ )
    	{
        	v2Pos += v2StepArray[1];
    
        	v4Pixel = texture2D(u_texture0, v2Pos);
        	v4Result += (fCurW * v4Pixel);
    
    		fCurW -= fWeightStep;
    	}
    }

    //Light 3
    if(nLight > 2)
    {
    	v2Pos = v_texCoords;
    	fCurW = fWeight;
    	for ( int kn = 0; kn < nKernel; kn++ )
    	{
        	v2Pos += v2StepArray[2];
    
        	v4Pixel = texture2D(u_texture0, v2Pos);
        	v4Result += (fCurW * v4Pixel);
    
    		fCurW -= fWeightStep;
    	}
    }

    //Light 4
    if(nLight > 3)
    {
        v2Pos = v_texCoords;
    	fCurW = fWeight;
    	for ( int kn = 0; kn < nKernel; kn++ )
    	{
        	v2Pos += v2StepArray[3];
    
        	v4Pixel = texture2D(u_texture0, v2Pos);
        	v4Result += (fCurW * v4Pixel);
    
    		fCurW -= fWeightStep;
    	}
   }

    //Light 5
    if(nLight > 4)
    {
        v2Pos = v_texCoords;
    	fCurW = fWeight;
    	for ( int kn = 0; kn < nKernel; kn++ )
    	{
        	v2Pos += v2StepArray[4];
    
        	v4Pixel = texture2D(u_texture0, v2Pos);
        	v4Result += (fCurW * v4Pixel);
    
    		fCurW -= fWeightStep;
    	}
   }

    //Light 6
    if(nLight > 5)
    {
        v2Pos = v_texCoords;
    	fCurW = fWeight;
    	for ( int kn = 0; kn < nKernel; kn++ )
    	{
        	v2Pos += v2StepArray[5];
    
        	v4Pixel = texture2D(u_texture0, v2Pos);
        	v4Result += (fCurW * v4Pixel);
    
    		fCurW -= fWeightStep;
    	}
   }

    v4Result /= float(nKernel);

    gl_FragColor = vec4(v4Result.rgb, 1.0);
}