//EcdsaSecp256k1Mex.cpp.cpp

//Any line starting with "//@@//" is providing information (dependencies) to the Matlab function MexCompile. Directories are assumed to be include directories
//source code

//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\micro-ecc-master\uECC2.c')
//include directories:
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\micro-ecc-master')




#include <vector>


//C:\Dropbox (Fairtree Newlands)\Library\micro-ecc-master



extern "C" {
#include "mex.h" 
}

  
#include "uECC.h"


#define DOUBLEPRINT(str) mexPrintf("%% %s: %g\n", #str, str );
#define BOOLPRINT(str) mexPrintf("%% %s: %s\n", #str, str?"true":"false" );
#define INTEGERPRINT(str) mexPrintf("%% %s: %d\n", #str, str );
#include <string>
#define MSASSERT(str) if (!(str)) throw(string("failed assertion:") + string(#str));
#define DRAWNOW mexEvalString("drawnow");




using namespace std;

void UnpackSimpleMatlabDoubleVector( vector<double> & doubleVec, const mxArray *prhsPtr   )
{
    doubleVec.resize(  mxGetNumberOfElements( prhsPtr )  );
    memcpy( &doubleVec[0], mxGetPr( prhsPtr), doubleVec.size() * sizeof(double) );
}




void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray  *prhs[] )
{
    
    
    try
    {
        
        
        const int lineOffset1 = __LINE__+1; //NB: Don't leave spaces between lines. This generates input order.
        const int prhsPrivateKey =	__LINE__-lineOffset1;
        const int numMatlabInputs =	__LINE__-lineOffset1;
        
        
        
        
        MSASSERT(numMatlabInputs==nrhs);
        MSASSERT( 32==mxGetNumberOfElements( prhs[prhsPrivateKey] )  );
        
        
        vector<double> privateKeyVec;
        UnpackSimpleMatlabDoubleVector(privateKeyVec, prhs[prhsPrivateKey]  );
        
        
        mexPrintf("private key:\n");
        for(unsigned int ii = 0 ; ii != privateKeyVec.size() ; ++ii)
            mexPrintf("%.2x", int( privateKeyVec[ii] ) );
        
        mexPrintf("\n");
        
        
        
        
                
        uint8_t p_publicKey[2048+1];
        uint8_t p_privateKey[1024];
        
        for(unsigned int ii = 0 ; ii != privateKeyVec.size() ; ++ii)
            p_privateKey[ii] = uint8_t( privateKeyVec[ii] );
        
        INTEGERPRINT(  uECC_x86_64   )
        INTEGERPRINT(  uECC_SUPPORT_COMPRESSED_POINT )   
        
        
                uECC_Curve  curve = uECC_secp256k1();
        //ecc_make_key( p_publicKey,p_privateKey );
        
        // const struct uECC_Curve_t curve = uECC_secp256k1();
        
        uECC_make_key( p_publicKey, p_privateKey, curve);
                  
        
        
        mexPrintf("public key:\n");
        for(unsigned int ii = 0 ; ii != 64 ; ++ii)
            mexPrintf("%.2x", int( p_publicKey[ii] ) );
        mexPrintf("\n");
        
        mexPrintf("private key:\n");
        for(unsigned int ii = 0 ; ii != privateKeyVec.size() ; ++ii)
            mexPrintf("%.2x", int( p_privateKey[ii] ) );
        mexPrintf("\n");
        
        
        
        
        
        plhs[0] = mxCreateDoubleMatrix(1, 1 , mxREAL);
        mxGetPr(plhs[0])[0] = double(99);
        
        
        
    }
    catch ( string mssg )
    {
        mexPrintf("%s\n", mssg.c_str() );
    }
    
}



