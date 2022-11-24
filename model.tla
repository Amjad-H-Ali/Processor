------------------------------- MODULE model -------------------------------
EXTENDS Integers, Naturals, Sequences, TLC, TLAPS

CONSTANT N

ASSUME NNAT == N \in Nat



BVN == [0..N -> {TRUE,FALSE}]

ANDN == [f \in BVN |-> [g \in BVN |-> [i \in 0..N |-> f[i] /\ g[i]]]]

ORN == [f \in BVN |-> [g \in BVN |-> [i \in 0..N |-> f[i] \/ g[i]]]]

EXPANDN == [b \in {TRUE,FALSE} |-> [i \in 0..N |-> b]]
                                                                                                                     
r11 == [x \in {TRUE,FALSE} |-> (x /\ [ k \in 0..3 |-> FALSE]) \/ (~x /\ [ k \in 0..3 |-> TRUE]) ]

XORN == [f \in BVN |-> [g \in BVN |-> [i \in 0..N |-> ((f[i] /\ ~g[i]) \/ (~f[i] /\ g[i]))]]]

CMP32 == [f \in BVN |-> [g \in BVN |->  
                                       ~XORN[f][g][0]  /\ ~XORN[f][g][1]  /\ ~XORN[f][g][2]  /\ 
                                       ~XORN[f][g][3]  /\ ~XORN[f][g][4]  /\ ~XORN[f][g][5]  /\ 
                                       ~XORN[f][g][6]  /\ ~XORN[f][g][7]  /\ ~XORN[f][g][8]  /\
                                       ~XORN[f][g][9]  /\ ~XORN[f][g][10] /\ ~XORN[f][g][11] /\
                                       ~XORN[f][g][12] /\ ~XORN[f][g][13] /\ ~XORN[f][g][14] /\
                                       ~XORN[f][g][15] /\ ~XORN[f][g][16] /\ ~XORN[f][g][17] /\
                                       ~XORN[f][g][18] /\ ~XORN[f][g][19] /\ ~XORN[f][g][20] /\
                                       ~XORN[f][g][21] /\ ~XORN[f][g][22] /\ ~XORN[f][g][23] /\
                                       ~XORN[f][g][24] /\ ~XORN[f][g][25] /\ ~XORN[f][g][26] /\
                                       ~XORN[f][g][27] /\ ~XORN[f][g][28] /\ ~XORN[f][g][29] /\
                                       ~XORN[f][g][30] /\ ~XORN[f][g][31] ]]
                                       
 
 CMP64 == [f \in BVN |-> [g \in BVN |->  
                                       ~XORN[f][g][0]  /\ ~XORN[f][g][1]  /\ ~XORN[f][g][2]  /\ 
                                       ~XORN[f][g][3]  /\ ~XORN[f][g][4]  /\ ~XORN[f][g][5]  /\ 
                                       ~XORN[f][g][6]  /\ ~XORN[f][g][7]  /\ ~XORN[f][g][8]  /\
                                       ~XORN[f][g][9]  /\ ~XORN[f][g][10] /\ ~XORN[f][g][11] /\
                                       ~XORN[f][g][12] /\ ~XORN[f][g][13] /\ ~XORN[f][g][14] /\
                                       ~XORN[f][g][15] /\ ~XORN[f][g][16] /\ ~XORN[f][g][17] /\
                                       ~XORN[f][g][18] /\ ~XORN[f][g][19] /\ ~XORN[f][g][20] /\
                                       ~XORN[f][g][21] /\ ~XORN[f][g][22] /\ ~XORN[f][g][23] /\
                                       ~XORN[f][g][24] /\ ~XORN[f][g][25] /\ ~XORN[f][g][26] /\
                                       ~XORN[f][g][27] /\ ~XORN[f][g][28] /\ ~XORN[f][g][29] /\
                                       ~XORN[f][g][30] /\ ~XORN[f][g][31] /\
                                       ~XORN[f][g][32] /\ ~XORN[f][g][33] /\ ~XORN[f][g][34] /\ 
                                       ~XORN[f][g][35] /\ ~XORN[f][g][36] /\ ~XORN[f][g][37] /\ 
                                       ~XORN[f][g][38] /\ ~XORN[f][g][39] /\ ~XORN[f][g][40] /\
                                       ~XORN[f][g][41] /\ ~XORN[f][g][42] /\ ~XORN[f][g][43] /\
                                       ~XORN[f][g][44] /\ ~XORN[f][g][45] /\ ~XORN[f][g][46] /\
                                       ~XORN[f][g][47] /\ ~XORN[f][g][48] /\ ~XORN[f][g][49] /\
                                       ~XORN[f][g][50] /\ ~XORN[f][g][51] /\ ~XORN[f][g][52] /\
                                       ~XORN[f][g][53] /\ ~XORN[f][g][54] /\ ~XORN[f][g][55] /\
                                       ~XORN[f][g][56] /\ ~XORN[f][g][57] /\ ~XORN[f][g][58] /\
                                       ~XORN[f][g][59] /\ ~XORN[f][g][60] /\ ~XORN[f][g][61] /\
                                       ~XORN[f][g][62] /\ ~XORN[f][g][63] ]]

CMP_EQ_LT_GT == [b0 \in {TRUE,FALSE} |-> [b1 \in {TRUE,FALSE} |-> 
    [eq \in {TRUE,FALSE} |-> [lt \in {TRUE,FALSE} |-> [gt \in {TRUE,FALSE} |-> 
        [i \in 0..2 |-> 
            ((i=0) /\ ((b0 /\ b1) \/ (~b0 /\ ~b1)) /\ eq) \/ 
            ((i=1) /\ ((~b0 /\ b1 /\ eq) \/ lt)) \/ 
            ((i=2) /\ ((b0 /\ ~b1 /\ eq) \/ gt))              ]]]]]]    

