#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <device_launch_parameters.h>
#include <cuda_runtime.h>
#define MAXKEYBYTES 	56          /* 448 bits */
#define N               16
#define noErr            0
#define DATAERROR       -1
#define KEYBYTES         8

#define checkCudaErrors(err)  __checkCudaErrors (err, __FILE__, __LINE__)
#define getLastCudaError(msg)  __getLastCudaError (msg, __FILE__, __LINE__)

inline void __checkCudaErrors(cudaError err, const char *file, const int line ) {
	if(cudaSuccess != err) {
    	fprintf(stderr, "%s(%i) : CUDA Runtime API error %d: %s.\n",file, line, (int)err, cudaGetErrorString( err ) );
        return ;        
    }
}
 
 // This will output the proper error string when calling cudaGetLastError
 
inline void __getLastCudaError(const char *errorMessage, const char *file, const int line ) {
	cudaError_t err = cudaGetLastError();
	if (cudaSuccess != err) {
        fprintf(stderr, "%s(%i) : getLastCudaError() CUDA error : %s : (%d) %s.\n",
        file, line, errorMessage, (int)err, cudaGetErrorString( err ) );
        return;
    }
}

uint32_t S[4][256] = { 
{0xd1310ba6L, 0x98dfb5acL, 0x2ffd72dbL, 0xd01adfb7L, 0xb8e1afedL, 0x6a267e96L,
0xba7c9045L, 0xf12c7f99L, 0x24a19947L, 0xb3916cf7L, 0x0801f2e2L, 0x858efc16L,
0x636920d8L, 0x71574e69L, 0xa458fea3L, 0xf4933d7eL, 0x0d95748fL, 0x728eb658L,
0x718bcd58L, 0x82154aeeL, 0x7b54a41dL, 0xc25a59b5L, 0x9c30d539L, 0x2af26013L,
0xc5d1b023L, 0x286085f0L, 0xca417918L, 0xb8db38efL, 0x8e79dcb0L, 0x603a180eL,
0x6c9e0e8bL, 0xb01e8a3eL, 0xd71577c1L, 0xbd314b27L, 0x78af2fdaL, 0x55605c60L,
0xe65525f3L, 0xaa55ab94L, 0x57489862L, 0x63e81440L, 0x55ca396aL, 0x2aab10b6L,
0xb4cc5c34L, 0x1141e8ceL, 0xa15486afL, 0x7c72e993L, 0xb3ee1411L, 0x636fbc2aL,
0x2ba9c55dL, 0x741831f6L, 0xce5c3e16L, 0x9b87931eL, 0xafd6ba33L, 0x6c24cf5cL,
0x7a325381L, 0x28958677L, 0x3b8f4898L, 0x6b4bb9afL, 0xc4bfe81bL, 0x66282193L,
0x61d809ccL, 0xfb21a991L, 0x487cac60L, 0x5dec8032L, 0xef845d5dL, 0xe98575b1L,
0xdc262302L, 0xeb651b88L, 0x23893e81L, 0xd396acc5L, 0x0f6d6ff3L, 0x83f44239L,
0x2e0b4482L, 0xa4842004L, 0x69c8f04aL, 0x9e1f9b5eL, 0x21c66842L, 0xf6e96c9aL,
0x670c9c61L, 0xabd388f0L, 0x6a51a0d2L, 0xd8542f68L, 0x960fa728L, 0xab5133a3L,
0x6eef0b6cL, 0x137a3be4L, 0xba3bf050L, 0x7efb2a98L, 0xa1f1651dL, 0x39af0176L,
0x66ca593eL, 0x82430e88L, 0x8cee8619L, 0x456f9fb4L, 0x7d84a5c3L, 0x3b8b5ebeL,
0xe06f75d8L, 0x85c12073L, 0x401a449fL, 0x56c16aa6L, 0x4ed3aa62L, 0x363f7706L,
0x1bfedf72L, 0x429b023dL, 0x37d0d724L, 0xd00a1248L, 0xdb0fead3L, 0x49f1c09bL,
0x075372c9L, 0x80991b7bL, 0x25d479d8L, 0xf6e8def7L, 0xe3fe501aL, 0xb6794c3bL,
0x976ce0bdL, 0x04c006baL, 0xc1a94fb6L, 0x409f60c4L, 0x5e5c9ec2L, 0x196a2463L,
0x68fb6fafL, 0x3e6c53b5L, 0x1339b2ebL, 0x3b52ec6fL, 0x6dfc511fL, 0x9b30952cL,
0xcc814544L, 0xaf5ebd09L, 0xbee3d004L, 0xde334afdL, 0x660f2807L, 0x192e4bb3L,
0xc0cba857L, 0x45c8740fL, 0xd20b5f39L, 0xb9d3fbdbL, 0x5579c0bdL, 0x1a60320aL,
0xd6a100c6L, 0x402c7279L, 0x679f25feL, 0xfb1fa3ccL, 0x8ea5e9f8L, 0xdb3222f8L,
0x3c7516dfL, 0xfd616b15L, 0x2f501ec8L, 0xad0552abL, 0x323db5faL, 0xfd238760L,
0x53317b48L, 0x3e00df82L, 0x9e5c57bbL, 0xca6f8ca0L, 0x1a87562eL, 0xdf1769dbL,
0xd542a8f6L, 0x287effc3L, 0xac6732c6L, 0x8c4f5573L, 0x695b27b0L, 0xbbca58c8L,
0xe1ffa35dL, 0xb8f011a0L, 0x10fa3d98L, 0xfd2183b8L, 0x4afcb56cL, 0x2dd1d35bL,
0x9a53e479L, 0xb6f84565L, 0xd28e49bcL, 0x4bfb9790L, 0xe1ddf2daL, 0xa4cb7e33L,
0x62fb1341L, 0xcee4c6e8L, 0xef20cadaL, 0x36774c01L, 0xd07e9efeL, 0x2bf11fb4L,
0x95dbda4dL, 0xae909198L, 0xeaad8e71L, 0x6b93d5a0L, 0xd08ed1d0L, 0xafc725e0L,
0x8e3c5b2fL, 0x8e7594b7L, 0x8ff6e2fbL, 0xf2122b64L, 0x8888b812L, 0x900df01cL,
0x4fad5ea0L, 0x688fc31cL, 0xd1cff191L, 0xb3a8c1adL, 0x2f2f2218L, 0xbe0e1777L,
0xea752dfeL, 0x8b021fa1L, 0xe5a0cc0fL, 0xb56f74e8L, 0x18acf3d6L, 0xce89e299L,
0xb4a84fe0L, 0xfd13e0b7L, 0x7cc43b81L, 0xd2ada8d9L, 0x165fa266L, 0x80957705L,
0x93cc7314L, 0x211a1477L, 0xe6ad2065L, 0x77b5fa86L, 0xc75442f5L, 0xfb9d35cfL,
0xebcdaf0cL, 0x7b3e89a0L, 0xd6411bd3L, 0xae1e7e49L, 0x00250e2dL, 0x2071b35eL,
0x226800bbL, 0x57b8e0afL, 0x2464369bL, 0xf009b91eL, 0x5563911dL, 0x59dfa6aaL,
0x78c14389L, 0xd95a537fL, 0x207d5ba2L, 0x02e5b9c5L, 0x83260376L, 0x6295cfa9L,
0x11c81968L, 0x4e734a41L, 0xb3472dcaL, 0x7b14a94aL, 0x1b510052L, 0x9a532915L,
0xd60f573fL, 0xbc9bc6e4L, 0x2b60a476L, 0x81e67400L, 0x08ba6fb5L, 0x571be91fL,
0xf296ec6bL, 0x2a0dd915L, 0xb6636521L, 0xe7b9f9b6L, 0xff34052eL, 0xc5855664L,
0x53b02d5dL, 0xa99f8fa1L, 0x08ba4799L, 0x6e85076aL},

{0x4b7a70e9L, 0xb5b32944L, 0xdb75092eL, 0xc4192623L, 0xad6ea6b0L, 0x49a7df7dL,
0x9cee60b8L, 0x8fedb266L, 0xecaa8c71L, 0x699a17ffL, 0x5664526cL, 0xc2b19ee1L,
0x193602a5L, 0x75094c29L, 0xa0591340L, 0xe4183a3eL, 0x3f54989aL, 0x5b429d65L,
0x6b8fe4d6L, 0x99f73fd6L, 0xa1d29c07L, 0xefe830f5L, 0x4d2d38e6L, 0xf0255dc1L,
0x4cdd2086L, 0x8470eb26L, 0x6382e9c6L, 0x021ecc5eL, 0x09686b3fL, 0x3ebaefc9L,
0x3c971814L, 0x6b6a70a1L, 0x687f3584L, 0x52a0e286L, 0xb79c5305L, 0xaa500737L,
0x3e07841cL, 0x7fdeae5cL, 0x8e7d44ecL, 0x5716f2b8L, 0xb03ada37L, 0xf0500c0dL,
0xf01c1f04L, 0x0200b3ffL, 0xae0cf51aL, 0x3cb574b2L, 0x25837a58L, 0xdc0921bdL,
0xd19113f9L, 0x7ca92ff6L, 0x94324773L, 0x22f54701L, 0x3ae5e581L, 0x37c2dadcL,
0xc8b57634L, 0x9af3dda7L, 0xa9446146L, 0x0fd0030eL, 0xecc8c73eL, 0xa4751e41L,
0xe238cd99L, 0x3bea0e2fL, 0x3280bba1L, 0x183eb331L, 0x4e548b38L, 0x4f6db908L,
0x6f420d03L, 0xf60a04bfL, 0x2cb81290L, 0x24977c79L, 0x5679b072L, 0xbcaf89afL,
0xde9a771fL, 0xd9930810L, 0xb38bae12L, 0xdccf3f2eL, 0x5512721fL, 0x2e6b7124L,
0x501adde6L, 0x9f84cd87L, 0x7a584718L, 0x7408da17L, 0xbc9f9abcL, 0xe94b7d8cL,
0xec7aec3aL, 0xdb851dfaL, 0x63094366L, 0xc464c3d2L, 0xef1c1847L, 0x3215d908L,
0xdd433b37L, 0x24c2ba16L, 0x12a14d43L, 0x2a65c451L, 0x50940002L, 0x133ae4ddL,
0x71dff89eL, 0x10314e55L, 0x81ac77d6L, 0x5f11199bL, 0x043556f1L, 0xd7a3c76bL,
0x3c11183bL, 0x5924a509L, 0xf28fe6edL, 0x97f1fbfaL, 0x9ebabf2cL, 0x1e153c6eL,
0x86e34570L, 0xeae96fb1L, 0x860e5e0aL, 0x5a3e2ab3L, 0x771fe71cL, 0x4e3d06faL,
0x2965dcb9L, 0x99e71d0fL, 0x803e89d6L, 0x5266c825L, 0x2e4cc978L, 0x9c10b36aL,
0xc6150ebaL, 0x94e2ea78L, 0xa5fc3c53L, 0x1e0a2df4L, 0xf2f74ea7L, 0x361d2b3dL,
0x1939260fL, 0x19c27960L, 0x5223a708L, 0xf71312b6L, 0xebadfe6eL, 0xeac31f66L,
0xe3bc4595L, 0xa67bc883L, 0xb17f37d1L, 0x018cff28L, 0xc332ddefL, 0xbe6c5aa5L,
0x65582185L, 0x68ab9802L, 0xeecea50fL, 0xdb2f953bL, 0x2aef7dadL, 0x5b6e2f84L,
0x1521b628L, 0x29076170L, 0xecdd4775L, 0x619f1510L, 0x13cca830L, 0xeb61bd96L,
0x0334fe1eL, 0xaa0363cfL, 0xb5735c90L, 0x4c70a239L, 0xd59e9e0bL, 0xcbaade14L,
0xeecc86bcL, 0x60622ca7L, 0x9cab5cabL, 0xb2f3846eL, 0x648b1eafL, 0x19bdf0caL,
0xa02369b9L, 0x655abb50L, 0x40685a32L, 0x3c2ab4b3L, 0x319ee9d5L, 0xc021b8f7L,
0x9b540b19L, 0x875fa099L, 0x95f7997eL, 0x623d7da8L, 0xf837889aL, 0x97e32d77L,
0x11ed935fL, 0x16681281L, 0x0e358829L, 0xc7e61fd6L, 0x96dedfa1L, 0x7858ba99L,
0x57f584a5L, 0x1b227263L, 0x9b83c3ffL, 0x1ac24696L, 0xcdb30aebL, 0x532e3054L,
0x8fd948e4L, 0x6dbc3128L, 0x58ebf2efL, 0x34c6ffeaL, 0xfe28ed61L, 0xee7c3c73L,
0x5d4a14d9L, 0xe864b7e3L, 0x42105d14L, 0x203e13e0L, 0x45eee2b6L, 0xa3aaabeaL,
0xdb6c4f15L, 0xfacb4fd0L, 0xc742f442L, 0xef6abbb5L, 0x654f3b1dL, 0x41cd2105L,
0xd81e799eL, 0x86854dc7L, 0xe44b476aL, 0x3d816250L, 0xcf62a1f2L, 0x5b8d2646L,
0xfc8883a0L, 0xc1c7b6a3L, 0x7f1524c3L, 0x69cb7492L, 0x47848a0bL, 0x5692b285L,
0x095bbf00L, 0xad19489dL, 0x1462b174L, 0x23820e00L, 0x58428d2aL, 0x0c55f5eaL,
0x1dadf43eL, 0x233f7061L, 0x3372f092L, 0x8d937e41L, 0xd65fecf1L, 0x6c223bdbL,
0x7cde3759L, 0xcbee7460L, 0x4085f2a7L, 0xce77326eL, 0xa6078084L, 0x19f8509eL,
0xe8efd855L, 0x61d99735L, 0xa969a7aaL, 0xc50c06c2L, 0x5a04abfcL, 0x800bcadcL,
0x9e447a2eL, 0xc3453484L, 0xfdd56705L, 0x0e1e9ec9L, 0xdb73dbd3L, 0x105588cdL,
0x675fda79L, 0xe3674340L, 0xc5c43465L, 0x713e38d8L, 0x3d28f89eL, 0xf16dff20L,
0x153e21e7L, 0x8fb03d4aL, 0xe6e39f2bL, 0xdb83adf7L},

{0xe93d5a68L, 0x948140f7L, 0xf64c261cL, 0x94692934L, 0x411520f7L, 0x7602d4f7L,
0xbcf46b2eL, 0xd4a20068L, 0xd4082471L, 0x3320f46aL, 0x43b7d4b7L, 0x500061afL,
0x1e39f62eL, 0x97244546L, 0x14214f74L, 0xbf8b8840L, 0x4d95fc1dL, 0x96b591afL,
0x70f4ddd3L, 0x66a02f45L, 0xbfbc09ecL, 0x03bd9785L, 0x7fac6dd0L, 0x31cb8504L,
0x96eb27b3L, 0x55fd3941L, 0xda2547e6L, 0xabca0a9aL, 0x28507825L, 0x530429f4L,
0x0a2c86daL, 0xe9b66dfbL, 0x68dc1462L, 0xd7486900L, 0x680ec0a4L, 0x27a18deeL,
0x4f3ffea2L, 0xe887ad8cL, 0xb58ce006L, 0x7af4d6b6L, 0xaace1e7cL, 0xd3375fecL,
0xce78a399L, 0x406b2a42L, 0x20fe9e35L, 0xd9f385b9L, 0xee39d7abL, 0x3b124e8bL,
0x1dc9faf7L, 0x4b6d1856L, 0x26a36631L, 0xeae397b2L, 0x3a6efa74L, 0xdd5b4332L,
0x6841e7f7L, 0xca7820fbL, 0xfb0af54eL, 0xd8feb397L, 0x454056acL, 0xba489527L,
0x55533a3aL, 0x20838d87L, 0xfe6ba9b7L, 0xd096954bL, 0x55a867bcL, 0xa1159a58L,
0xcca92963L, 0x99e1db33L, 0xa62a4a56L, 0x3f3125f9L, 0x5ef47e1cL, 0x9029317cL,
0xfdf8e802L, 0x04272f70L, 0x80bb155cL, 0x05282ce3L, 0x95c11548L, 0xe4c66d22L,
0x48c1133fL, 0xc70f86dcL, 0x07f9c9eeL, 0x41041f0fL, 0x404779a4L, 0x5d886e17L,
0x325f51ebL, 0xd59bc0d1L, 0xf2bcc18fL, 0x41113564L, 0x257b7834L, 0x602a9c60L,
0xdff8e8a3L, 0x1f636c1bL, 0x0e12b4c2L, 0x02e1329eL, 0xaf664fd1L, 0xcad18115L,
0x6b2395e0L, 0x333e92e1L, 0x3b240b62L, 0xeebeb922L, 0x85b2a20eL, 0xe6ba0d99L,
0xde720c8cL, 0x2da2f728L, 0xd0127845L, 0x95b794fdL, 0x647d0862L, 0xe7ccf5f0L,
0x5449a36fL, 0x877d48faL, 0xc39dfd27L, 0xf33e8d1eL, 0x0a476341L, 0x992eff74L,
0x3a6f6eabL, 0xf4f8fd37L, 0xa812dc60L, 0xa1ebddf8L, 0x991be14cL, 0xdb6e6b0dL,
0xc67b5510L, 0x6d672c37L, 0x2765d43bL, 0xdcd0e804L, 0xf1290dc7L, 0xcc00ffa3L,
0xb5390f92L, 0x690fed0bL, 0x667b9ffbL, 0xcedb7d9cL, 0xa091cf0bL, 0xd9155ea3L,
0xbb132f88L, 0x515bad24L, 0x7b9479bfL, 0x763bd6ebL, 0x37392eb3L, 0xcc115979L,
0x8026e297L, 0xf42e312dL, 0x6842ada7L, 0xc66a2b3bL, 0x12754cccL, 0x782ef11cL,
0x6a124237L, 0xb79251e7L, 0x06a1bbe6L, 0x4bfb6350L, 0x1a6b1018L, 0x11caedfaL,
0x3d25bdd8L, 0xe2e1c3c9L, 0x44421659L, 0x0a121386L, 0xd90cec6eL, 0xd5abea2aL,
0x64af674eL, 0xda86a85fL, 0xbebfe988L, 0x64e4c3feL, 0x9dbc8057L, 0xf0f7c086L,
0x60787bf8L, 0x6003604dL, 0xd1fd8346L, 0xf6381fb0L, 0x7745ae04L, 0xd736fcccL,
0x83426b33L, 0xf01eab71L, 0xb0804187L, 0x3c005e5fL, 0x77a057beL, 0xbde8ae24L,
0x55464299L, 0xbf582e61L, 0x4e58f48fL, 0xf2ddfda2L, 0xf474ef38L, 0x8789bdc2L,
0x5366f9c3L, 0xc8b38e74L, 0xb475f255L, 0x46fcd9b9L, 0x7aeb2661L, 0x8b1ddf84L,
0x846a0e79L, 0x915f95e2L, 0x466e598eL, 0x20b45770L, 0x8cd55591L, 0xc902de4cL,
0xb90bace1L, 0xbb8205d0L, 0x11a86248L, 0x7574a99eL, 0xb77f19b6L, 0xe0a9dc09L,
0x662d09a1L, 0xc4324633L, 0xe85a1f02L, 0x09f0be8cL, 0x4a99a025L, 0x1d6efe10L,
0x1ab93d1dL, 0x0ba5a4dfL, 0xa186f20fL, 0x2868f169L, 0xdcb7da83L, 0x573906feL,
0xa1e2ce9bL, 0x4fcd7f52L, 0x50115e01L, 0xa70683faL, 0xa002b5c4L, 0x0de6d027L,
0x9af88c27L, 0x773f8641L, 0xc3604c06L, 0x61a806b5L, 0xf0177a28L, 0xc0f586e0L,
0x006058aaL, 0x30dc7d62L, 0x11e69ed7L, 0x2338ea63L, 0x53c2dd94L, 0xc2c21634L,
0xbbcbee56L, 0x90bcb6deL, 0xebfc7da1L, 0xce591d76L, 0x6f05e409L, 0x4b7c0188L,
0x39720a3dL, 0x7c927c24L, 0x86e3725fL, 0x724d9db9L, 0x1ac15bb4L, 0xd39eb8fcL,
0xed545578L, 0x08fca5b5L, 0xd83d7cd3L, 0x4dad0fc4L, 0x1e50ef5eL, 0xb161e6f8L,
0xa28514d9L, 0x6c51133cL, 0x6fd5c7e7L, 0x56e14ec4L, 0x362abfceL, 0xddc6c837L,
0xd79a3234L, 0x92638212L, 0x670efa8eL, 0x406000e0L},

{0x3a39ce37L, 0xd3faf5cfL, 0xabc27737L, 0x5ac52d1bL, 0x5cb0679eL, 0x4fa33742L,
0xd3822740L, 0x99bc9bbeL, 0xd5118e9dL, 0xbf0f7315L, 0xd62d1c7eL, 0xc700c47bL,
0xb78c1b6bL, 0x21a19045L, 0xb26eb1beL, 0x6a366eb4L, 0x5748ab2fL, 0xbc946e79L,
0xc6a376d2L, 0x6549c2c8L, 0x530ff8eeL, 0x468dde7dL, 0xd5730a1dL, 0x4cd04dc6L,
0x2939bbdbL, 0xa9ba4650L, 0xac9526e8L, 0xbe5ee304L, 0xa1fad5f0L, 0x6a2d519aL,
0x63ef8ce2L, 0x9a86ee22L, 0xc089c2b8L, 0x43242ef6L, 0xa51e03aaL, 0x9cf2d0a4L,
0x83c061baL, 0x9be96a4dL, 0x8fe51550L, 0xba645bd6L, 0x2826a2f9L, 0xa73a3ae1L,
0x4ba99586L, 0xef5562e9L, 0xc72fefd3L, 0xf752f7daL, 0x3f046f69L, 0x77fa0a59L,
0x80e4a915L, 0x87b08601L, 0x9b09e6adL, 0x3b3ee593L, 0xe990fd5aL, 0x9e34d797L,
0x2cf0b7d9L, 0x022b8b51L, 0x96d5ac3aL, 0x017da67dL, 0xd1cf3ed6L, 0x7c7d2d28L,
0x1f9f25cfL, 0xadf2b89bL, 0x5ad6b472L, 0x5a88f54cL, 0xe029ac71L, 0xe019a5e6L,
0x47b0acfdL, 0xed93fa9bL, 0xe8d3c48dL, 0x283b57ccL, 0xf8d56629L, 0x79132e28L,
0x785f0191L, 0xed756055L, 0xf7960e44L, 0xe3d35e8cL, 0x15056dd4L, 0x88f46dbaL,
0x03a16125L, 0x0564f0bdL, 0xc3eb9e15L, 0x3c9057a2L, 0x97271aecL, 0xa93a072aL,
0x1b3f6d9bL, 0x1e6321f5L, 0xf59c66fbL, 0x26dcf319L, 0x7533d928L, 0xb155fdf5L,
0x03563482L, 0x8aba3cbbL, 0x28517711L, 0xc20ad9f8L, 0xabcc5167L, 0xccad925fL,
0x4de81751L, 0x3830dc8eL, 0x379d5862L, 0x9320f991L, 0xea7a90c2L, 0xfb3e7bceL,
0x5121ce64L, 0x774fbe32L, 0xa8b6e37eL, 0xc3293d46L, 0x48de5369L, 0x6413e680L,
0xa2ae0810L, 0xdd6db224L, 0x69852dfdL, 0x09072166L, 0xb39a460aL, 0x6445c0ddL,
0x586cdecfL, 0x1c20c8aeL, 0x5bbef7ddL, 0x1b588d40L, 0xccd2017fL, 0x6bb4e3bbL,
0xdda26a7eL, 0x3a59ff45L, 0x3e350a44L, 0xbcb4cdd5L, 0x72eacea8L, 0xfa6484bbL,
0x8d6612aeL, 0xbf3c6f47L, 0xd29be463L, 0x542f5d9eL, 0xaec2771bL, 0xf64e6370L,
0x740e0d8dL, 0xe75b1357L, 0xf8721671L, 0xaf537d5dL, 0x4040cb08L, 0x4eb4e2ccL,
0x34d2466aL, 0x0115af84L, 0xe1b00428L, 0x95983a1dL, 0x06b89fb4L, 0xce6ea048L,
0x6f3f3b82L, 0x3520ab82L, 0x011a1d4bL, 0x277227f8L, 0x611560b1L, 0xe7933fdcL,
0xbb3a792bL, 0x344525bdL, 0xa08839e1L, 0x51ce794bL, 0x2f32c9b7L, 0xa01fbac9L,
0xe01cc87eL, 0xbcc7d1f6L, 0xcf0111c3L, 0xa1e8aac7L, 0x1a908749L, 0xd44fbd9aL,
0xd0dadecbL, 0xd50ada38L, 0x0339c32aL, 0xc6913667L, 0x8df9317cL, 0xe0b12b4fL,
0xf79e59b7L, 0x43f5bb3aL, 0xf2d519ffL, 0x27d9459cL, 0xbf97222cL, 0x15e6fc2aL,
0x0f91fc71L, 0x9b941525L, 0xfae59361L, 0xceb69cebL, 0xc2a86459L, 0x12baa8d1L,
0xb6c1075eL, 0xe3056a0cL, 0x10d25065L, 0xcb03a442L, 0xe0ec6e0eL, 0x1698db3bL,
0x4c98a0beL, 0x3278e964L, 0x9f1f9532L, 0xe0d392dfL, 0xd3a0342bL, 0x8971f21eL,
0x1b0a7441L, 0x4ba3348cL, 0xc5be7120L, 0xc37632d8L, 0xdf359f8dL, 0x9b992f2eL,
0xe60b6f47L, 0x0fe3f11dL, 0xe54cda54L, 0x1edad891L, 0xce6279cfL, 0xcd3e7e6fL,
0x1618b166L, 0xfd2c1d05L, 0x848fd2c5L, 0xf6fb2299L, 0xf523f357L, 0xa6327623L,
0x93a83531L, 0x56cccd02L, 0xacf08162L, 0x5a75ebb5L, 0x6e163697L, 0x88d273ccL,
0xde966292L, 0x81b949d0L, 0x4c50901bL, 0x71c65614L, 0xe6c6c7bdL, 0x327a140aL,
0x45e1d006L, 0xc3f27b9aL, 0xc9aa53fdL, 0x62a80f00L, 0xbb25bfe2L, 0x35bdd2f6L,
0x71126905L, 0xb2040222L, 0xb6cbcf7cL, 0xcd769c2bL, 0x53113ec0L, 0x1640e3d3L,
0x38abbd60L, 0x2547adf0L, 0xba38209cL, 0xf746ce76L, 0x77afa1c5L, 0x20756060L,
0x85cbfe4eL, 0x8ae88dd8L, 0x7aaaf9b0L, 0x4cf9aa7eL, 0x1948c25cL, 0x02fb8a8cL,
0x01c36ae4L, 0xd6ebe1f9L, 0x90d4f869L, 0xa65cdea0L, 0x3f09252dL, 0xc208e69fL,
0xb74e6132L, 0xce77e25bL, 0x578fdfe3L, 0x3ac372e6L}
};

