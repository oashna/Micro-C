#!/bin/bash
exprm=$1
build=$2
binsize=200

funct(){
    cell=$1
    cool=$exprm/$build/$cell/$exprm.$cell.$binsize.cool
    echo $cool
    outdir=$exprm/$build/$cell
    output=$outdir/$exprm.$cell.$binsize.expected2.tsv
    python exp.py $cool $output
}
for cell in `ls $exprm/$build`
do

    funct $cell &>> logs/${exprm}/exp.log &

done

rm *~
    