CMP_EQ_LT_GT_1 == [f \in BVN |-> [g \in BVN |-> [i \in 0..63 |->
    [eq \in {TRUE,FALSE} |-> [lt \in {TRUE,FALSE} |-> [gt \in {TRUE,FALSE} |->                                                
        CMP_EQ_LT_GT[f[i]][g[i]][eq][lt][gt]   
                                                ]]]]]]

CMP_EQ_LT_GT_2 == [f \in BVN |-> [g \in BVN |-> [i \in {x \in 0..62 : x%2=0} |->
    [eq \in {TRUE,FALSE} |-> [lt \in {TRUE,FALSE} |-> [gt \in {TRUE,FALSE} |->                                                
        CMP_EQ_LT_GT_1[f][g][i]
            [CMP_EQ_LT_GT_1[f][g][i+1][eq][lt][gt][0]]
            [CMP_EQ_LT_GT_1[f][g][i+1][eq][lt][gt][1]]
            [CMP_EQ_LT_GT_1[f][g][i+1][eq][lt][gt][2]]   ]]]]]]
    
                                                
CMP_EQ_LT_GT_3 == [f \in BVN |-> [g \in BVN |-> [i \in 0..61 |->
    [eq \in {TRUE,FALSE} |-> [lt \in {TRUE,FALSE} |-> [gt \in {TRUE,FALSE} |-> 
        CMP_EQ_LT_GT_1[f][g][i]
            [CMP_EQ_LT_GT_2[f][g][i+1][eq][lt][gt][0]]
            [CMP_EQ_LT_GT_2[f][g][i+1][eq][lt][gt][1]]
            [CMP_EQ_LT_GT_2[f][g][i+1][eq][lt][gt][2]]
                                                            ]]]]]]  
                                                                        
CMP_EQ_LT_GT_4 == [f \in BVN |-> [g \in BVN |-> [i \in {x \in 0..60 : x%4=0} |->
    [eq \in {TRUE,FALSE} |-> [lt \in {TRUE,FALSE} |-> [gt \in {TRUE,FALSE} |->                                                
        CMP_EQ_LT_GT_2[f][g][i]
            [CMP_EQ_LT_GT_2[f][g][i+2][eq][lt][gt][0]]
            [CMP_EQ_LT_GT_2[f][g][i+2][eq][lt][gt][1]]
            [CMP_EQ_LT_GT_2[f][g][i+2][eq][lt][gt][2]]   ]]]]]]  

CMP_EQ_LT_GT_8 == [f \in BVN |-> [g \in BVN |-> [i \in {0,8,16,24,32,40,48,56} |->
    [eq \in {TRUE,FALSE} |-> [lt \in {TRUE,FALSE} |-> [gt \in {TRUE,FALSE} |->                                                
        CMP_EQ_LT_GT_4[f][g][i]
            [CMP_EQ_LT_GT_4[f][g][i+4][eq][lt][gt][0]]
            [CMP_EQ_LT_GT_4[f][g][i+4][eq][lt][gt][1]]
            [CMP_EQ_LT_GT_4[f][g][i+4][eq][lt][gt][2]]   ]]]]]]     
                                                                              

CMP_EQ_LT_GT_16 == [f \in BVN |-> [g \in BVN |-> [i \in {0,16,32,48} |->
    [eq \in {TRUE,FALSE} |-> [lt \in {TRUE,FALSE} |-> [gt \in {TRUE,FALSE} |->                                                
        CMP_EQ_LT_GT_8[f][g][i]
            [CMP_EQ_LT_GT_8[f][g][i+8][eq][lt][gt][0]]
            [CMP_EQ_LT_GT_8[f][g][i+8][eq][lt][gt][1]]
            [CMP_EQ_LT_GT_8[f][g][i+8][eq][lt][gt][2]]   ]]]]]]
            
CMP_EQ_LT_GT_32 == [f \in BVN |-> [g \in BVN |-> [i \in {0,32} |->
    [eq \in {TRUE,FALSE} |-> [lt \in {TRUE,FALSE} |-> [gt \in {TRUE,FALSE} |->                                                
        CMP_EQ_LT_GT_16[f][g][i]
            [CMP_EQ_LT_GT_16[f][g][i+16][eq][lt][gt][0]]
            [CMP_EQ_LT_GT_16[f][g][i+16][eq][lt][gt][1]]
            [CMP_EQ_LT_GT_16[f][g][i+16][eq][lt][gt][2]]   ]]]]]]

          
                        
                                           

(*
    xR11[0,32] = { (xR8==69) (xR13[0,32]) } +
    { [xR8==194] [(0 ≤ xR12[15,23] ≤ 2) (xR12[28,32]) + (xR12[15,23]==59) (xR12[32,40])] } +
    { (xR8==192) (xR12[15,23]==32) (xR13[32,64]) } +
    { ~(xR8==69) ~(xR8==192) ~(xR8==194) (xR11[0,32]) }
    
    xR11 = { (xR8==128) (RCF[3,5]==0) (RIP)mem } +
    { ~(xR8==128) (xR11) }
*)             

