#! /usr/bin/env python                                                                                                                                                                              # -*- coding: utf-8 -*- 
# import standard python libraries
import matplotlib as mpl
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import sys

# import libraries for biological data analysis
from coolpuppy import coolpup
from coolpuppy.lib import numutils
from coolpuppy.lib.numutils import get_enrichment

from coolpuppy.lib.puputils import divide_pups
from coolpuppy.lib.puputils import accumulate_values
from coolpuppy import plotpup
import cooler
import bioframe
import cooltools
from cooltools import expected_cis, expected_trans
from cooltools.lib import plotting

#setup args
args = sys.argv

cool = args[1]
exp = args[2]
loop = args[3]
output = args[4]

#define genomic features
Scer_chromsize = pd.read_table("S_cerevisiae_chromsizes")
Scer_cens = pd.read_table("S_cerevisiae_cens2")
Scer_arms = bioframe.make_chromarms(Scer_chromsize, Scer_cens,cols_chroms=('chrom','length'),cols_mids=('chrom','mid'))


#open cool file
clr = cooler.Cooler(cool)

#calculate expected interactions for chromosome arms
#expected = cooltools.expected_cis(clr, view_df=Scer_arms, nproc=10)
#expected.to_csv('nas26.200.expected.test.csv', sep='\t',index = False)
expected = pd.read_table(exp)

#import loop file
#loop = pd.read_table('bed/2del_bothScc1_unique_6cols_2.bedpe')
#loop = pd.read_table('conv.coh/conv.coh.cen.loops3.6cols.bedpe')
loop = pd.read_table(loop)
#loop = pd.read_table('test.bedpe')
#define a function to store enrichment score within each snippet
def add_enrichment(snippet):
    snippet['enrichment_score'] = get_enrichment(snippet['data'],3)
    return snippet

#define a function to save enrichment score when combining snippets into a pileup:
def extra_sum_func(pup,snippet):
    return accumulate_values(pup,snippet,'enrichment_score')

#make pileup
cc = coolpup.CoordCreator(loop, features_format='bedpe', resolution=200,flank=10000,mindist=0)
pup = coolpup.PileUpper(clr, cc, view_df=Scer_arms, expected=expected, nproc=2)
pup2 = pup.pileupsWithControl(postprocess_func=add_enrichment, extra_sum_funcs={'enrichment_score': extra_sum_func})
#pup2.to_csv('pup.test.csv', sep='\t',index = False)

pup3 = pup2.loc[0,'enrichment_score']

with open(output, 'w') as f:
    f.write("\n".join(map(str,pup3)))
f.close()
#pup3.to_csv('conv.coh.cen.loop.erchm.csv', sep='\t', index = False)
#print(pup2.loc[0, 'enrichment_score'][:10])