uint32_t P[18] = {
0x243f6a88L, 0x85a308d3L, 0x13198a2eL, 0x03707344L, 0xa4093822L, 0x299f31d0L,
0x082efa98L, 0xec4e6c89L, 0x452821e6L, 0x38d01377L, 0xbe5466cfL, 0x34e90c6cL,
0xc0ac29b7L, 0xc97c50ddL, 0x3f84d5b5L, 0xb5470917L, 0x9216d5d9L, 0x8979fb1bL};


void checkbuffer(uint32_t *buf, int size) {
	int i;
	for (i = 0; i < size; i++) {
		printf("%d: %x\n", i, buf[i]);
	}
}

uint32_t F(uint32_t x) {
	unsigned short a;
	unsigned short b;
	unsigned short c;
	unsigned short d;
	uint32_t  y;
	d = x & 0x00FF;
	x >>= 8;
	c = x & 0x00FF;
	x >>= 8;
	b = x & 0x00FF;
	x >>= 8;
	a = x & 0x00FF;
	y = S[0][a] + S[1][b];
	y = y ^ S[2][c];
	y = y + S[3][d];
	return y;
}

void Blowfish_encipher(uint32_t *xl, uint32_t *xr) {
	uint32_t  Xl;
	uint32_t  Xr;
	uint32_t  temp;
	short i;
	Xl = *xl;
	Xr = *xr;
	for (i = 0; i < N; ++i) {
		Xl = Xl ^ P[i];
		Xr = F(Xl) ^ Xr;
		temp = Xl;
		Xl = Xr;
		Xr = temp;
	}
	temp = Xl;
	Xl = Xr;
	Xr = temp;
	Xr = Xr ^ P[N];
	Xl = Xl ^ P[N + 1];
	*xl = Xl;
	*xr = Xr;
}

