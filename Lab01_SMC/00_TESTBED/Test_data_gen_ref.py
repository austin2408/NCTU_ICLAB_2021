# ========================================================
# Project:  Lab01 reference code
# File:     Test_data_gen_ref.py
# Author:   Lai Lin-Hung @ Si2 Lab
# Date:     2021.09.15
# ========================================================

# ++++++++++++++++++++ Import Package +++++++++++++++++++++
import random
import math
# ++++++++++++++++++++ Function +++++++++++++++++++++
def generate_out(mode, W, Vgs, Vds):
    I = []
    g = []
    for i in range(6):
        if (Vgs[i] - 1 > Vds[i]): # Triode
            I.append(int(math.floor((W[i]*(2*(Vgs[i] - 1)*Vds[i] - Vds[i]**2))/3 / 1.0)))
            g.append(int(math.floor(2*W[i]*Vds[i]/3 / 1.0)))
        else: # Saturation
            I.append(int(math.floor(W[i]*(Vgs[i] - 1)*(Vgs[i] - 1)/3 / 1.0)))
            g.append(int(math.floor(2*W[i]*(Vgs[i] - 1)/3 / 1.0)))

    I = sorted(I, reverse=True)
    g = sorted(g, reverse=True)

    if (mode == 1) or (mode == 3):# mode 0 = 1
        if (mode == 2) or (mode == 3):
            out = 3*I[0] + 4*I[1] + 5*I[2] # mode 1 = 1
        else:
            out = 3*I[3] + 4*I[4] + 5*I[5] # mode 1 = 0
    else: # mode 0 = 0
        if (mode == 2) or (mode == 3):
            out = g[0] + g[1] + g[2] # mode 1 = 1
        else:
            out = g[3] + g[4] + g[5] # mode 1 = 0

    return out


def gen_test_data(input_file_path,output_file_path):
    # initial File path
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')
    
    # Set Pattern number 
    PATTERN_NUM = 100000
    pIFile.write(str(PATTERN_NUM)+'\n')
    pIFile.write('\n')
    for j in range(PATTERN_NUM):
        # print(j)
        mode=0
        out_n=0
        # Todo: 
        # You can generate test data here
        w = []
        vgs = []
        vds = []
        mode = random.randint(0, 3)
        for _ in range(6):
            w.append(random.randint(1, 7))
            vgs.append(random.randint(1, 7))
            vds.append(random.randint(1, 7))



        # Output file
        # pIFile.write(str(mode)+'\n')
        out_n = generate_out(mode, w, vgs, vds)
        pIFile.write(str(mode)+'\n')
        for i in range(6):
            pIFile.write(str(w[i])+' '+str(vgs[i])+' '+str(vds[i])+'\n')

        pIFile.write('\n')
        pOFile.write(str(out_n)+'\n')


# ++++++++++++++++++++ main +++++++++++++++++++++
def main():
    gen_test_data("input_3.txt","output_3.txt")

if __name__ == '__main__':
    main()