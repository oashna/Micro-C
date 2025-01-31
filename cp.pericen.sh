#!/bin/bash
bedpe="periCENloops/periCen_loops.bedpe"

view="scer_arms2.bed"
exprm=$1
build=$2
binsize=200

funct(){
    cell=$1
    dir=$exprm/$build/$cell
    cool=$dir/$exprm.$cell.$binsize.cool
    echo $cool
    echo $bed
    expct=$dir/$exprm.$cell.$binsize.expected2.tsv
    outdir=periCENloops
    #mkdir -p $outdir


    coolpup.py $cool $bedpe --view $view --expected $expct --flank 10000 --mindist 0 -o ${outdir}/${cell}.periCENloops.clpy
    plotpup.py --input_pups ${outdir}/${cell}.periCENloops.clpy -o ${outdir}/${cell}.periCENloops.png --dpi 500 --plot_ticks --vmin 0.3 --vmax 3.3 
    coolpup.py $cool $bedpe --view $view --expected $expct --flank 10000 --mindist 0 -o ${outdir}/${cell}.periCENloops.byname.clpy --groupby name
    plotpup.py --input_pups ${outdir}/${cell}.periCENloops.byname.clpy -o ${outdir}/${cell}.periCENloops.byname.png --dpi 500 --plot_ticks --vmin 0.3 --vmax 3.3 --cols name

}

for cell in `ls $exprm/$build`
do

    funct $cell &>> logs/$exprm/coolpup.log

done

rm *~


