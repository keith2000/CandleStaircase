//KeccakHashMex

//Any line starting with "//@@//" is providing information (dependencies) to the Matlab function MexCompile. Directories are assumed to be include directories
//source code

//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\SHA-3\CommandParser.cpp')
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\SHA-3\Keccak.cpp')
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\SHA-3\HashFunction.cpp')
//include directories:
//@@//FormFilename('C:\Dropbox (Fairtree Newlands)\Library\SHA-3\')



//"C:\Users\keith\Documents\GitHub\SHA-3\Keccak.cpp"





#include <vector>
#include "Keccak.h"




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
        const int prhsByteVec =	__LINE__-lineOffset1;
        const int prhsHashSize =	__LINE__-lineOffset1;
        const int numMatlabInputs =	__LINE__-lineOffset1;
        
        
        
        
        
        MSASSERT(numMatlabInputs==nrhs);
        MSASSERT( 1==mxGetNumberOfElements( prhs[prhsHashSize] )  );
        
        
        vector<double> doubleVec;
        UnpackSimpleMatlabDoubleVector(doubleVec, prhs[prhsByteVec]  );
        
        
        mexPrintf("input byte vector:\n");
        for(unsigned int ii = 0 ; ii != doubleVec.size() ; ++ii)
            mexPrintf("%.2x", int( doubleVec[ii] ) );
        
        mexPrintf("\n");
        
        
        
        unsigned int hashSize = unsigned int( mxGetPr( prhs[prhsHashSize]  )[0] );
        keccakState *st = keccakCreate(hashSize);
        
        
//         const int  mySize = 64;
//         char *buf = new char[mySize];
//            for(unsigned int ii = 0 ; ii != doubleVec.size() ; ++ii)
//              buf[ii] = uint8_t( char( doubleVec[ii]  ));
//         
        
        vector<uint8_t> byteVec( doubleVec.size() );
           for(unsigned int ii = 0 ; ii != doubleVec.size() ; ++ii)
             byteVec[ii] = uint8_t( char( doubleVec[ii]  ));
        
        
         
        //unsigned int bytesRead = fread(buf, 1, bufferSize, fHand);
        
        
        keccakUpdate((uint8_t*)(&byteVec[0]), 0, byteVec.size(), st);
        
        
        //keccakUpdate( (uint8_t*)(&doubleVec[0]), 0, mySize, st);
        
        
        plhs[0] = mxCreateDoubleMatrix(1, hashSize/8 , mxREAL);
        
        unsigned char *op = keccakDigest(st);
        for(unsigned int i = 0 ; i != (hashSize/8) ; i++)
        {
          //  mexPrintf("%.2x", *(op++));
            mxGetPr(plhs[0])[i] = op[i];
        }
        //mexPrintf("\n");
        
        
        
        
        
        
        
        //#define BLAH word
//cout << ;
        
        
    }
    catch ( string mssg )
    {
        mexPrintf("%s\n", mssg.c_str() );
    }
    
}