\*xR11_0_32 == ANDN[EXPANDN[CMP32[xR8_0_32][[i \in 0..32 |-> (i=0) \/ (i=2) \/ (i=6)]]]][xR13_0_32]
                                                                             
                                       
(*                                     
                                       
                                       



INSTRUCTION_FORMAT_CORRECT =
    [ 
        [0 ≤ xR11[0,8] ≤ 2] [(xR11[23,27]==1) + (xR11[23,27]==2) + (xR11[23,27]==4) + (xR11[23,27]==8)] [xR11[59,64]==0] +
        [9 ≤ xR11[0,8] ≤ 10] [xR11[50,64]==0] + [17 ≤ xR11[0,8] ≤ 33] [xR11[18,64]==0] + [xR11[0,8]==44] [xR11[45,64]==0] +
        [51 ≤ xR11[0,8] ≤ 53] [xR11[13,64]==0] + [xR11[0,8]==59] [xR11[16,64]==0] + [60 ≤ xR11[0,8] ≤ 67] [xR11[40,64]==0] +
        [76 ≤ xR11[0,8] ≤ 78] [xR11[8,64]==0]
    ]

xR12[0,1] = { [xR8==192] [(xR12[15,23]==31) + (xR12[15,23]==33) + (xR12[15,23]==52) + (59 ≤ xR12[15,23] ≤ 60)]  } +
{ (xR8==68) } + { (xR8==69) } + { (xR8==72) } +
{ (xR8==65) (xR12[0,1]) }

xR12[1,2] = { [2 ≤ xR8 ≤ 31] [~(xR13[0,32]==0) + (xR12[2,3])] [xR12[2,3]] } +
{ (xR8==65) (xR12[0,1] + xR12[1,2]) } +
{ (33 ≤ xR8 ≤ 63) (xR12[2,3]) } +
{ [(xR8==66) | (xR8==32)] [xR12[1,2]] }

xR12[2,3] = { [xR8==32] [(xR13[(xR8)(31)]) (xR14[(xR8)(31)]) + (xR12[1,2]) ((xR13[(xR8) (31)]) + (xR14[(xR8) (31)]))] } +
{ [33 ≤ xR8 ≤ 63] [(xR13[(xR8)(31)]) (xR14[(xR8)(31)]) + (xR12[2,3]) ((xR13[(xR8) (31)]) + (xR14[(xR8) (31)]))] } +
{ [(xR8==64) | (2 ≤ xR8 ≤ 31) | (xR8==71)] [xR12[2,3]] }

xR12[3,4] = { (xR8==66) (xR13[31,32]) } +
{ (32 ≤ xR8 ≤ 64) (xR12[3,4]) }

xR12[4,5] = { (xR8==66) (xR14[31,32]) } +
(32 ≤ xR8 ≤ 64) (xR12[4,5])


xR12[5,6] = { (xR8==67) ~(xR11[0,32]==0) ~(xR15[0,32]==0) ~(xR11[0,32]==1) ~(xR15[0,32]==1) (xR11[31,32]) } +
{ ~(xR8==67) (xR12[5,6]) }

xR12[6,7] = { (xR8==67) ~(xR11[0,32]==0) ~(xR15[0,32]==0) ~(xR11[0,32]==1) ~(xR15[0,32]==1) (xR15[31,32]) } +
{ ~(xR8==67) (xR12[6,7]) }

xR12[7,8] = { (xR8==193) (xR12[63,64]) } +
{ [xR8==67] [~(xR11[0,32]==0) ~(xR11[0,32]==1) (xR15[0,32]==1) (xR11[31,32]) + ~(xR15[0,32]==0) ~(xR15[0,32]==1) (xR11[0,32]==1) (xR15[31,32])] } +
{ (xR8==73) (xR13[31,32]) } +
{ [xR8==66] ~[xR12[1,2]] [~(xR13[0,32]==0) (xR14[0,32]==0) (xR13[31,32]) + (xR13[0,32]==0) ~(xR14[0,32]==0) (xR14[31,32])] } +
{ [xR8==64] ~[(xR13[31,32]) ~(xR12[3,4]) ~(xR12[4,5]) + ~(xR13[31,32]) (xR12[3,4]) (xR12[4,5])] [xR13[31,32]] } +
{ ~(xR8==64) ~(xR8==66) ~(xR8==67) ~(xR8==73) ~(xR8==193) (xR12[7,8]) }

xR12[9,10] = { (xR8==193) (xR12[32,64]==0) } +
{ [xR8==67] [(xR11[0,32]==0) + (xR15[0,32]==0)] } +
{ (xR8==73) (xR13[0,32]==0) } +
{ (xR8==66) (xR13[0,32]==0) (xR14[0,32]==0) } +
{ [xR8==64] ~[(xR13[31,32]) ~(xR12[3,4]) ~(xR12[4,5]) + ~(xR13[31,32]) (xR12[3,4]) (xR12[4,5])] [xR13[31,32]] [xR13[0,32]==0] } +
{ ~(xR8==64) ~(xR8==66) ~(xR8==67) ~(xR8==73) ~(xR8==193) (xR12[9,10]) }



xR12[15,23] = { (xR8==160) (INSTRUCTION_FORMAT_CORRECT) (xR11[0,8]) } +
{ ~(xR8==160) (xR12[15,23]) }

xR12[23,28] = { (xR8==160) (INSTRUCTION_FORMAT_CORRECT) (xR11[8,13]) } +
{ ~(xR8==160) (xR12[23,28]) }


xR12[28,32] = { (xR8==160) (INSTRUCTION_FORMAT_CORRECT) (xR11[23,27]) } +
{ ~(xR8==160) (xR12[28,32]) }




xR12[32,64] = { [xR8==224] [(xR12[15,23]==0) + (xR12[15,23]==9)] [0 ≤ xR12[32,64] ≤ 0x2000000] [(0 ≤ xR12[32,64] ≤ 0x2000000) (xR12[32,64])]mem } +
{ (xR8==225) (xR12[15,23]==59) [xR12[32,64] (xR8==225) (xR12[15,23]==59)]mem } +
{ (xR8==160) (INSTRUCTION_FORMAT_CORRECT) (xR11[8,40]) } +
{ [xR8==167] [(xR11[0,8]==44) (xR11[13,45]) + (9 ≤ xR11[0,8] < 10) (xR11[18,50]) + (0 ≤ xR11[0,8] < 2) (xR11[27,59]) ] } +
{ (xR8==194) ~(xR12[15,23]==33) ~(xR12[15,23]==59) ~(xR12[15,23]==60) (xR13[0,32]) } +
{ [xR8==192] [(xR12[15,23]==24) (xR13[32,64]) (xR14[32,64]) + (xR12[15,23]==25) ((xR13[32,64]) + (xR14[32,64])) + (xR12[15,23]==26) ((xR13[32,64]) ~(xR14[32,64]) + ~(xR13[32,64]) (xR14[32,64])) + (xR12[15,23]==27) ((xR13[32,64]) << ((xR14[32,64]) (31))) + (xR12[15,23]==28) ((xR13[32,64]) >> ((xR14[32,64]) (31))) + (xR12[15,23]==29) ((xR13[32,64]) >>> ((xR14[32,64]) (31))) + (xR12[15,23]==51) ~(xR13[32,64])] }
{ [(xR8==196) + (xR8==197)] [xR13[0,32]] } +
{ ~(xR8==160) ~(xR8==167) ~(xR8==192) ~(xR8==194) ~(xR8==196) ~(xR8==197) ~(xR8==224) ~(xR8==225) (xR12[32,64]) }                                       


xR13[0,1] := { (xR8=256) \/ (xR8=257) } \/
(xR8=165)  /\ 0
(xR8=163)  /\ 0
(xR8=161)  /\ 0


xR13[1,6] := { [(xR8=256) \/ (xR8=257)]  /\ xR12[23,28] } \/
{ (xR8=165) /\ xR11[18,23] } \/
{ (xR8=163) /\ xR11[13,18] } \/
{ (xR8=161) /\ xR11[8,13] } \/

xR13[0,32] := { [(xR8=192) /\ ((xR12[15,23]=52) \/ (xR12[15,23]=53) \/ (xR12[15,23]=59) \/ (xR12[15,23]=60) \/ (xR12[15,23]=76))] /\ xR14[32,64] } \/
{ [(xR8=192) /\ ((xR12[15,23]=30) \/ (xR12[15,23]=31) \/ (xR12[15,23]=33))] /\ xR13[32,64] } \/
{ [(xR8=192) /\ ((xR12[15,23]=0) \/ (xR12[15,23]=1) \/ (xR12[15,23]=2) \/ (xR12[15,23]=9) \/ (xR12[15,23]=10))] /\ xR12[32,64] } \/
{ (xR8=128) /\ RIP}  \/
{ (xR8=67) /\ (xR11[0,32]=1) /\ ¬(xR15[0,32]=0) /\ ¬(xR15[0,32]=1) /\ (xR15[0,32]) } \/
{ (xR8=67) /\ (xR15[0,32]=1) /\ ¬(xR11[0,32]=0) /\ ¬(xR11[0,32]=1) /\ (xR11[0,32]) } \/
{ (xR8=67) /\ [(xR11[0,32]=0) \/ (xR15[0,32]=0)] /\ 0 } \/
{ (xR8=68) /\ [(xR12[5,6]) \/ (¬xR12[5,6] /\ xR12[6,7])] /\ 0 } \/
{ (xR8=69) /\ xR12[6,7] /\ 0 } \/
{ (xR8=1) /\ xR15[0,1] /\ xR11[0,32] } \/
{ (xR8=1) /\ ¬xR15[0,1] /\ xR15[1,2] /\ (xR11[0,32]<<1) } \/
{ (xR8=1) /\ ¬xR15[0,1] /\ ¬xR15[1,2] /\ 0 } \/
{ (2 ≤ xR8 ≤ 31) /\ ¬xR15[xR8] /\ 0 } \/
{ (2 ≤ xR8 ≤ 31) /\ xR15[xR8] /\ (xR11[0,32]<< xR8) } \/
{ (xR8=72) /\ 0 } \/

xR13[32,64] := { [(xR8=194) /\ ((xR12[15,23]=59) \/ (xR12[15,23]=60))] /\ xR13[0,32] }
{ (xR8=162) /\ xR13[0,32] }



--DID WRITEBACK AND EXECUTION
--Stopped at  DECODE 165
*)                                       
                                      
                                       
                                       

