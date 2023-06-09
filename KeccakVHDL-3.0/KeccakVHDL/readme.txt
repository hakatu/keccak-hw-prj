-- The Keccak sponge function, designed by Guido Bertoni, Joan Daemen,
-- Michaël Peeters and Gilles Van Assche. For more information, feedback or
-- questions, please refer to our website: http://keccak.noekeon.org/

-- Implementation by the designers,
-- hereby denoted as "the implementer".

-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/

VERSION 3.0

Difference compared to the previous version:
- No difference in the vhdl, except the license
- new paddign scheme, test vector generation is in line with the new padding scheme



VERSION 2.0

Difference compared to the previous version:
- no structural differences
- The permutation is now composed of 24 rounds, so all the test vectors are different from the previos version
- the test bench is keccak_t.vhd is for the Keccak_f, so rate =1024 and output truncated to 256 bits
- C code is mor ein line with the reference C code, with a source folder and the Visual Studio project



The vhdl folder is composed of 3 subdirectories:
- test_vectors
- high_speed_core
- low_area_copro


TEST_VECTORS
In this directory you can find a copy of the reference code, where the files
KeccakPermutationReference.c and KeccakPermutationReference.h have been changed in order to produce test vector easily readable in the vhdl testbenches.

Three functions have been added in these files

1) KeccakPermutationIntermediateValuesForVHDL: 

This function creates intermediate values for testing the Keccak_f permutation;
It writes the input of the permutation to the file perm_in.txt
and the output of the permutation to the file perm_ref_out.txt
Ten applications of the permutation are used as test bench.

2) Keccak_testvector_for_VHDL:

This function generates test vectors readable in vhdl for the complete hash function, in this case limited to r=1024 and d=0 (Keccak_f). It writes the test vectors in keccak_in.txt and keccak_ref_out.txt. 
The file keccak_in.txt contains as a first line the number of inputs, each input is separated from the next by the â€“ character, while the . character is used as end of inputs
4000 messages are generated with random length.
This function calls a third function 

3) printPad_enc_Msg_rate1024_d_0:

for generating the padding of the message according to the spec of Keccak.

HIGH_SPEED_CORE

The high_speed_core directory contains vhdl file of the core and two test benches. 
Test bench files start with tb_
One test bench is dedicated to the permutation, it reads from the test_vectors directory the perm_in.txt file and produces a file perm_out_high_speed_core_vhdl.txt.
The output of the vhdl test bench has to be compared with the perm_ref_out.txt generated by the reference code

The second test bench reads input from the keccak_in.txt file and writes the results
to the file keccak_out_high_speed_vhdl.txt, to be compared with the keccak_ref_out.txt


LOW_AREA_COPRO

in this directory only one test bench is present, for testing the correct functionality of the permutation. The low area coprocessor is not equipped with the logic for performing the operations relative to the xor of the input message.

