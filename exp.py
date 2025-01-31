#! /usr/bin/env python                                                                                                                                                                              # -*- coding: utf-8 -*-                                                                                                                                                                             
# import standard python libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import sys

# import libraries for biological data analysis
import cooler
import bioframe
import cooltools

# Set up parallelization
import multiprocess
nthreads = 10

args = sys.argv

cool = args[1]
output = args[2]
#define genomic features
Scer_chromsize = pd.read_table('S_cerevisiae_chromsizes')
Scer_cens = pd.read_table("S_cerevisiae_cens2")
Scer_arms = bioframe.make_chromarms(Scer_chromsize, Scer_cens,cols_chroms=('chrom','length'),cols_mids=('chrom','mid'))
#Scer_arms.to_csv('scer_arms2.bed', sep = '\t', header=False, index=False) 

#open cool file
#cool = 'SN16-2norm/S_cerevisiae/nas24/SN16-2norm.nas24.200.cool'
clr = cooler.Cooler(cool)

#calculate expected interactions for chromosome arms
expected = cooltools.expected_cis(clr, view_df=Scer_arms, nproc=10)
expected.to_csv(output, sep='\t',index = False, header = True)

