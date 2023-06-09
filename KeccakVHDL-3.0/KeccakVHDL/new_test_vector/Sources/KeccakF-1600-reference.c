/*
The Keccak sponge function, designed by Guido Bertoni, Joan Daemen,
Michaël Peeters and Gilles Van Assche. For more information, feedback or
questions, please refer to our website: http://keccak.noekeon.org/

Implementation by the designers,
hereby denoted as "the implementer".

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

#include <stdio.h>
#include <string.h>
#include "brg_endian.h"
#include "displayIntermediateValues.h"
#include "KeccakNISTInterface.h"
#include "KeccakF-1600-interface.h"

typedef unsigned char UINT8;
typedef unsigned long long int UINT64;

#define nrRounds 24
UINT64 KeccakRoundConstants[nrRounds];
#define nrLanes 25
unsigned int KeccakRhoOffsets[nrLanes];

void KeccakPermutationOnWords(UINT64 *state);
void theta(UINT64 *A);
void rho(UINT64 *A);
void pi(UINT64 *A);
void chi(UINT64 *A);
void iota(UINT64 *A, unsigned int indexRound);

void fromBytesToWords(UINT64 *stateAsWords, const unsigned char *state)
{
    unsigned int i, j;

    for(i=0; i<(KeccakPermutationSize/64); i++) {
        stateAsWords[i] = 0;
        for(j=0; j<(64/8); j++)
            stateAsWords[i] |= (UINT64)(state[i*(64/8)+j]) << (8*j);
    }
}

void fromWordsToBytes(unsigned char *state, const UINT64 *stateAsWords)
{
    unsigned int i, j;

    for(i=0; i<(KeccakPermutationSize/64); i++)
        for(j=0; j<(64/8); j++)
            state[i*(64/8)+j] = (stateAsWords[i] >> (8*j)) & 0xFF;
}

void KeccakPermutation(unsigned char *state)
{
#if (PLATFORM_BYTE_ORDER != IS_LITTLE_ENDIAN)
    UINT64 stateAsWords[KeccakPermutationSize/64];
#endif

    displayStateAsBytes(1, "Input of permutation", state);
#if (PLATFORM_BYTE_ORDER == IS_LITTLE_ENDIAN)
    KeccakPermutationOnWords((UINT64*)state);
#else
    fromBytesToWords(stateAsWords, state);
    KeccakPermutationOnWords(stateAsWords);
    fromWordsToBytes(state, stateAsWords);
#endif
    displayStateAsBytes(1, "State after permutation", state);
}

void KeccakPermutationAfterXor(unsigned char *state, const unsigned char *data, unsigned int dataLengthInBytes)
{
    unsigned int i;

    for(i=0; i<dataLengthInBytes; i++)
        state[i] ^= data[i];
    KeccakPermutation(state);
}

void KeccakPermutationOnWords(UINT64 *state)
{
    unsigned int i;

    displayStateAs64bitWords(3, "Same, with lanes as 64-bit words", state);

    for(i=0; i<nrRounds; i++) {
        displayRoundNumber(3, i);

        theta(state);
        displayStateAs64bitWords(3, "After theta", state);

        rho(state);
        displayStateAs64bitWords(3, "After rho", state);

        pi(state);
        displayStateAs64bitWords(3, "After pi", state);

        chi(state);
        displayStateAs64bitWords(3, "After chi", state);

        iota(state, i);
        displayStateAs64bitWords(3, "After iota", state);
    }
}

#define index(x, y) (((x)%5)+5*((y)%5))
#define ROL64(a, offset) ((offset != 0) ? ((((UINT64)a) << offset) ^ (((UINT64)a) >> (64-offset))) : a)

void theta(UINT64 *A)
{
    unsigned int x, y;
    UINT64 C[5], D[5];

    for(x=0; x<5; x++) {
        C[x] = 0; 
        for(y=0; y<5; y++) 
            C[x] ^= A[index(x, y)];
    }
    for(x=0; x<5; x++)
        D[x] = ROL64(C[(x+1)%5], 1) ^ C[(x+4)%5];
    for(x=0; x<5; x++)
        for(y=0; y<5; y++)
            A[index(x, y)] ^= D[x];
}

void rho(UINT64 *A)
{
    unsigned int x, y;

    for(x=0; x<5; x++) for(y=0; y<5; y++)
        A[index(x, y)] = ROL64(A[index(x, y)], KeccakRhoOffsets[index(x, y)]);
}

void pi(UINT64 *A)
{
    unsigned int x, y;
    UINT64 tempA[25];

    for(x=0; x<5; x++) for(y=0; y<5; y++)
        tempA[index(x, y)] = A[index(x, y)];
    for(x=0; x<5; x++) for(y=0; y<5; y++)
        A[index(0*x+1*y, 2*x+3*y)] = tempA[index(x, y)];
}

void chi(UINT64 *A)
{
    unsigned int x, y;
    UINT64 C[5];

    for(y=0; y<5; y++) { 
        for(x=0; x<5; x++)
            C[x] = A[index(x, y)] ^ ((~A[index(x+1, y)]) & A[index(x+2, y)]);
        for(x=0; x<5; x++)
            A[index(x, y)] = C[x];
    }
}

void iota(UINT64 *A, unsigned int indexRound)
{
    A[index(0, 0)] ^= KeccakRoundConstants[indexRound];
}

int LFSR86540(UINT8 *LFSR)
{
    int result = ((*LFSR) & 0x01) != 0;
    if (((*LFSR) & 0x80) != 0)
        // Primitive polynomial over GF(2): x^8+x^6+x^5+x^4+1
        (*LFSR) = ((*LFSR) << 1) ^ 0x71;
    else
        (*LFSR) <<= 1;
    return result;
}

void KeccakInitializeRoundConstants()
{
    UINT8 LFSRstate = 0x01;
    unsigned int i, j, bitPosition;

    for(i=0; i<nrRounds; i++) {
        KeccakRoundConstants[i] = 0;
        for(j=0; j<7; j++) {
            bitPosition = (1<<j)-1; //2^j-1
            if (LFSR86540(&LFSRstate))
                KeccakRoundConstants[i] ^= (UINT64)1<<bitPosition;
        }
    }
}

void KeccakInitializeRhoOffsets()
{
    unsigned int x, y, t, newX, newY;

    KeccakRhoOffsets[index(0, 0)] = 0;
    x = 1;
    y = 0;
    for(t=0; t<24; t++) {
        KeccakRhoOffsets[index(x, y)] = ((t+1)*(t+2)/2) % 64;
        newX = (0*x+1*y) % 5;
        newY = (2*x+3*y) % 5;
        x = newX;
        y = newY;
    }
}

void KeccakInitialize()
{
    KeccakInitializeRoundConstants();
    KeccakInitializeRhoOffsets();
}

void displayRoundConstants(FILE *f)
{
    unsigned int i;

    for(i=0; i<nrRounds; i++) {
        fprintf(f, "RC[%02i][0][0] = ", i);
        fprintf(f, "%08X", (unsigned int)(KeccakRoundConstants[i] >> 32));
        fprintf(f, "%08X", (unsigned int)(KeccakRoundConstants[i] & 0xFFFFFFFFULL));
        fprintf(f, "\n");
    }
    fprintf(f, "\n");
}

void displayRhoOffsets(FILE *f)
{
    unsigned int x, y;

    for(y=0; y<5; y++) for(x=0; x<5; x++) {
        fprintf(f, "RhoOffset[%i][%i] = ", x, y);
        fprintf(f, "%2i", KeccakRhoOffsets[index(x, y)]);
        fprintf(f, "\n");
    }
    fprintf(f, "\n");
}

void KeccakInitializeState(unsigned char *state)
{
    memset(state, 0, KeccakPermutationSizeInBytes);
}

#ifdef ProvideFast576
void KeccakAbsorb576bits(unsigned char *state, const unsigned char *data)
{
    KeccakPermutationAfterXor(state, data, 72);
}
#endif

#ifdef ProvideFast832
void KeccakAbsorb832bits(unsigned char *state, const unsigned char *data)
{
    KeccakPermutationAfterXor(state, data, 104);
}
#endif

#ifdef ProvideFast1024
void KeccakAbsorb1024bits(unsigned char *state, const unsigned char *data)
{
    KeccakPermutationAfterXor(state, data, 128);
}
#endif

#ifdef ProvideFast1088
void KeccakAbsorb1088bits(unsigned char *state, const unsigned char *data)
{
    KeccakPermutationAfterXor(state, data, 136);
}
#endif

#ifdef ProvideFast1152
void KeccakAbsorb1152bits(unsigned char *state, const unsigned char *data)
{
    KeccakPermutationAfterXor(state, data, 144);
}
#endif

#ifdef ProvideFast1344
void KeccakAbsorb1344bits(unsigned char *state, const unsigned char *data)
{
    KeccakPermutationAfterXor(state, data, 168);
}
#endif

void KeccakAbsorb(unsigned char *state, const unsigned char *data, unsigned int laneCount)
{
    KeccakPermutationAfterXor(state, data, laneCount*8);
}

#ifdef ProvideFast1024
void KeccakExtract1024bits(const unsigned char *state, unsigned char *data)
{
    memcpy(data, state, 128);
}
#endif

void KeccakExtract(const unsigned char *state, unsigned char *data, unsigned int laneCount)
{
    memcpy(data, state, laneCount*8);
}

//following function added for VHDL test benches

// this function is exactly as the one used in 2.0 release, the permutation function is not changed

int KeccakPermutationIntermediateValuesForVHDL()
{
		int x,y,i,j,num_tests=10;
	UINT64 A[KeccakPermutationSize/64];
	FILE *fp_p_in, *fp_p_out;

	//open files for wirintg inputs and output
	if ( (fp_p_in = fopen("perm_in.txt", "w")) == NULL ) {
		printf("Couldn't open <perm_in.txt> \n");
		return -1;
	}

	if ( (fp_p_out = fopen("perm_ref_out.txt", "w")) == NULL ) {
		printf("Couldn't open <perm_ref_out.txt> \n");
		return -1;
	}

	KeccakInitialize();
	for(y=0;y<5;y++)
		for(x=0;x<5;x++)
			A[index(x,y)]=0;
	for(j=0;j<num_tests;j++)
	{
		//write input to file
		for(y=0;y<5;y++)
			for(x=0;x<5;x++)
				fprintf(fp_p_in, "%016I64X\n", A[index(x,y)]);
		fprintf(fp_p_in, "-\n");

		for(i=0;i<nrRounds;i++)
		{		
			theta(A);
			rho(A);
			pi(A);
			chi(A);
			iota(A,i);
			//write output to file
			//for(y=0;y<5;y++)
			//	for(x=0;x<5;x++)
			//		fprintf(fp_p_out, "%016I64X\n", A[index(x,y)]);
			//fprintf(fp_p_out, "-\n");

		}
		for(y=0;y<5;y++)
			for(x=0;x<5;x++)
				fprintf(fp_p_out, "%016I64X\n", A[index(x,y)]);
		fprintf(fp_p_out, "-\n");

		for(i=0;i<nrRounds;i++)
		{		
			theta(A);			
			rho(A);
			pi(A);						
			chi(A);
			iota(A,i);
			//write output to file
			//for(y=0;y<5;y++)
			//	for(x=0;x<5;x++)
			//		fprintf(fp_p_out, "%016I64X\n", A[index(x,y)]);
			//fprintf(fp_p_out, "-\n");

		}

		//gen new input
	}
	fprintf(fp_p_in, ".\n");
	fclose(fp_p_in);
	return 0;

}


// the next two function are replaced by the function moved in the mainReference.c 

/*
int printPad_enc_Msg_rate1024_d_0(FILE *fp_k_in, const BitSequence *data, DataLength databitlen, BitSequence *paddedMsg)

{
	unsigned char padByte,mask,tail[16];
	int j,k,rate,capacity,diversifier,remainder;
	DataLength i;
	
	capacity = 576;
	//if you want to use other capacity add a case here and an input paramter for it

	diversifier=0;
	rate = KeccakPermutationSize - capacity;
	i=0;
	//print the words of the message 
	if(databitlen>63)
	{

		for(i=0;i<(databitlen/64);i++)
		{
			for(k=0;k<8;k++)
				fprintf(fp_k_in,"%02X",data[i*8+(7-k)]);			
			fprintf(fp_k_in,"\n");
		}
	}
	

	//tail of the message
	for(k=0;k<16;k++)
		tail[k]=0x00;

	//k keeps the number of char printed for carriege return
	k=0;
	//i bits already printed
	i=i*64;
	if((databitlen-i)>7)
	{
		
		for(k=0;k<((databitlen-i)/8);k++)
			tail[7-k]=data[i/8+k];
			//fprintf(fp_k_in,"%02X",data[i/8+k]);		
	}

	//print the remnainder of the message and padding

	if ((databitlen % 8) != 0) {
		// The bits are numbered from 0=LSB to 7=MSB
		mask=0xff;
		padByte = (data[databitlen/8] >> (8-(databitlen % 8))) | (1 << (databitlen % 8));
		if(k<8)
			tail[7-k]=padByte;
		else
			tail[15-(k-8)]=padByte;
		//fprintf(fp_k_in,"%02X", padByte);

	}
	else {
		//fprintf(fp_k_in,"01");        
		if(k<8)
			tail[7-k]=0x01;
		else
			tail[15-(k-8)]=0x01;
	}
	k++;

	//print diversifier


	//fprintf(fp_k_in,"%02X",diversifier);
	if(k<8)
			tail[7-k]=diversifier;
		else
			tail[15-(k-8)]=diversifier;
	
	k++;

	//fprintf(fp_k_in,"%02X", rate/8);
	if(k<8)
		tail[7-k]=rate/8;
	else
		tail[15-(k-8)]=rate/8;
	
	k++;

	// last padding with 10*
	//fprintf(fp_k_in,"01");
	if(k<8)
		tail[7-k]=0x01;
	else
		tail[15-(k-8)]=0x01;

	k++;	
	//print tail
	for(j=0;j<8;j++)
		fprintf(fp_k_in,"%02X",tail[j]);
	fprintf(fp_k_in,"\n");
	if(k>8)
	{
		for(j=8;j<16;j++)
			fprintf(fp_k_in,"%02X",tail[j]);
		fprintf(fp_k_in,"\n");	
		k=16;
	}
	else
	{
		k=8;
	}
	

	//compute remainders to be printed, 64 bits word

	remainder=((2*rate)/64-((databitlen%rate)/64 +k/8))%(rate/64);
	for(j=0;j<remainder;j++)
	{
		for(k=0;k<8;k++)
			fprintf(fp_k_in,"00");
		fprintf(fp_k_in,"\n");
	}	

	return SUCCESS;


}

int Keccak_testvector_for_VHDL()
{
	hashState state;
    HashReturn result;
	DataLength msglenght;
	int i,j,k,num_tests=10;
	FILE *fp_k_out;
	FILE *fp_k_in;
	BitSequence	Msg[4000], MD[64];
		//test for full keccak hw test 

	//open files for wirintg inputs and output
	if ( (fp_k_in = fopen("keccak_in.txt", "w")) == NULL ) {
		printf("Couldn't open <keccak_in.txt> \n");
		return -1;
	}


	if ( (fp_k_out = fopen("keccak_ref_out.txt", "w")) == NULL ) {
		printf("Couldn't open <perm_in.txt> \n");
		return -1;
	}
	fprintf(fp_k_in,"%d\n",num_tests);
	

	for(i=0;i<num_tests;i++)
	{
		for(j=0;j<4000;j++)
			Msg[j]=(char) rand();
		//msglenght=(rand())%4000;		
		msglenght=16;
		printPad_enc_Msg_rate1024_d_0(fp_k_in, Msg, msglenght , MD);
		fprintf(fp_k_in,"-\n");

		//Hash(256, Msg, msglenght, MD);
		result=Init(&state, 0);
		if (result != SUCCESS)
			return result;
		result=Update(&state, Msg, msglenght);
		if (result != SUCCESS)
			return result;
		result=Final(&state, MD);
		if (result != SUCCESS)
			return result;
		result=Squeeze(&state, MD, 256);
		if (result != SUCCESS)
			return result;







		for(j=0;j<256/64;j++)
		{
			for(k=0;k<8;k++)
				fprintf(fp_k_out,"%02X", MD[j*8+(7-k)]);
			fprintf(fp_k_out,"\n");

		}
		fprintf(fp_k_out, "-\n");
	}
	fprintf(fp_k_in, ".\n");
	printf("\n");

	return 0;
}
*/