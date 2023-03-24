Content
-------

Keccak implementation in Python, supporting the FIPS 202 standard instances.

First implementation:
	- Keccak.py : the Keccak and KeccakError classes
	- demo_KeccakF.py : example of use of Keccak_f function on a 0-filled 5×5 matrix
	- demo_TestVectors.py : verification of test vectors. The test vectors must be copied in the same location as the Python files. They can be downloaded from https://github.com/gvanas/KeccakCodePackage/tree/master/TestVectors (ShortMsgKAT_SHAKE*.txt and ShortMsgKAT_SHA3*.txt).

Second implementation:
    - CompactFIPS202.py : a readable and compact implementation of the FIPS 202 instances
    - CompactFIPS202-test.py : verification of test vectors, similarly to demo_TestVectors.py


Few words of explanation on the first implementation
------------------------

The Keccak module is stateless. It takes your inputs, performs the computation and returns the result.


Typical uses
------------

1) Compute a hash using SHAKE128 (400 bits of output) on '00112233445566778899AABBCCDDEEFF' (8*16bits=128 bits)

>>> import Keccak
>>> myKeccak=Keccak.Keccak()
>>> myKeccak.Keccak((128,'00112233445566778899AABBCCDDEEFF'),1344,256,0x1F,400,True)

Create a Keccak[r=1344, c=256] function with '1111' suffix

After appending the suffix:  [132, '00112233445566778899AABBCCDDEEFF0F']

String ready to be absorbed: 00112233445566778899AABBCCDDEEFF1F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080 (will be completed by 32 x '00')

Current value of state: Before first round
        ['0x7766554433221100', '0xffeeddccbbaa9988', '0x1f', '0x0', '0x0']
        ['0x0', '0x0', '0x0', '0x0', '0x0']
        ['0x0', '0x0', '0x0', '0x0', '0x0']
        ['0x0', '0x0', '0x0', '0x0', '0x0']
        ['0x8000000000000000', '0x0', '0x0', '0x0', '0x0']
Current value of state: Satus end of round #1/24
        ['0xdc77ee5456dd06dd', '0x2113ef7664544332', '0x7e6e5e6e7eee1e6e', '0x8019e64c47970000', '0xba218b329803a91']
        ['0x566998886aa11005', '0xa8846666601eeaaa', '0xe335dddaaffcc99e', '0x4227deecaaa88664', '0xb77bbffb976bbffb']
        ['0x111111110511116c', '0x371dfb48aa8463d1', '0x22455510b645fe10', '0xddba8867553201e6', '0x4c3bf7a26e39d65']
        ['0xcb3621d00f72271c', '0x13f17c0eb95bbdb5', '0x885510cc8844fbdd', '0x2ed47cc543b21aa3', '0x2b41100ff0899883']
        ['0xdfeab78448bfe256', '0x87e62308992232cc', '0x778854f722dd0022', '0x8804819c991590ea', '0xdd995510cc8844fb']
<...>
Current value of state: Satus end of round #24/24
        ['0xb30541a680bec220', '0xf5110e91a6901d48', '0x9362a7fe90af532f', '0xdf16c0a5da3087a9', '0xfa2106ca4043071e']
        ['0x9b3f79616ccf48a8', '0x151b62cffedaf4a3', '0xed9e49ebe4fbf282', '0xf9bd01bcae1ae061', '0xc913be2fad5823af']
        ['0x6d3f1585f6497d99', '0x9806cbd975aebe62', '0xfbf2cced9d551964', '0x368d1f3528edb87d', '0x4682107f2e57079a']
        ['0xc487edd5b71df34a', '0x2a5d9ceec682383', '0x59d65ae1fb46d56e', '0xe9afd7353d371ca8', '0xeea24b4cdfececd4']
        ['0x1622a6a1696ac9ba', '0x24cc0902083f7db7', '0xb30a5f7d575a75b0', '0x550176a0fdb55dc8', '0xd95daac4ae5c3201']