void Blowfish_decipher(uint32_t *xl, uint32_t *xr) {
	uint32_t  Xl;
	uint32_t  Xr;
	uint32_t  temp;
	short i;
	Xl = *xl;
	Xr = *xr;
	for (i = N + 1; i > 1; --i) {
		Xl = Xl ^ P[i];
		Xr = F(Xl) ^ Xr;
		/* Exchange Xl and Xr */
		temp = Xl;
		Xl = Xr;
		Xr = temp;
	}
	/* Exchange Xl and Xr */
	temp = Xl;
	Xl = Xr;
	Xr = temp;
	Xr = Xr ^ P[1];
	Xl = Xl ^ P[0];
	*xl = Xl;
	*xr = Xr;
}

short InitializeBlowfish(char key[], short keybytes) {
	short i;
	short j;
	short k;
	// short error;
	// short numread;
	uint32_t data;
	uint32_t datal;
	uint32_t datar;
	j = 0;
	for (i = 0; i < N + 2; ++i) {
		data = 0x00000000;
		for (k = 0; k < 4; ++k) {
			data <<= 8;
			data |= (uint32_t)key[j] & 0xff;
			j = j + 1;
			if (j >= keybytes) j = 0;
		}
		P[i] = P[i] ^ data;
	}
	datal = 0x00000000;
	datar = 0x00000000;
	for (i = 0; i < N + 2; i += 2) {
		Blowfish_encipher(&datal, &datar);
		P[i] = datal;
		P[i + 1] = datar;
	}
    	for (i = 0; i < 4; ++i) {
    		for (j = 0; j < 256; j += 2) {
    			Blowfish_encipher(&datal, &datar);
    			S[i][j] = datal;
    			S[i][j + 1] = datar;
    		}
    	}
    //printf("Done!\n");
    //printf("P[0]: %x\n", P[0]);
    //printf("P[1]: %x\n", P[1]);
    return 0;
}

