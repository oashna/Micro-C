#!/bin/bash
exprm=$1
build=$2
binsize=200
res1=2000
funct(){
    cell=$1
    cool=$exprm/$build/$cell/$exprm.$cell.$binsize.cool
    exp=$exprm/$build/$cell/$exprm.$cell.$binsize.expected2.tsv
    loop="periCENloops/periCen_loops.bedpe"

    echo $cool
    echo $exp
    echo $loop
    outdir=periCENloops
    #mkdir -p $outdir
    output=$outdir/$exprm.$cell.${binsize}.pericenLoop.enrich
    python get.enrch.CP.py $cool $exp $loop $output
}

for cell in `ls $exprm/$build/`
do

    funct $cell &>> logs/${exprm}/get.enrch.log &

done

rm *~
    