THEOREM ANDN_CORRECT==
    \A f,g \in BVN : \A i \in 0..N : 
    ANDN[f][g][i] <=> f[i] /\ g[i]
PROOF
    <1>1 TAKE f,g \in BVN
    <1>2 TAKE i \in 0..N
    <1>3 ANDN[f][g][i] <=> f[i] /\ g[i]
        BY DEF BVN, ANDN
    <1> QED BY <1>3
    
THEOREM ORN_CORRECT==
    \A f,g \in BVN : \A i \in 0..N : 
    ORN[f][g][i] <=> f[i] \/ g[i]
PROOF
    <1>1 TAKE f,g \in BVN
    <1>2 TAKE i \in 0..N
    <1>3 ORN[f][g][i] <=> f[i] \/ g[i]
        BY DEF BVN, ORN
    <1> QED BY <1>3
    
THEOREM EXPANDN_CORRECT ==
    \A b \in {TRUE,FALSE} : \A i \in 0..N : 
    EXPANDN[b][i] <=> b
PROOF
    <1>1 TAKE b \in {TRUE,FALSE}
    <1>2 TAKE i \in 0..N
    <1>3 EXPANDN[b][i] <=> b
        BY  DEF EXPANDN
    <1> QED BY <1>3

THEOREM NOT_XORN_EQ ==
    \A f,g \in BVN : \A i \in 0..N :
    ~XORN[f][g][i] <=> f[i]=g[i]