// encrypt is 1, decrypt is 0
void FileEncrypt(uint32_t *out, uint32_t *in, int size, int encrypt) {
	int i;
	memset(out, 0, size);
	memcpy(out, in, size);
	if (encrypt) {
		for (i = 0; i < size/sizeof(uint32_t)-1; i+=2) {
			Blowfish_encipher(&out[i], &out[i+1]);
		}
	}
	else {
		for (i = 0; i < size/sizeof(uint32_t)-1; i+=2) {
			Blowfish_decipher(&out[i], &out[i+1]);
		}		
	}
}

__global__ void GpuFileEncrypt(uint32_t *out, uint32_t *in, uint32_t *d_s, uint32_t *d_p) {
	// since there is no computation related other data within a block(e.g. the situations which are like 
	// matrix multiplication, sorting, reversing etc, where we need manipulate multiple block data), so
	// I don't see any reason why we should use shared mem for the block data. I see p and s should be loaded into
	// shared memory because they are frequently used during the loop.
	__shared__ uint32_t s[1042]; // p 18 + s 1024 = 1042
	unsigned int tid = threadIdx.x;
	unsigned int gid = blockIdx.x * blockDim.x + tid;
	unsigned int copy_s_begin_index = tid * 1024 / blockDim.x;
	unsigned int copy_s_end_index = (tid + 1) * 1024 / blockDim.x;
	int i = 0;
	if (tid == 0) {
		for (i = 0; i < 18; i++) {
			s[i] = d_p[i];
		}
	}
	__syncthreads();
	for (i = copy_s_begin_index; i < copy_s_end_index; i++) {
		s[i + 18] = d_s[i];
	}
	__syncthreads();
	uint32_t xl = in[2 * gid];
	uint32_t xr = in[2 * gid + 1];
	uint32_t temp;
	unsigned short a;
	unsigned short b;
	unsigned short c;
	unsigned short d;
	uint32_t x, y;
	for (i = 0; i < 16; ++i) {
		xl = xl ^ s[i];
		x = xl;
		d = x & 0x00FF;
		x >>= 8;
		c = x & 0x00FF;
		x >>= 8;
		b = x & 0x00FF;
		x >>= 8;
		a = x & 0x00FF;
		//y = S[0][a] + S[1][b];
		y = s[a + 18] + s[256 + b + 18];
		//y = y ^ S[2][c];
		y = y ^ s[512 + c + 18];
		//y = y + S[3][d];
		y = y + s[768 + d + 18];
		xr = y ^ xr;
		// swap xl and xr
		temp = xl;
		xl = xr;
		xr = temp;
	}
	temp = xl;
	xl = xr;
	xr = temp;
	xr = xr ^ s[16];
	xl = xl ^ s[17];
	out[2 * gid] = xl;
	out[2 * gid + 1] = xr;
}

