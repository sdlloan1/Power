;

void main(){

    vec4 v4Result = vec4(0.0, 0.0, 0.0, 0.0);

	float fStartX = floor(v_texCoords.x * u_fBlockCountX) * u_fBlockSizeX;

    vec2 v2TxCoord = vec2(fStartX, v_texCoords.y);

	for ( int nCurX = 0; nCurX < maxBlockSize ; nCurX++ )
	{
	    if(nCurX == u_nBlockSizeX)
    	    break;

		v4Result += texture2D(u_texture0, v2TxCoord);
		v2TxCoord.x += u_fPixelSizeX;
	}

	v4Result /= float(u_nBlockSizeX);

	gl_FragColor = v4Result;

}