Value after absorption : 20C2BE80A64105B3481D90A6910E11F52F53AF90FEA76293A98730DAA5C016DF1E074340CA0621FAA848CF6C61793F9BA3F4DAFECF621B1582F2FBE4EB499EED61E01AAEBC01BDF9AF2358AD2FBE13C9997D49F685153F6D62BEAE75D9CB06986419559DEDCCF2FB7DB8ED28351F8D369A07572E7F1082464AF31DB7D5ED87C4832368ECCED9A5026ED546FBE15AD659A81C373D35D7AFE9D4ECECDF4C4BA2EEBAC96A69A1A62216B77D3F080209CC24B0755A577D5F0AB3C85DB5FDA076015501325CAEC4AA5DD9

Value after squeezing : 20C2BE80A64105B3481D90A6910E11F52F53AF90FEA76293A98730DAA5C016DF1E074340CA0621FAA848CF6C61793F9BA3F4DAFECF621B1582F2FBE4EB499EED61E01AAEBC01BDF9AF2358AD2FBE13C9997D49F685153F6D62BEAE75D9CB06986419559DEDCCF2FB7DB8ED28351F8D369A07572E7F1082464AF31DB7D5ED87C4832368ECCED9A5026ED546FBE15AD659A81C373D35D7AFE9D4ECECDF4C4BA2EEBAC96A69A1A62216B77D3F080209CC24B0755A577D5F0AB3C85DB5FDA076015501325CAEC4AA5DD9

'20C2BE80A64105B3481D90A6910E11F52F53AF90FEA76293A98730DAA5C016DF1E074340CA0621FAA848CF6C61793F9BA3F4'


2) Computation of the Keccak-f function on an all-zero state

>>> import Keccak
>>> A=[[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
>>> myKeccak=Keccak.Keccak(1600)
>>> myKeccak.Keccakf(A, True)
>>> myKeccak.printState(A,'Final result')

Current value of state: Before first round
        ['0x0', '0x0', '0x0', '0x0', '0x0']
        ['0x0', '0x0', '0x0', '0x0', '0x0']
        ['0x0', '0x0', '0x0', '0x0', '0x0']
        ['0x0', '0x0', '0x0', '0x0', '0x0']
        ['0x0', '0x0', '0x0', '0x0', '0x0']
Current value of state: Satus end of round #1/24
        ['0x1L', '0x0L', '0x0L', '0x0L', '0x0L']
        ['0x0L', '0x0L', '0x0L', '0x0L', '0x0L']
        ['0x0L', '0x0L', '0x0L', '0x0L', '0x0L']
        ['0x0L', '0x0L', '0x0L', '0x0L', '0x0L']
        ['0x0L', '0x0L', '0x0L', '0x0L', '0x0L']
<...>
Current value of state: Satus end of round #24/24
        ['0xf1258f7940e1dde7L', '0x84d5ccf933c0478aL', '0xd598261ea65aa9eeL', '0xbd1547306f80494dL', '0x8b284e056253d057L']
        ['0xff97a42d7f8e6fd4L', '0x90fee5a0a44647c4L', '0x8c5bda0cd6192e76L', '0xad30a6f71b19059cL', '0x30935ab7d08ffc64L']
        ['0xeb5aa93f2317d635L', '0xa9a6e6260d712103L', '0x81a57c16dbcf555fL', '0x43b831cd0347c826L', '0x1f22f1a11a5569fL']
        ['0x5e5635a21d9ae61L', '0x64befef28cc970f2L', '0x613670957bc46611L', '0xb87c5a554fd00ecbL', '0x8c3ee88a1ccf32c8L']
        ['0x940c7922ae3a2614L', '0x1841f924a2c509e4L', '0x16f53526e70465c2L', '0x75f644e97f30a13bL', '0xeaf1ff7b5ceca249L']

[[17376452488221285863L, 18417369716475457492L, 16959053435453822517L, 424854978622500449L, 10668034807192757780L], [9571781953733
019530L, 10448040663659726788L, 12224711289652453635L, 7259519967065370866L, 1747952066141424100L], [15391093639620504046L, 101139
17136857017974L, 9342009439668884831L, 7004910057750291985L, 1654286879329379778L], [13624874521033984333L, 12479658147685402012L,
 4879704952849025062L, 13293599522548616907L, 8500057116360352059L], [10027350355371872343L, 3500241080921619556L, 140226327413610
143L, 10105770293752443592L, 16929593379567477321L]]

