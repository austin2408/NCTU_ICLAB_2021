
`ifdef RTL
    `define CYCLE_TIME 10.0
`endif
`ifdef GATE
    `define CYCLE_TIME 10.0
`endif


module PATTERN(
    // Output signals
	clk,
    rst_n,
	in_valid,
	in,
    // Input signals
    out_valid,
    out
);

//================================================================ 
//   INPUT AND OUTPUT DECLARATION
//================================================================
output reg clk, rst_n, in_valid, in;

input out_valid;
input [1:0] out;
//================================================================
//    wires % registers
//================================================================
reg map [288:0];
//================================================================
//   parameters & integers
//================================================================
real CYCLE = `CYCLE_TIME;

integer total_cycles;
integer cycles;
integer PATNUM;
integer patcount;
integer gap;
integer input_file, output_file;
integer a, b, i;
integer current_x, current_y;
integer currect_location;
integer direction_num;
//================================================================
//    clock
//================================================================
always #(CYCLE/2.0) clk = ~clk;
initial clk = 0;
//================================================================
//    initial
//================================================================
initial begin
	rst_n    = 1'b1;
	in_valid = 1'b0;
	in       =  'bx;
	
	force clk = 0;
	
	total_cycles = 0;
	reset_signal_task;
	
	input_file  = $fopen("../00_TESTBED/input.txt","r");
//pragma protect begin_protected
//pragma protect key_keyowner=Cadence Design Systems.
//pragma protect key_keyname=CDS_KEY
//pragma protect key_method=RC5
//pragma protect key_block
L6Nzt9IoXXI9YArtdTtW1dqkvSK4IL+N1wJwN4H7AxjsMcuctuX3ZzQgJubpNJTB
bbAvPbULDkcYKXWDGYrsDai80Q5OcFOJMkc1iXMcYYC8niDZls4BemllN0euQQPo
o6CCDIT1QoIfLD3ZyziVD4T/UaXI4ECMmpwcx/1uo8+Xv+E6NMESVw==
//pragma protect end_key_block
//pragma protect digest_block
py8i9Hz4MfDBQzsUNCGYeQ3QP38=
//pragma protect end_digest_block
//pragma protect data_block
ac+g989VTa2FS0CBhvNlW0oRVOwvIPrSzpEBMog3aUjTJCj3noFkvT3kgwOzTmkq
mU5l77FlTdA7npficnSipOZsCx/+QaKq5qdeQo2qP7wAIfP/7pi6riSBQqFRXzQe
2qgiRY/KrPPNGWEDRVaBXvMT02vQexY0K5Ta9z0gQ2UQoZVjgY1IPRZKuffGxvIZ
/lnMvdt5C7mXo3iEDgYjsji+vo+Xq1Sm2IyCI/QE6ia830Fj/Sl5D6yFOyVtrnnS
NWEKavx2lfJ26MA7F1KSctml2K1sIyisBvwkqj816Gk8UGt+WY0bKbCaQtEVPaFW
AcOPDwmZ0uwxeJ8ddTiZTVFdE7dZr4WvFHXb1cbA/EknlX7AJ9QHDTI0aO+mzOAR
K01uoKFYSDmO3RZjN1izpsHPyvkVzq/xRzDQnS4MRJbVbt7tTfPoEfFcSi4NrzTe
F6z7c/OItkk2h71lxipIUU1Q+EGakZtC9Njj4Llo9HOPN8VEwYuetzcgFBzZS2B0
IMiUuK+bs7CC65W6dcWgPScZzKWvM+9fitQE+YWblfZenT362D0oqtBxoCF2kB0L
Tu7sh5cIf5yjLtq9T2cDIEkhTxEAAyOK8DS0d2RVmmW+1GjZVs3qzlqvvWv0mEdL
az0/md9gb2CBJchrBC8AVnbq7jEFu7j9FYCR/AsWaKw+pIGSFatLW1zyCshGG9iE
hDTQeSEp1rxSNxNbwrdMlPAPDLYwLIRSsfw0Lnkd3ffI0mlO3bcTuixbg9iVg5sb
LpwLrUQ0KfeJfZnpjofbZ6J+S0lNqOSwYloygKxsE7Fq7ACQIyWx0MRgaIx4f+1W
uwFmZUTgpy4a1139Letysmwgt+Q2rkxA5esVs6NEoSv7aMOL3mAc159SJ+SeVis4
dZY271AXyynfNzKK5WxiGONAHMU2NDc8I45abxHoUmVpeeBILhkXZMGzwldlBAJL
pzWIXq9NEEVKP9EtxHiPuodfZPW6AktATRkad9FYT5mBgTciWZ3UbEXYTf75v8YC
q2/Z2u915moIux4wZKX/CoHmdyxk/D7n0noD5GpH/C6dcpSQe/xUAPv1Z5Na38Cm
xsgmYFZo50Cpo83H3APpsLO5WhstNN6eZ1AtZHufKnG2xc+V50DE6mdAs2JPzOCT
3JOrFCaiNeuoDmr7khJMDRU+cILdLjF5xpzUvWzIpalhAeidnbOtCCXVzxmsnMBu
yf55yBkttu88KyTXlXDT0523Bm4u/gUNNVm8tOrYxtDBAT3+GhdT+vm9REKu/eh/
j7alCP2kxSiW8G9YUWje9uaDjwFD2VLArp47C1YRI29cg+pnGHvSxggTLxTAuJ1q
kcrqrB0yUe04XhHHKazO7fXD4WzGizNUCeyOrOj3l8QgwZFW1I3ATttdiqwUBeVo
IX0APqOT3+Y0vj/JThiXOTJFOEhxJzLVD/7nBqYaw6/Ok3x8kOo9Xfi3PsQ8UVNN
e+BOrZ8lYLCO4lFInrW4IL7aA7ID8Sg/d7XBqwGPKkUQBo/m3YuYDuGPP+RyPJbc
5LyTeZzguFXktovSUpiVdXQS0+eWrX5HP9oCJ4Mv0reRQLTL+2vxSNM7Iqc9bjlR
uLlwpwCdgqMN752wk8FFLtRFcURcdNws3obWYR1iQxAqe+DdLKr6YsR7HwWI1uzK
0qrwQzHB9dND3Bfc1HSoGLWSh+teTO3aig98qPpZxmt5DZQ/7xffRwJZlJgPKgMy
DxTukRrOL3L1zazxvE06JIMNRDWp70fZ2EqFoZpEho1Q5hHK4f4psW2fioHOkFE7
mJt4/ZOh8RV14xaAmvyz57Jh15xHkkPBsGHpaD6xS5lN8KSfF5MwzCIPw8RgwR9a
/hSU92r+dzUQKbgqVIJxnChs9oJe9NMq2XPij3nr7ip+PRLXRMBVbw8x3G0lRye9
AIWt01fEs7Bu3quqYfahPhpeCJ8I/SNZHifyT8Y9EvSFwz2tQ5BSf2C1FilGE1hZ
28NBClzZVDxMqItZjxnzhASYSKDVTWis/YdBd/6WfVCqisJZxBy7zLF0cdTva9XX
cBVQR7+kjXCx2Eq0JgMfcEWiBQxQeGt1SRvpTjrx+fZdGG1M+c6Pbxma61aHXnt5
LNc93NYZTGpwhKxW5es17W0axHGsovajm8b82HZtgIpz7WQIpLTa4kvn6kxn7b6z
3WkPhW7khh0ScoO9moSj2Dx4vvHXfR7bQjGPEvEJCdlCsBwp4JBpLJTSgHlBHJZg
uQnJURJB60KVFp4IikJSSSFxH6peHyqXoD9y5ixzCKd+6i7PGENT1UahS8lDy9OZ
3dbM5TqWwxzZvAMV9NCG0XXLO7YkOp5XX/u4u0viIhdVeoNaTDf896jo1wjEyk9n
xKdYiHA/F1qzc1alAJGRjLvZU/Xf3N+ubvOZjnY6rh8DnHIX3R0C/bgM7ciS1pg2
eP5rwtOqd/NhKUUbNOQyz78JP87UpTcX5gU82Y6OXZVxucXqq4+Z4WTJqIuriOHr
+/UhEkW39DzEtoH2yo4I+Z3+fW+fS7zWIfVV8mTwun2u9ZtecQDn2h5DnZ8ZPrOS
92kP8Hanl2Ov0rcEoillSP/fC6AUShIJ+QViBL5h7jpYjLpINcqMOCbkvJ8eC+pG
SWSraw7clo5xE+reTiCSiiHctSBSlzP5ynFtCLztFmmK39lxSW3FZsshbwdsYA6z
s+uB2pGzBZVHZic3zjJHnFsh5Z1gq8gLGwWwpIpaV8DvdmvA/UkSxDutVhA5mZFP
J4Y0XYqK33zl2QKGffORLEBPzS/jyJLaz/uonIk+EJc06zg3CMzdqWlHqpZbpq4N
KPOqzdApTzygKkYtNOLZrxjhzE3phfYou0ULevP6I1/+5VUp3SWZ4QxCxXrFNCiF
sLM51dY+g2Tl/GPl3XYPCH62fSSdrcJ++c1D4aBAvalyyeuBL8TyCadIJYpcv+E+
DfWUKUZSo8Tkw96+OaxBXLqKYUujldOWIkJh2B1kViilu3OlrxdsMrslJQZl2Qc0
4uQJUtHhrnuQhAoErjTcA208XnTEVw8CIFb99AsRUEFN0G6aJsmGQtcGV/KUVA2Y
y84CLbv5DZpnKaUouVK9DO7lv/7rO7fUfx282L30c0EGLJOIWyVIj1t08RfxfDb/
woWOpovh0lNc1Jk1wOFTZ+hchy/WuE2yXW0UKIoGRXTvY9G1bACyNGnToZXKbMNt
ZS6X+o9Dh0NewZDDsR3kNoCcGnZr3WarLS2x5IJIbdRX0KCfysOD1WwKb0rZ5J5/
xMZweRkZLW+7IVGEj9jfA7HCtGLUHrtS7kuQC9vANf55jGYywbwg6TtFTvcsZT12
Kb1v1u8U/jkIK0Xsfk5IaZYCA8HMxu8vnn1tZIVFN+KPnbuqiEuUemtDHziMVPvg
RLPkwd8FC06cGtkO6esXt9bFoocaVv+BMHon9afm7Nak0LnpEO+i+DTFzueAxQ7s
U8Z3gy53SksxIPt8r+B+kaBooX+sGLkeF8gbr7HbnKiCmJmDeXvAVaLVv6rW7V88
5jNxcvUFSGQ5l0upbpT0+c5B3bc0JGv2wUclqisqLQD4x1t0sCrE0Gm+1ROlK/RK
EgEXSCOBV9m4ee3NwQRxtoBkMiZUApl7F2sMoIPmrdBFBLCWW7wmoiyO70r+OQTX
jqgRDWAzJPHju1IpDJVffMLH4FGK7qqI4XjEwdNQWECPleksD72XVkPr8umgPot4
HnjVasmepf1X1XRjDkK6/8pEd1/83IpT3Z+iJQqE5avRXAD4YR588bav/ESZlhWA
D6uZX5muST4p9S3ZJEZ/SGJp3QyIgDvSxxFJthnGnbUczwLXTbGGnfuBcg2As7mS
VjWFbddZoIaUzChqFEGOOJg8QeSkw9fKb00HIq1KCJdFR8O6fqwRduVBE/3kvSH6
QkklAYavPhN/iR4escMJRrfILkAPvLtT+Tofr+QPDic4oyJwFGSx9XXmAJXGbs3H
SrjKMUhAP9R8E51Fn79QFGOZd6RetiXcotfwt78q5fZz80MVyrWBUAt/D/5lfeE0
wBvjoCVYA3pt/6Rzc1EEYSppTiFCUkmPczQF9J4EL8PcB/grZMxiKHbR0cq1OpkO
Pucp+anWgODUBNJbKyVUUvR2PU4+rnr4iFcL/TnM5SuSY0NmVTpgKLSHG96F4U+S
ygyt8nQHOM3xQMOCnwAtgVe9ZLMX+Xp6COeW3363zTbNQDX/UnEnXB+rArClzjX7
9DlPyUNjJpmlK5z5VrBrG+9gRxoO75n5HQSs7Iypp2unn40L5wfCrbaPJEq+W63B
C/U1P5OJ7WjOCw6dOvPJyyMS/W/pF/0pHFhmJGtpLv/8CfFIbvFjDxqwQB6Zag5E
sxnsyItR7RgNHTAB3viNuPDmDCScONO0bERGiEgdRuf33H/UnVR0tn4jFTNX/4jt
oe91RlbHHBmO+ED1sdcZ3EljI8Fnmua77yIVtszoOYcGGtLj7uihSarqdkhFUUBE
+gyLVgsfa+R4gysnKcgDtQ7yIHjWj9rxsMVoG7ZS0kU4ZYdY5fkccU/yCrl/CV0P
3W5hbUAT31wH7ITAJfPPoCln7qd7kO+dNQlAO/9G6Nf52kU0GB9YGIo6C4uSdeJl
94OrnmOhs3uq18X0o9txB2fnnmplTNYTNQjULQRwxq3Gzxy2bXsyrZ99U9DBITc5
APuZD/bKkF2TWmyZNOZf1iR8Gs9bNuQSsAI6OI1HzEvSXiVkbpsgvl772gcoblDH
3v3LpE7oXoO8AEhekR6skcGcflb3oS7nEzpxyZGhucJd0Q/izHHQ0j6ztO/BjOob
wX3EX7iyKkiWdG269BANlzB86hK1x4cOJtHY8Nu9vpLPXdC/0/99E0Y8eD2vozv5
8vP+p6tnGaN2+b9UQpPaZA6Itk98HcTOhs2eJLJkscONdL6Ci3BzjaOdUgMT80Dw
4kUfnuBLVOxODu7Hr/UKUr881R1Kxu9PuMYTL7qEUIiQiwtaOfBnc3sJuf91t+st
wF4FF5UHse8Jye21QPJRBoqg66nXo9kZPTKjZfM8Z/soIa732VU3/p0z8TgLWf+b
usd761hTRXqApn1yQGtp1ReaYyOLsdF2osacgOHtNABTlBWSA9bSgH+SrRrqxLMO
EIWi6B+uSgsiassj6YXQyqjuyYE4G/Nx0rjRN8wYpQ1L6F3VyqFhm4sWRCGqvoMA
ns6TGEFwVuWBAXXQftIIC5sDZKLn8N6JA9qw9vGZ7E6MITIUkhwfsqDhnwSEdmVi
csNHwj0IFuXaaOy+RSlbAM8qQN1//MRFlSmP4rKSrdaXCRdifJuig3QjM2l3o+25
6M5sZzRBLkE5em6O8kI8+t5q7Z8bFZTPCCiK7O296k6Z0T7yQpQsRunGCUybK+o4
3I7HHfUoHVMRXaRYIpWsIuHHf1ul/EEXoxHiar0M6uoD1/on5OQVgOSFBWef0gk/
NNu4omZj/FyNB8nDaCMdgzGaYr/4mgn0JC5FgGATdkVQRgYQoa7gSFJQyHEnmvYn
zwdqzvrjXvQiO2aaRfs5LMMm7Uj5v0QTyhpXndrqyzlc7GxfVg627rHv6N+qyWVa
T2KehrAfTcbsGRDS7BLGxrdgNB1vaVOQX94aVKFljQtV8zGE8MwKhjCryMNrTu9w
GSkt8kaeKnddG8RH0SGKG+35j1HaZlEvNEfFyZFWq15gPgFol5k/mNq/ijB8APtw
G/qDyS2Y+zqVpJcxUqtbIqAsO/9jxzu6LQZIAVnwHPrDvZz4+shtADknowN4s9Xz
FXnkYeMRCgBTL2ktHFMMMZwP8rAOvPVHzcRvev52Yk9xhiO3zfmkP7jSkWW0LLdO
cojykCHga2FO7rUQA4M/VFppBTD5m8+PsHUV54PcjSOkSJV66b73VuROAu6Ph00F
IXnot9VNjK7Y45MJzjt3HL0npldZHcdQZNHYj59kok4JEKV8sp2JOUkg5Dos+qBp
kruccPeVeUJQ+gB5fg2rtw7A0SBtZ9xye9kLGmdq/Y2/lHiCrqnI0NM6xRl9nvjF
kQ5G+n+iE4ToY9dzvPDhg0lgmyFZmUHCIsQM04W8fIBF5cIJeJ7PFppf6DkXUDAP
r7hF56ClWT/fYoEchU+uRjgmnbABXvbcDl8Sp8ipqTWPpp/lUSSRMHeRVf84XoJl
u+30WvJ4BhWDkWbK/n0dKpitKdF5Nga9KndAXr9kzqeC/iQWG8u0QjYmdqlrBp78
cBEQTc7WERgclpYZmcyN/0g4S28YTlHQM87fJZCDCN6uNPtz32/6Mtb2Lhm8P28H
hQEJH9zDhTUQHyTtHkd0pe53KB+eEr5CILalRB8uP4pGsUScI4yMD6PJCTsp7Ikc
YJ8NZ2NZ2IpzaNg6WPe5VIqyZEVylWFA2rScBqbX3+BHb23Hy5/lJLREaW1+2htN
qym2OSQ0IYXR0bKv9fC5HVSyEy2wSOWBzwVLJP2xvquWlCDWMYg8e9RuBytdQlFY
KzkHLaGitOMeNVI6cpq/QdrA240vBhN0z/+L8WRBMzSAdSN+6JynHUZtLBmaVTJ5
JCzJrC1m4mqyLNNq7lp1Ct1hefcsg+DqPHk1C9VTHgiCBGCJdjzLnpAWlbX21iE9
rt0dMD9gbc2IK1k/aEyF8ng5lmKAq/8cAyyW6pc1yV1PoskYBkChBRIHGB7xjxLb
OfjX8V5vPR6MaONMUIi9YqRLwY0Zrm2TXyNw3yCbWZyXYtsFhzc9+BaqYK+H2Jgu
WXdZ9Nte8Ppbfyz2pHq8pq8FUQh/yTG5MZSTGt+xZzbtOaE5MTkX/Ji0AIMzvhjN
Eb9gUkkNTBdHGjCwJA9qqh3ik6w5mEgmQoHs8a8a4uS9NAFp7B0HRfk0GtNQHmaT
Uyxvian2IjKjsBIigIhxvvA0+yConZjA0SjxGTsfWK4QczXQVes+GH1ZapMwJa1u
yimnErDD/mML+6K+bRTQ1TMji7dM9qbGL9wUnNbB8ixOJji6rFCzEys/81Z2+W3h
ERYZKrnp/K55nn22WKicm9o+bbeDFyeGbQhMz1JM7trt9yj+kPK5f5JPm0SrUPZ8
sTky9hkDoAjs+QVL6MtIpMNcZzyh69p2HuSoC8lxQ6Q1fkscv4iA2se4Pvtjqyry
I439BAMuW0ctngH5A9x5+WU1ZHDDaQQ54Zowl1tJ7qQ1rXqGpsTGjyv71bj+zxH8
iXhcP14ObP15tghkdqTYlKFpNLGKz4r0NzZZddBY06Cb6LrwK8uwPsdLb0qkdhgT
sLp2L7T+nLlheUkuzaU58OYeRvaAY/HX7qwD3t7jU48VoIgBDtZLj1+xx0UpBscK
Io+1yW/TnfvjohPdvw2Q7Z5OxbPDw7VXGQXJ7M2tnDVdGy4l3sopKX7atKjXlAD5
OreXOOfClG0F+sQkBpqm7TD83IeEuG2lAtyJ10sNIjOrsneipPVB8TH+YIIxVkDe
ozX5WOs2bTZdzqKx1k44/k8QcKrtfN+mK+Wd+SJOeqXofMvAQjLZq8fLCJx5KvL/
x2pFu+71lHE89BeU1B7BHQvUsS5IUFyokIG2ESl7PJ+DNy8skl/N8zV0Ut97AMCl
9YZFaYdq6WNklXf8BQWct2J+Wj8ORkSfLQDYco8PrfzX1SqRxuVAVwjy4g7bxdSw
S5She9ur1CCubm1lA3oFGpfBpcNBwLqMMsb5Vi+twuO2/XHXpfhsT5gRwnvFmcz/
luk4KD2EtPdZ9/y40ReGFQh7oxZbJs2HjyR+6YfET/a57ztFAkbCdIBD38depcWW
0xi8pLnyFsAslNnu2BOJ9pKdOYlPAVHXHZCWBSgTEfSPdElgFjdB/SIXfI0LAWrh
Iek4R/xcX0a5icCoFxv95kgEXuwhqx8yU/zGBKNkX8VSj3rAVRLc4rRo4dqBd3ff
xFhylDfR6eGrFzj4yFYTpqezVinLR9xHXOHOEqWPon8WmttQD+rCwBxxScYAxL41
WmvnE0bAlcrSkWWGCSJ5KCZRidFJkwhsMXy2ltNBN4DaxosEWSj7C3FTbSPwV6jz
UqgFj6apOenXTcbhaWUyXLlRcsBoMRdeiOdfrh4onAIr+kucoxiE1m78ezQlsnOz
/8y9fOG04+wDg140LNtf0aTS/9tsuQkZvie/+ELX1dZ+yo0oJYPHwo/DUihrkXkq
vu82vXrBUoG5CGC2WZeigAZCHQnjoqbhNTpj+J6Xl6MIJEWaL4Wb6wjgHtA9rLev
O1RBotLMb/bQ58ONKTievCbcdoplHpSoqIonR6WsabIlSBkgnqm20QEQVGRD+AgP
u8+81qC3q4bAzX99v/UPWywdCTvL1GrCm93NtDPVBN+ho6Azo9ubZo1RU6uYu7Ao
845d/5c4371jPm92qYF31sYE2/ZgIHq1Gpyk6bVt7XWBvaNk93vuanvglWF/xIpI
DlOjieQGXTFuBrO7OhY5qyNG82vjdXcI6ihcGjVNMfGZxh1V8Y9g4JC4rZVhbCUH
yZuvQtAEoMbEWd+qMnCFpKK/3ZsRzjlR0xniq+txUNO9bJJyoDJNtE6R/Vx9XkR1
U15SB3W2IlmEZJqCnHfT4k5BeYfF0BAOqAFJN16OjUoQjNVPfQ1BP+Xui3YaA1kQ
YghZn2FY9TC6fKN+C+UOx5fp+DxOU7SZds44g4aJmbyE+lfyrlS+qarYITNK0YgH
9h9MuN4nw9zg2UyMbF0tLnFUO8ACSX52Op7iOznxsrwvr77jw5Xh1xvb+YJi4GDN
DJP2tdEBGe0PUoFkZ2yEVbvMtVihE49fJDjtdY2xWAhHzU6HZ2C+rrefKfgS5SXs
aNFNOdurpz9PzMqB1TGmxmfMTIDkeSfag4XUa1PV591mDtKtPmzATqsT+e+GBHuV
fEy6Q7GLSej2bpnK80AEsYtCxc/e9IvQFREmS0RdEtGeczqI6owY+w4T0+2fRXbL
yVLmnBubW+nytBqB9WLKaS5BPAhxWWr69P6ckGDz/PUdb7C1tlWJmjwXLMArsvKz
e2LZAp3opcxWN4d4Y4Inr3WPR9Oshr7iof/Cm98fWjEtfmRqtjjDj3mpzhOVGKWW
6IqwuYBfkqfBDROI9TgjkfnOcohYaBb/kggSeFxMq/o4QdEJllwQnF2wDAmsaKIj
86GV0q4HM15COhmmBRKVyq6oBOvpeiwbzAgZcm4+UwUoSudsZMebq2x5ZaH8Owjf
rwTIbxSZ8kQsjOqY5XVXnD1RzMjn6MJtw8xIzp8zai4hYWIDw4X7V7CiOCsOHVqo
eGuJofxwZ+l9NezF/mEDJJWl1BX/ixQFqXaOpvb5Z6BVxRqxxt4zKtJY51cAFN+A
oz0lEmBcPQojFWb+54Ai1itp+1VwRMTfmalG5BMBMcmCMel/1AFva0YBrjx08Ldp
FdSih9qna7SJJoSQMC5kjLvOHlyLKS6GDMgqxjV6sz+0J+Crhc9ES5aiNWPertRw
AoTm148yZasy79ZUaujEKrEJ5+MifQ5bQb989esqGR17YLRmWybFSxyFxnh9EpiG
I+YIWs+inXf7qXtuXK9zLTPBjA7OI3gDtgy37aL+6nkMDdtTjZwzESQ/YSdHZwJB
Sak1GPmZhwzr6UUs1WygRi7CU62cGa9En/wkcT1tivkpLadLgxvfJ3Q40DMqpJyP
Xazv1p3iGvieq7m4Bua9wCZ9kw5elAG4n2JSH3hYDCem9z7wYxEROHQk5HuL3Zg7
NtL516vSz4iKErcnbapB7SlX8G/0CTj+4YV6CAsxvCrT+VBE/U7eaxNmzlq545O6
AtzhNQvpj046SAJcR4LOfe1hanz4af6+1DzXcb49oaP6qNQpeqsX/dXKjoPKgGJB
kxbeaThE1jNyAQzb86/Ncne4dt7UEFhi85q0VLdfGlpKLFu/0hi6ctth3/G0dK4q
wXb1MGr+sc3r0IY3Ll7WfLLpXGFhwHzpk30+xj7HufbQ7YRiw4cYBWi4Hyaimm6f
9kuyjcdOVI3qJRcCrzQyo5eKL3eZs+ZM6L5WGJaDUaTxcFTCe9Z6FP+xDrPPcue8
HE93jkNrW+Xg719mkbDmbWGX6CQJeLAzkKqvdKb24pnX+HOHb009jxzq4rypzyDo
HL9xKAE+2YOlCxv3cPiShUP5MFAQPvZ2+ZXCphL7HPRgsqd/BkPQZq/cvTz0SDBR
9rTNi+/HtsU5aXJvtkpHKXil12ZbT0BtqIBpjIG6Rzu/S+dVdGsm/OHRFSqx74/z
YeTNSlSOk5K4nbDW5JfFH7+sO8o18RH7xf/42mdxWrXx7qmLNUFTfLVRFxkmgiJF
tr/DmVwAZofZJw8FAN2imccM6cEBveArDGjlDutWINVgB4eNSRiDNN2C0y2t3N6S
Ox2Z6Vi7Gb3ub9XWCDzHYMBmDacyocKG6aLYAxz4rxIbtnH6/ar1eoAWDyHJvSaX
zwVP8MrIF62K6TPajmGJfTVMAoa7eZL8kvGnzVNsCnY1M0c3T51QP4Pig7iitCFc
DgbwtYJ3tbxN2SUNftmV5vjLJs9pzMCk4XwgyJJ6juKwqR+PxnjsaeeQHfJoKKh2
+KlZNJQ++aNfI0KXWbEmCAsw2jX/YZWsZ9/axMQ3+ohrYo1sfAU7ISu7WMYP0X8c
mtaXkTcsRBkm3EePtR+kqcH1mIu0y3fRFUlOxUvKfSIYFxi4UfJDu17EumxjqjvI
K/PXNor22Yp6Qk5ifQMB/EpZTaX4CG6IozQpUde8vwYJPxXDL6e76QDCU6KpOLw1
SrC6Faog4RtujZ+OytUqgrQOIfJTfGiV1fW0JbDdyMZ40CdefHkS/NKGaZE2I81j
VtEn/WS+A6VuZO5xT3142IjC30msr200Io7nEz8GymVMaAfhmYti9arVVk4DR/AU
MHOnuJqf0WiAhdhjf5q/+Qrq6dTX6AiKoB/EGzFwdxWXmNDHZSlt7Bdbp+93m2x0
C6CdWqcfZFBBTuYNbeQs80mB2YWlqjfPRYRSqj7CGeXa6BF7AMHQMdFhUVSzFcGA
jKrWjF6+yzhAOYMkCAoVp/Q/M6NwgeUmvhtr6M88tCq4IZvgA/8+sdtDP7t2JGFi
a8VTQItnKDwzzFGb6ppUv/UZMcMB7mUYhRFG+oOsQC/O5OvdbKFhi972+quMnSKH
ANYt8A/Yunvuantc1NzeacI0w5hGko8xO/sNlxD7p7y7Oo1cTTXLUl8GNsU7mR4h
tBMhdU2jJ+Me8dqSYJg8tTMD1aUgunFnYkde+xd6zEdMYlExGX8f2KUi+hE1EEQG
Gg97R45WF+Z2qliOCF/6JK8bpPLv0NoJE72ugvWFscJkspbNqOXa48mm0jqUEwT0
hKe08uFVKfKdT1ePcYU2MMSHiqAHceqM7TGRLDs4soTuQfydrObV5OlqYUJ+BKIo
GX868VPrOztVy0LgNxBk9aSaITOucbuTt7tT+N2acy4s5TkQdH6LgG8E+kNauyjD
pU0/H6XyiRW21lDR1NDJ97dEMNfVobsv0okzyG3G8/4qkx2nTBjrELTZRftQFHmb
3srPopjQNuvUFFgyPQ+oMyDlUL4sBZC3mDq+zXrzLUu/JQiJfSMFjUWgFYxgOTff
Giu2Y8ByRRmc2CuzxixFgHK5vFVcwUp9/HstoF6jAts3owu36tLrGk42D4DPS/3Q
b4B/pb+ZES/DBI+JYW0+y6d+ag+7ou62Jhd580IAY9decBvIeDp224gvKriwUMnB
2FqZZ5cXu+Ao8+Ok8ijqpNL7xUZ18H5DQVuUINTXdAKLFiC99zNeQx0JCOSLa6TF
RimM7tsliyWy3zZA7HjXZE7YvZweFYYD2yez06SZ/tCe3cj9DYEAy5r0AMjQKhfd
SHrYBOK9ky8SDDA5kWBclZNIhWQTMaG9ebLaZgTLyAFfIV00JG6o68yJc3hgwLL+
7eZnPUzugpmRCRkaNIFr0h44kC9+7pmuTbZduVKgL/If6cpN4L8XK9rIoftXpW9a
H4tCrh9ii2vfqTJOdtMX20Um3s1QGrS6iK7CioLT2/C7KrH3KwyFLlvAHYCkFFsm
NkMoAGc/qKWE44DYZoFulWmUsYGInMHpSHHd5W8HL2VkwkherXI+IAb5V6oQeiza
N51Iyd/OtPRZdJNurz12K5DXVq23R/243E+B+s9fdgv9D4dIxJvdOvQ2xFrLXpjT
ZLyxBqMUIxAyc1IHGcRUXdtKDu1roSFmxixQ1nRAJevFy0INXqgvrTRtM1ICXsNr
WSAvTWnekxxoQpfSDWxjlJT5UubRn7rwtbJaRXZdaQvpdpYSpyE+IHZ5xAPZHUsD
qi1ROHy9teATW6mDldoeOV3zmp2bJvGtw9i0A4fnG8DRs4HIvdSvd6RBDqyCVahy
HfH553bA4WHyw+t32sTEAGaoAqdvoN0ENILaYlHCmzv8URc7tUhjbleUCqa3/skg
NLKBFFXnSfkN32O2PTgN9iA6ICmqooWa4jsmDFrk0JuqUMOII3iod2Hep5qwAg8s
XAXhy+5BOvMC9pLusEq9c89Q0tgTCiFwg7EvdDz6TBZmtJgIAjAkp/I6+Dw992/f
V3Cmq3eLB8KqDWCWCap+mf3yliit/N8zhWyUXd6sP0Zd//w9TBZv5bV4T10eNcrY
YPN4YIaUflYx2GeSMlFfpkWgfUk8exw+fGNHPgnPvCbpEblKODOnsw/j3vLX4qoZ
UlNAL9ImubBojCE4NdcdKtiECtusYqg1EhMEZZaVLh6k2SEINPXPXvE2NeNvcR7i
C9fmuNjVKd7LGlvBIc7XqaMxeRGdifFJSXBA5lOAlZDIvtWyldDKUU+uXXBhU8QG
AO8lDMGATFM9NQVIMHVeVGCZ/b8RuH5FVnexkpimPEo7p/4Q8z4tS5iLe/DwQwX+
rN4ajorm9KYoxWmsdzs6LTKIsp56r+NDlHwXaLc3pI15OsA/cOfufHyJx/xmTpcI
x+KrDsGKO7HVYT/5Oi1bQHffeTaUxKgYxZImGc9WCjcXDnS/pKAK3H3VjTCZmlvE
LxBWNR75Oiy2QxvSis+9AO+ZtgzUUbEuiRhJBeVYJtEpS0E2f6vZWi5k1bJvb+vh
VByrffdXX4If+tE03ixj9AzIxUlPZ6JMqd3E6H12iKU9UIe90MF0mNKBH0umiZxl
ovhde6OD+uPXye+9p+DZdJPR++C97NMf/5kuqOqpWh/pkulExFGqk0mWTbcY8n8p
pKGBwEBIjn/X4+SGD9usTn2oVnc4SONokR5vSEk6Qgjj73eOOfK5aff9nFez/jMJ
izyQT+O1BfsqOoG8u/HalQcPzZUyWoS8iqJT61ITgIoJlcf6bEp6au+Rs6wLwyec
gobuSETR6PdO9ykH2YhDDZq8QTPjRIml3SHj10oPSjH2x7Cnn0vS+omRCelPi9LE
yOrwPKSwqGMwiE7U55ZDlA==
//pragma protect end_data_block
//pragma protect digest_block
gvNHel+6t83Qgp5t0EJCp5DsOZc=
//pragma protect end_digest_block
//pragma protect end_protected
