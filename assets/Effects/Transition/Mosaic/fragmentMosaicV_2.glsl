;

void main(){

    vec4 v4Result = vec4(0.0, 0.0, 0.0, 0.0);

	float fStartY = floor(v_texCoords.y * u_fBlockCountY) * u_fBlockSizeY;

    vec2 v2TxCoord = vec2(v_texCoords.x * u_fMosaicBufferMappingX, fStartY);

	for ( int nCurY = 0; nCurY < maxBlockSize ; nCurY++ )
	{
	    if(nCurY == u_nBlockSizeY)
    	    break;

		v4Result += texture2D(u_texture0, v2TxCoord);
		v2TxCoord.y += u_fPixelSizeY;
	}

	v4Result /= float(u_nBlockSizeY);

	gl_FragColor = v4Result;

}