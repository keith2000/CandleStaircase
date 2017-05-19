//EthereumKeyPair2Mex

//Any line starting with "//@@//" is providing information (dependencies) to the Matlab function MexCompile. Directories are assumed to be include directories
//source code

//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\SHA-3\CommandParser.cpp')
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\SHA-3\Keccak.cpp')
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\SHA-3\HashFunction.cpp')
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\easy-ecc-master\ecc2.c')
//include directories:
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\SHA-3\')
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\easy-ecc-master')


//"C:\Users\keith\Documents\GitHub\SHA-3\Keccak.cpp"





#include <vector>

#include "Keccak.h"

#include "ecc.h"

// unsigned int hashType = 0;
// unsigned int hashWidth = 512;
// unsigned int shakeDigestLength = 512;
// unsigned int sha3widths[] = {224, 256, 384, 512, 0};
// unsigned int keccakwidths[] = {224, 256, 384, 512, 0};
// unsigned int shakewidths[] = {128, 256, 0};
//
// unsigned int bufferSize = 1024 * 4;
// char *buf = NULL;




extern "C" {
#include "mex.h"
}


#define DOUBLEPRINT(str) mexPrintf("%% %s: %g\n", #str, str );
#define BOOLPRINT(str) mexPrintf("%% %s: %s\n", #str, str?"true":"false" );
#define INTEGERPRINT(str) mexPrintf("%% %s: %d\n", #str, str );
#include <string>
#define MSASSERT(str) if (!(str)) throw(string("failed assertion:") + string(#str));
#define DRAWNOW mexEvalString("drawnow");



#define STRINGIFY(x) #x
#define STRINGIFYMACRO(y) STRINGIFY(y)

#define BLAH word


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
        
        
        
        unsigned int hashSize = 512;
        keccakState *st = keccakCreate(hashSize);
        
        
        const int        mySize = 3;
        char *buf = new char[mySize];
        buf[0] = 1;
        buf[1] = 1;
        buf[2] = 1;
        
        //unsigned int bytesRead = fread(buf, 1, bufferSize, fHand);
        
        
        keccakUpdate((uint8_t*)buf, 0, mySize, st);
        
        
        uint8_t p_publicKey[2048+1];
        uint8_t p_privateKey[1024];
        
        for(unsigned int ii = 0 ; ii != privateKeyVec.size() ; ++ii)
            p_privateKey[ii] = uint8_t( privateKeyVec[ii] );
        
        
        ecc_make_key( p_publicKey,p_privateKey );
        
        
        mexPrintf("public key:\n");
        for(unsigned int ii = 0 ; ii != 64 ; ++ii)
            mexPrintf("%.2x", int( p_publicKey[ii] ) );
        mexPrintf("\n");
        
        mexPrintf("private key:\n");
        for(unsigned int ii = 0 ; ii != privateKeyVec.size() ; ++ii)
            mexPrintf("%.2x", int( p_privateKey[ii] ) );
        mexPrintf("\n");
        
        
        
        //for(unsigned int ii = 0 ; ii != privateKeyVec.size() ; ++ii)
        //p_privateKey[ii] = uint8_t( privateKeyVec[ii] );
        
        
        unsigned char *op = keccakDigest(st);
        
        //mexPrintf("Keccak-%u %s: ", hashSize, fileName);
        for(unsigned int i = 0 ; i != (hashSize/8) ; i++)
        {
            mexPrintf("%.2x", *(op++));
        }
        mexPrintf("\n");
        
        
        // mexPrintf("%s\n", STRINGIFY( CRYPTOPP_RSA_H ) );
        
        
        
        plhs[0] = mxCreateDoubleMatrix(1, 1 , mxREAL);
        mxGetPr(plhs[0])[0] = double(99);
        
        //#define BLAH word
//cout << ;
        
        
    }
    catch ( string mssg )
    {
        mexPrintf("%s\n", mssg.c_str() );
    }
    
}