PROOF
    <1>1 TAKE f,g \in BVN
    <1>2 TAKE i \in 0..N
    <1>3 ASSUME f[i] /= g[i] PROVE XORN[f][g][i]
        <2>1 f[i] \in {TRUE,FALSE}
            BY DEF BVN
        <2>2 g[i] \in {TRUE,FALSE}
            BY DEF BVN
        <2>3 (f[i] /= g[i]) => ((f[i] /\ ~g[i]) \/ (~f[i] /\ g[i]))
            BY <2>1, <2>2
        <2>4 ((f[i] /\ ~g[i]) \/ (~f[i] /\ g[i]))
            BY <1>3, <2>3
        <2>5 XORN[f][g][i]
            BY <2>4 DEF XORN
        <2>6 QED BY <2>5
    <1>4 ASSUME XORN[f][g][i] PROVE (f[i] /= g[i])
        <2>7 ((f[i] /\ ~g[i]) \/ (~f[i] /\ g[i]))
            BY <1>4 DEF XORN
        <2>8 f[i] /= g[i]
            BY <2>7
        <2>9 QED BY <2>8
    <1> QED BY <1>3, <1>4
    
THEOREM CMP32_F_EQ_G ==
    ASSUME N=31 PROVE
    \A f,g \in BVN :
    CMP32[f][g] <=> f=g
PROOF
    <1>1 TAKE f,g \in BVN
    <1>2 ASSUME CMP32[f][g] PROVE f=g
        <2>1 
             (~XORN[f][g][0] /\ ~XORN[f][g][1]  /\ ~XORN[f][g][2]  /\ 
             ~XORN[f][g][3]  /\ ~XORN[f][g][4]  /\ ~XORN[f][g][5]  /\ 
             ~XORN[f][g][6]  /\ ~XORN[f][g][7]  /\ ~XORN[f][g][8]  /\
             ~XORN[f][g][9]  /\ ~XORN[f][g][10] /\ ~XORN[f][g][11] /\
             ~XORN[f][g][12] /\ ~XORN[f][g][13] /\ ~XORN[f][g][14] /\
             ~XORN[f][g][15] /\ ~XORN[f][g][16] /\ ~XORN[f][g][17] /\
             ~XORN[f][g][18] /\ ~XORN[f][g][19] /\ ~XORN[f][g][20] /\
             ~XORN[f][g][21] /\ ~XORN[f][g][22] /\ ~XORN[f][g][23] /\
             ~XORN[f][g][24] /\ ~XORN[f][g][25] /\ ~XORN[f][g][26] /\
             ~XORN[f][g][27] /\ ~XORN[f][g][28] /\ ~XORN[f][g][29] /\
             ~XORN[f][g][30] /\ ~XORN[f][g][31]) => 
             (f[0]=g[0]   /\ f[1]=g[1]   /\ f[2]=g[2]   /\ f[3]=g[3]   /\
              f[4]=g[4]   /\ f[5]=g[5]   /\ f[6]=g[6]   /\ f[7]=g[7]   /\
              f[8]=g[8]   /\ f[9]=g[9]   /\ f[10]=g[10] /\ f[11]=g[11] /\
              f[12]=g[12] /\ f[13]=g[13] /\ f[14]=g[14] /\ f[15]=g[15] /\
              f[16]=g[16] /\ f[17]=g[17] /\ f[18]=g[18] /\ f[19]=g[19] /\
              f[20]=g[20] /\ f[21]=g[21] /\ f[22]=g[22] /\ f[23]=g[23] /\
              f[24]=g[24] /\ f[25]=g[25] /\ f[26]=g[26] /\ f[27]=g[27] /\
              f[28]=g[28] /\ f[29]=g[29] /\ f[30]=g[30] /\ f[31]=g[31])        
             BY NOT_XORN_EQ
        <2>2  
             (f[0]=g[0]   /\ f[1]=g[1]   /\ f[2]=g[2]   /\ f[3]=g[3]   /\
              f[4]=g[4]   /\ f[5]=g[5]   /\ f[6]=g[6]   /\ f[7]=g[7]   /\
              f[8]=g[8]   /\ f[9]=g[9]   /\ f[10]=g[10] /\ f[11]=g[11] /\
              f[12]=g[12] /\ f[13]=g[13] /\ f[14]=g[14] /\ f[15]=g[15] /\
              f[16]=g[16] /\ f[17]=g[17] /\ f[18]=g[18] /\ f[19]=g[19] /\
              f[20]=g[20] /\ f[21]=g[21] /\ f[22]=g[22] /\ f[23]=g[23] /\
              f[24]=g[24] /\ f[25]=g[25] /\ f[26]=g[26] /\ f[27]=g[27] /\
              f[28]=g[28] /\ f[29]=g[29] /\ f[30]=g[30] /\ f[31]=g[31])  =>
              (f=g)
            BY DEF BVN
        <2>3 f=g
            BY <1>2,<2>1,<2>2 DEF CMP32
        <2>4 QED BY <2>3
    <1>3 ASSUME f=g PROVE CMP32[f][g]
        <2>5 (f=g) => 
             (f[0]=g[0]   /\ f[1]=g[1]   /\ f[2]=g[2]   /\ f[3]=g[3]   /\
              f[4]=g[4]   /\ f[5]=g[5]   /\ f[6]=g[6]   /\ f[7]=g[7]   /\
              f[8]=g[8]   /\ f[9]=g[9]   /\ f[10]=g[10] /\ f[11]=g[11] /\
              f[12]=g[12] /\ f[13]=g[13] /\ f[14]=g[14] /\ f[15]=g[15] /\
              f[16]=g[16] /\ f[17]=g[17] /\ f[18]=g[18] /\ f[19]=g[19] /\
              f[20]=g[20] /\ f[21]=g[21] /\ f[22]=g[22] /\ f[23]=g[23] /\
              f[24]=g[24] /\ f[25]=g[25] /\ f[26]=g[26] /\ f[27]=g[27] /\
              f[28]=g[28] /\ f[29]=g[29] /\ f[30]=g[30] /\ f[31]=g[31])
            OBVIOUS
        <2>6 
             (f[0]=g[0]   /\ f[1]=g[1]   /\ f[2]=g[2]   /\ f[3]=g[3]   /\
              f[4]=g[4]   /\ f[5]=g[5]   /\ f[6]=g[6]   /\ f[7]=g[7]   /\
              f[8]=g[8]   /\ f[9]=g[9]   /\ f[10]=g[10] /\ f[11]=g[11] /\
              f[12]=g[12] /\ f[13]=g[13] /\ f[14]=g[14] /\ f[15]=g[15] /\
              f[16]=g[16] /\ f[17]=g[17] /\ f[18]=g[18] /\ f[19]=g[19] /\
              f[20]=g[20] /\ f[21]=g[21] /\ f[22]=g[22] /\ f[23]=g[23] /\
              f[24]=g[24] /\ f[25]=g[25] /\ f[26]=g[26] /\ f[27]=g[27] /\
              f[28]=g[28] /\ f[29]=g[29] /\ f[30]=g[30] /\ f[31]=g[31]) =>
             (~XORN[f][g][0] /\ ~XORN[f][g][1]  /\ ~XORN[f][g][2]  /\ 
             ~XORN[f][g][3]  /\ ~XORN[f][g][4]  /\ ~XORN[f][g][5]  /\ 
             ~XORN[f][g][6]  /\ ~XORN[f][g][7]  /\ ~XORN[f][g][8]  /\
             ~XORN[f][g][9]  /\ ~XORN[f][g][10] /\ ~XORN[f][g][11] /\
             ~XORN[f][g][12] /\ ~XORN[f][g][13] /\ ~XORN[f][g][14] /\
             ~XORN[f][g][15] /\ ~XORN[f][g][16] /\ ~XORN[f][g][17] /\
             ~XORN[f][g][18] /\ ~XORN[f][g][19] /\ ~XORN[f][g][20] /\
             ~XORN[f][g][21] /\ ~XORN[f][g][22] /\ ~XORN[f][g][23] /\
             ~XORN[f][g][24] /\ ~XORN[f][g][25] /\ ~XORN[f][g][26] /\
             ~XORN[f][g][27] /\ ~XORN[f][g][28] /\ ~XORN[f][g][29] /\
             ~XORN[f][g][30] /\ ~XORN[f][g][31])
            BY NOT_XORN_EQ
        <2>7 CMP32[f][g]
            BY <1>3,<2>5,<2>6 DEF CMP32
        <2>8 QED BY <2>7  
    <1> QED BY <1>2,<1>3