__global__ void GpuFileDecrypt(uint32_t *out, uint32_t *in, uint32_t *d_s, uint32_t *d_p) {
	// since there is no computation related other data within a block(e.g. the situations which are like 
	// matrix multiplication, sorting, reversing etc, where we need manipulate multiple block data), so
	// I don't see any reason why we should use shared mem for the block data. I see p and s should be loaded into
	// shared memory because they are frequently used during the loop.
	__shared__ uint32_t s[1042]; // p 18 + s 1024 = 1042
	unsigned int tid = threadIdx.x;
	unsigned int gid = blockIdx.x * blockDim.x + tid;
	unsigned int copy_s_begin_index = tid * 1024 / blockDim.x;
	unsigned int copy_s_end_index = (tid + 1) * 1024 / blockDim.x;
	int i = 0;
	if (tid == 0) {
		for (i = 0; i < 18; i++) {
			s[i] = d_p[i];
		}
	}
	__syncthreads();
	for (i = copy_s_begin_index; i < copy_s_end_index; i++) {
		s[i + 18] = d_s[i];
	}
	__syncthreads();
	uint32_t xl = in[2 * gid];
	uint32_t xr = in[2 * gid + 1];
	uint32_t temp;
	unsigned short a;
	unsigned short b;
	unsigned short c;
	unsigned short d;
	uint32_t x, y;
	for (i = 17; i > 1; --i) {
		xl = xl ^ s[i];
		x = xl;
		d = x & 0x00FF;
		x >>= 8;
		c = x & 0x00FF;
		x >>= 8;
		b = x & 0x00FF;
		x >>= 8;
		a = x & 0x00FF;
		//y = S[0][a] + S[1][b];
		y = s[a + 18] + s[256 + b + 18];
		//y = y ^ S[2][c];
		y = y ^ s[512 + c + 18];
		//y = y + S[3][d];
		y = y + s[768 + d + 18];
		xr = y ^ xr;
		/* Exchange Xl and Xr */
		temp = xl;
		xl = xr;
		xr = temp;
	}
	/* Exchange Xl and Xr */
	temp = xl;
	xl = xr;
	xr = temp;
	xr = xr ^ s[1];
	xl = xl ^ s[0];
}

