#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
uniform int u_Tolerance;
uniform int u_ATanTarget;
varying vec2 v_texCoords;

void main()
{
	// Return order -- float4(B, G, R, A)
	// f4.x = R , f4.y = G , f4.z = B , f4.w = A
	vec4 f4Result = texture2D(u_texture0, v_texCoords);

    if(u_Tolerance >= 180)
    {
        gl_FragColor = f4Result;
    }
    else
    {
        float curY = dot(f4Result, vec4(0.299, 0.587, 0.114, 0.0));
        float curCb = dot(f4Result, vec4(-0.169, -0.331, 0.5, 0.0));
        float curCr = dot(f4Result, vec4(0.5, -0.419, -0.081, 0.0));

        int ATanCur = int(atan(curCb , curCr) * 57.295779513);
        if(ATanCur < 0)
            ATanCur += 360;

        int nAngleDiff = ATanCur - u_ATanTarget;
        if(nAngleDiff < 0)
            nAngleDiff *= -1;

        if(nAngleDiff > 180)
            nAngleDiff = 360 - nAngleDiff;

        if(nAngleDiff > (u_Tolerance + 10))
        {
            float gray = 1.1640625 * (curY - 0.0627451);
            gl_FragColor = vec4(gray, gray, gray, f4Result.a);
        }
        else if(nAngleDiff > u_Tolerance)
        {
            curCb = curCb * (1.0 - float(nAngleDiff - u_Tolerance) / 10.0);
            curCr = curCr * (1.0 - float(nAngleDiff - u_Tolerance) / 10.0);

            float fR = curY + (1.402 * curCr);
            float fG = curY - (0.344 * curCb) - (0.714 * curCr);
            float fB = curY + (1.772 * curCb);

            gl_FragColor = vec4(fR, fG, fB, f4Result.a);
        }
        else
        {
            gl_FragColor = f4Result;
        }
    }
}