THEOREM CMP64_F_EQ_G ==
    ASSUME N=63 PROVE
    \A f,g \in BVN :
    CMP64[f][g] <=> f=g
PROOF
    <1>1 TAKE f,g \in BVN
    <1>2 ASSUME CMP64[f][g] PROVE f=g
        <2>1 
             (~XORN[f][g][0]  /\ ~XORN[f][g][1]  /\ ~XORN[f][g][2]  /\ 
              ~XORN[f][g][3]  /\ ~XORN[f][g][4]  /\ ~XORN[f][g][5]  /\ 
              ~XORN[f][g][6]  /\ ~XORN[f][g][7]  /\ ~XORN[f][g][8]  /\
              ~XORN[f][g][9]  /\ ~XORN[f][g][10] /\ ~XORN[f][g][11] /\
              ~XORN[f][g][12] /\ ~XORN[f][g][13] /\ ~XORN[f][g][14] /\
              ~XORN[f][g][15] /\ ~XORN[f][g][16] /\ ~XORN[f][g][17] /\
              ~XORN[f][g][18] /\ ~XORN[f][g][19] /\ ~XORN[f][g][20] /\
              ~XORN[f][g][21] /\ ~XORN[f][g][22] /\ ~XORN[f][g][23] /\
              ~XORN[f][g][24] /\ ~XORN[f][g][25] /\ ~XORN[f][g][26] /\
              ~XORN[f][g][27] /\ ~XORN[f][g][28] /\ ~XORN[f][g][29] /\
              ~XORN[f][g][30] /\ ~XORN[f][g][31] /\
              ~XORN[f][g][32] /\ ~XORN[f][g][33] /\ ~XORN[f][g][34] /\ 
              ~XORN[f][g][35] /\ ~XORN[f][g][36] /\ ~XORN[f][g][37] /\ 
              ~XORN[f][g][38] /\ ~XORN[f][g][39] /\ ~XORN[f][g][40] /\
              ~XORN[f][g][41] /\ ~XORN[f][g][42] /\ ~XORN[f][g][43] /\
              ~XORN[f][g][44] /\ ~XORN[f][g][45] /\ ~XORN[f][g][46] /\
              ~XORN[f][g][47] /\ ~XORN[f][g][48] /\ ~XORN[f][g][49] /\
              ~XORN[f][g][50] /\ ~XORN[f][g][51] /\ ~XORN[f][g][52] /\
              ~XORN[f][g][53] /\ ~XORN[f][g][54] /\ ~XORN[f][g][55] /\
              ~XORN[f][g][56] /\ ~XORN[f][g][57] /\ ~XORN[f][g][58] /\
              ~XORN[f][g][59] /\ ~XORN[f][g][60] /\ ~XORN[f][g][61] /\
              ~XORN[f][g][62] /\ ~XORN[f][g][63]) => 
             (f[0]=g[0]   /\ f[1]=g[1]   /\ f[2]=g[2]   /\ f[3]=g[3]   /\
              f[4]=g[4]   /\ f[5]=g[5]   /\ f[6]=g[6]   /\ f[7]=g[7]   /\
              f[8]=g[8]   /\ f[9]=g[9]   /\ f[10]=g[10] /\ f[11]=g[11] /\
              f[12]=g[12] /\ f[13]=g[13] /\ f[14]=g[14] /\ f[15]=g[15] /\
              f[16]=g[16] /\ f[17]=g[17] /\ f[18]=g[18] /\ f[19]=g[19] /\
              f[20]=g[20] /\ f[21]=g[21] /\ f[22]=g[22] /\ f[23]=g[23] /\
              f[24]=g[24] /\ f[25]=g[25] /\ f[26]=g[26] /\ f[27]=g[27] /\
              f[28]=g[28] /\ f[29]=g[29] /\ f[30]=g[30] /\ f[31]=g[31] /\
              f[32]=g[32] /\ f[33]=g[33] /\ f[34]=g[34] /\ f[35]=g[35] /\
              f[36]=g[36] /\ f[37]=g[37] /\ f[38]=g[38] /\ f[39]=g[39] /\
              f[40]=g[40] /\ f[41]=g[41] /\ f[42]=g[42] /\ f[43]=g[43] /\
              f[44]=g[44] /\ f[45]=g[45] /\ f[46]=g[46] /\ f[47]=g[47] /\
              f[48]=g[48] /\ f[49]=g[49] /\ f[50]=g[50] /\ f[51]=g[51] /\
              f[52]=g[52] /\ f[53]=g[53] /\ f[54]=g[54] /\ f[55]=g[55] /\
              f[56]=g[56] /\ f[57]=g[57] /\ f[58]=g[58] /\ f[59]=g[59] /\
              f[60]=g[60] /\ f[61]=g[61] /\ f[62]=g[62] /\ f[63]=g[63])                     
             BY NOT_XORN_EQ
        <2>2  
             (f[0]=g[0]   /\ f[1]=g[1]   /\ f[2]=g[2]   /\ f[3]=g[3]   /\
              f[4]=g[4]   /\ f[5]=g[5]   /\ f[6]=g[6]   /\ f[7]=g[7]   /\
              f[8]=g[8]   /\ f[9]=g[9]   /\ f[10]=g[10] /\ f[11]=g[11] /\
              f[12]=g[12] /\ f[13]=g[13] /\ f[14]=g[14] /\ f[15]=g[15] /\
              f[16]=g[16] /\ f[17]=g[17] /\ f[18]=g[18] /\ f[19]=g[19] /\
              f[20]=g[20] /\ f[21]=g[21] /\ f[22]=g[22] /\ f[23]=g[23] /\
              f[24]=g[24] /\ f[25]=g[25] /\ f[26]=g[26] /\ f[27]=g[27] /\
              f[28]=g[28] /\ f[29]=g[29] /\ f[30]=g[30] /\ f[31]=g[31] /\
              f[32]=g[32] /\ f[33]=g[33] /\ f[34]=g[34] /\ f[35]=g[35] /\
              f[36]=g[36] /\ f[37]=g[37] /\ f[38]=g[38] /\ f[39]=g[39] /\
              f[40]=g[40] /\ f[41]=g[41] /\ f[42]=g[42] /\ f[43]=g[43] /\
              f[44]=g[44] /\ f[45]=g[45] /\ f[46]=g[46] /\ f[47]=g[47] /\
              f[48]=g[48] /\ f[49]=g[49] /\ f[50]=g[50] /\ f[51]=g[51] /\
              f[52]=g[52] /\ f[53]=g[53] /\ f[54]=g[54] /\ f[55]=g[55] /\
              f[56]=g[56] /\ f[57]=g[57] /\ f[58]=g[58] /\ f[59]=g[59] /\
              f[60]=g[60] /\ f[61]=g[61] /\ f[62]=g[62] /\ f[63]=g[63])  =>
              (f=g)
            BY DEF BVN
        <2>3 f=g
            BY <1>2,<2>1,<2>2 DEF CMP64
        <2>4 QED BY <2>3
    <1>3 ASSUME f=g PROVE CMP64[f][g]
        <2>5 (f=g) => 
             (f[0]=g[0]   /\ f[1]=g[1]   /\ f[2]=g[2]   /\ f[3]=g[3]   /\
              f[4]=g[4]   /\ f[5]=g[5]   /\ f[6]=g[6]   /\ f[7]=g[7]   /\
              f[8]=g[8]   /\ f[9]=g[9]   /\ f[10]=g[10] /\ f[11]=g[11] /\
              f[12]=g[12] /\ f[13]=g[13] /\ f[14]=g[14] /\ f[15]=g[15] /\
              f[16]=g[16] /\ f[17]=g[17] /\ f[18]=g[18] /\ f[19]=g[19] /\
              f[20]=g[20] /\ f[21]=g[21] /\ f[22]=g[22] /\ f[23]=g[23] /\
              f[24]=g[24] /\ f[25]=g[25] /\ f[26]=g[26] /\ f[27]=g[27] /\
              f[28]=g[28] /\ f[29]=g[29] /\ f[30]=g[30] /\ f[31]=g[31] /\
              f[32]=g[32] /\ f[33]=g[33] /\ f[34]=g[34] /\ f[35]=g[35] /\
              f[36]=g[36] /\ f[37]=g[37] /\ f[38]=g[38] /\ f[39]=g[39] /\
              f[40]=g[40] /\ f[41]=g[41] /\ f[42]=g[42] /\ f[43]=g[43] /\
              f[44]=g[44] /\ f[45]=g[45] /\ f[46]=g[46] /\ f[47]=g[47] /\
              f[48]=g[48] /\ f[49]=g[49] /\ f[50]=g[50] /\ f[51]=g[51] /\
              f[52]=g[52] /\ f[53]=g[53] /\ f[54]=g[54] /\ f[55]=g[55] /\
              f[56]=g[56] /\ f[57]=g[57] /\ f[58]=g[58] /\ f[59]=g[59] /\
              f[60]=g[60] /\ f[61]=g[61] /\ f[62]=g[62] /\ f[63]=g[63])
            OBVIOUS
        <2>6 
             (f[0]=g[0]   /\ f[1]=g[1]   /\ f[2]=g[2]   /\ f[3]=g[3]   /\
              f[4]=g[4]   /\ f[5]=g[5]   /\ f[6]=g[6]   /\ f[7]=g[7]   /\
              f[8]=g[8]   /\ f[9]=g[9]   /\ f[10]=g[10] /\ f[11]=g[11] /\
              f[12]=g[12] /\ f[13]=g[13] /\ f[14]=g[14] /\ f[15]=g[15] /\
              f[16]=g[16] /\ f[17]=g[17] /\ f[18]=g[18] /\ f[19]=g[19] /\
              f[20]=g[20] /\ f[21]=g[21] /\ f[22]=g[22] /\ f[23]=g[23] /\
              f[24]=g[24] /\ f[25]=g[25] /\ f[26]=g[26] /\ f[27]=g[27] /\
              f[28]=g[28] /\ f[29]=g[29] /\ f[30]=g[30] /\ f[31]=g[31] /\
              f[32]=g[32] /\ f[33]=g[33] /\ f[34]=g[34] /\ f[35]=g[35] /\
              f[36]=g[36] /\ f[37]=g[37] /\ f[38]=g[38] /\ f[39]=g[39] /\
              f[40]=g[40] /\ f[41]=g[41] /\ f[42]=g[42] /\ f[43]=g[43] /\
              f[44]=g[44] /\ f[45]=g[45] /\ f[46]=g[46] /\ f[47]=g[47] /\
              f[48]=g[48] /\ f[49]=g[49] /\ f[50]=g[50] /\ f[51]=g[51] /\
              f[52]=g[52] /\ f[53]=g[53] /\ f[54]=g[54] /\ f[55]=g[55] /\
              f[56]=g[56] /\ f[57]=g[57] /\ f[58]=g[58] /\ f[59]=g[59] /\
              f[60]=g[60] /\ f[61]=g[61] /\ f[62]=g[62] /\ f[63]=g[63]) =>
             (~XORN[f][g][0]  /\ ~XORN[f][g][1]  /\ ~XORN[f][g][2]  /\ 
              ~XORN[f][g][3]  /\ ~XORN[f][g][4]  /\ ~XORN[f][g][5]  /\ 
              ~XORN[f][g][6]  /\ ~XORN[f][g][7]  /\ ~XORN[f][g][8]  /\
              ~XORN[f][g][9]  /\ ~XORN[f][g][10] /\ ~XORN[f][g][11] /\
              ~XORN[f][g][12] /\ ~XORN[f][g][13] /\ ~XORN[f][g][14] /\
              ~XORN[f][g][15] /\ ~XORN[f][g][16] /\ ~XORN[f][g][17] /\
              ~XORN[f][g][18] /\ ~XORN[f][g][19] /\ ~XORN[f][g][20] /\
              ~XORN[f][g][21] /\ ~XORN[f][g][22] /\ ~XORN[f][g][23] /\
              ~XORN[f][g][24] /\ ~XORN[f][g][25] /\ ~XORN[f][g][26] /\
              ~XORN[f][g][27] /\ ~XORN[f][g][28] /\ ~XORN[f][g][29] /\
              ~XORN[f][g][30] /\ ~XORN[f][g][31] /\
              ~XORN[f][g][32] /\ ~XORN[f][g][33] /\ ~XORN[f][g][34] /\ 
              ~XORN[f][g][35] /\ ~XORN[f][g][36] /\ ~XORN[f][g][37] /\ 
              ~XORN[f][g][38] /\ ~XORN[f][g][39] /\ ~XORN[f][g][40] /\
              ~XORN[f][g][41] /\ ~XORN[f][g][42] /\ ~XORN[f][g][43] /\
              ~XORN[f][g][44] /\ ~XORN[f][g][45] /\ ~XORN[f][g][46] /\
              ~XORN[f][g][47] /\ ~XORN[f][g][48] /\ ~XORN[f][g][49] /\
              ~XORN[f][g][50] /\ ~XORN[f][g][51] /\ ~XORN[f][g][52] /\
              ~XORN[f][g][53] /\ ~XORN[f][g][54] /\ ~XORN[f][g][55] /\
              ~XORN[f][g][56] /\ ~XORN[f][g][57] /\ ~XORN[f][g][58] /\
              ~XORN[f][g][59] /\ ~XORN[f][g][60] /\ ~XORN[f][g][61] /\
              ~XORN[f][g][62] /\ ~XORN[f][g][63])
            BY NOT_XORN_EQ
        <2>7 CMP64[f][g]
            BY <1>3,<2>5,<2>6 DEF CMP64
        <2>8 QED BY <2>7  
    <1> QED BY <1>2,<1>3
   

=============================================================================
\* Modification History
\* Last modified Thu Nov 24 14:00:50 CST 2022 by mjhomefolder
\* Created Thu Nov 03 00:11:52 CDT 2022 by mjhomefolder
