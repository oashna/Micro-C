#!/bin/bash
#sing="singularity exec --bind /work --bind /work2 /work/SingularityImages/rnakato_4dn.18.04.sif"
hicCorrect="singularity exec --bind /work --bind /work2 /work/SingularityImages/hicexplorer.3.7.2.sif hicCorrectMatrix"

experiment=$1
build=$2
pwd=`pwd`
ncore=72
binsize=500 #1000 #200 #2000

func(){
    
    hic=$experiment/$build/$cell/contact_map_HR.hic 
    echo $hic

    dir=$experiment/$build/$cell #; mkdir -p $dir
    $hicCorrect diagnostic_plot -m $dir/$experiment.$cell.$binsize.nonorm.cool -o $dir/$experiment.$cell.$binsize.diag.png

    $hicCorrect correct -m $dir/$experiment.$cell.$binsize.nonorm.cool --filterThreshold -2 2 -o $dir/$experiment.$cell.$binsize.IC.cool --correctionMethod ICE

}


for cell in `ls $experiment/$build`
do
    func $cell &>> logs/${experiment}/hicCorrect_${binsize}.log &
done

rm *~