void example () {
	uint32_t datal = 0xFFFFFFFF;
	uint32_t datar = 0xFFFFFFFF;
	printf("Clean text %#x%x\n", datal, datar);
	Blowfish_encipher(&datal, &datar);
	printf("Cipher text %#x%x\n", datal, datar);
	Blowfish_decipher(&datal, &datar);
	printf("Decipher text %#x%x\n", datal, datar); 	
}

int main()
{
	char key[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}; 
	short keybytes = 8;
	InitializeBlowfish(key, keybytes);
	const char * path1 = "Test2Image.jpg";
	const char * path2 = "Test2Image_out1.jpg";
	const char * path3 = "Test2Image_out2.jpg";
	FILE *in, *out;
	int file_size = 0;
	int encrypt;
	printf("start of the program: press 1: encrypt, press 0 decrypt\n");
	scanf("%d", &encrypt);
	if (encrypt != 0 && encrypt != 1) {
		printf("the encrypt/decrypt input is not correct\n");
		return 0;
	}
	if (encrypt == 1) in = fopen(path1, "rb");
	else in = fopen(path2, "rb");
	if (in == NULL) {
		printf("error: the input file is not open\n");
		return 0;
	}
	fseek(in, 0L, SEEK_END);
	file_size = ftell(in);
	rewind(in);
	uint32_t *buffer_in = (uint32_t *)malloc(file_size);
	uint32_t *buffer_out = (uint32_t *)malloc(file_size);
	if (buffer_in == NULL || buffer_out == NULL) {
		printf("the buffers allocate memory failed!\n");
		return 0;
	}
	int byte_read_success = fread((void *)buffer_in, sizeof(char), file_size, in);
	if (byte_read_success != file_size) {
		printf("byte_read_success: %d\n", byte_read_success);
		printf("file read is abnormal: bytes read not equals to the file size\n");
		return 0;
	}
	fclose(in);
	// read file done
	memcpy(buffer_out, buffer_in, file_size);
	// GPU mem allocation, timer, device synchronization, etc
	cudaSetDevice(0);
    	cudaDeviceSynchronize();
    	cudaThreadSynchronize();
	cudaEvent_t start, stop;
	float time;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	uint32_t *d_in, *d_out;
	uint32_t *d_p, *d_s;
	int mem_size = sizeof(uint32_t) * (file_size/sizeof(uint32_t) - 1);
	// determine num of threads, block per grids, threads per block
	// one thread should take charge of 2 uint_32t numbers
	int total_launch_threads = mem_size/(sizeof(uint32_t) * 2);
	dim3 threadsPerBlock(16, 1, 1); // 16 ~ 1024 though
	dim3 blocksPerGrid(total_launch_threads/threadsPerBlock.x, 1, 1);
	checkCudaErrors(cudaMalloc((void**) &d_in, mem_size));
	checkCudaErrors(cudaMalloc((void**) &d_out, mem_size));
	checkCudaErrors(cudaMalloc((void**) &d_s, 4 * 256 * sizeof(uint32_t)));
	checkCudaErrors(cudaMalloc((void**) &d_p, 18 * sizeof(uint32_t)));
	// CPU->GPU mem transfer: if mem transfer time should be counted, then cudaEventRecords should move above to the comment
	checkCudaErrors(cudaMemcpy(d_in, buffer_in, mem_size, cudaMemcpyHostToDevice));
	checkCudaErrors(cudaMemcpy(d_s, S, 4*256 * sizeof(uint32_t), cudaMemcpyHostToDevice)); // NOT sure if this is correct
	checkCudaErrors(cudaMemcpy(d_p, P, 18 * sizeof(uint32_t), cudaMemcpyHostToDevice));
	cudaEventRecord(start, 0);
	if (encrypt == 1) GpuFileEncrypt<<<blocksPerGrid, threadsPerBlock>>> (d_out, d_in, d_s, d_p);
	else GpuFileDecrypt<<<blocksPerGrid, threadsPerBlock>>> (d_out, d_in, d_s, d_p);
	cudaEventRecord(stop, 0);
	cudaEventElapsedTime(&time, start, stop);
	// encrypt/decrypt done
	// GPU->CPU mem trasfer: if mem transfer time should be counted, then cudaEventRecords should move below to the comment
	checkCudaErrors(cudaMemcpy(buffer_out, d_out, mem_size, cudaMemcpyDeviceToHost));
	// GPU mem deallocation
	cudaFree(d_s);
	cudaFree(d_p);
	cudaFree(d_in);
	cudaFree(d_out);
	// open output file
	if (encrypt == 1) out = fopen(path2, "wb");
	else out = fopen(path3, "wb");
	if (out == NULL) {
		printf("error: the output file is not open\n");
		return 0;
	}
	int byte_write_success = fwrite((void *)buffer_out, sizeof(char), file_size, out);
	if (byte_write_success != (file_size)) {
		printf("byte_write_success: %d\n", byte_write_success);
		printf("file write is abnormal: bytes write not equals to the file size\n");
		return 0;
	}
	if (encrypt == 1) printf ("file encryption took %6.3f milliseconds.\n", time * 1000);
	else printf ("file decryption took %6.3f milliseconds.\n", time * 1000);
	fclose(out);
	free(buffer_in);
	free(buffer_out);
	return 0;
}
