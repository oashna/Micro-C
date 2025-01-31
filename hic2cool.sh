#!/bin/bash

sing="singularity exec --bind /work --bind /work2 /work/SingularityImages/rnakato_4dn.18.04.sif"
hicCorrect="singularity exec --bind /work --bind /work2 /work/SingularityImages/hicexplorer.3.7.2.sif hicCorrectMatrix"

experiment=$1
build=$2
pwd=`pwd`
ncore=72
binsize=200 #1000 #200 #2000
#mkdir -p logs/$experiment
func(){
    cell=$1
    hic=$experiment/$build/$cell/contact_map_HR.hic 
    echo $hic

	dir=$experiment/$build/$cell #; mkdir -p $dir

	$sing hic2cool convert $hic $dir/$experiment.$cell.$binsize.cool -r $binsize
	cp $dir/$experiment.$cell.$binsize.cool $dir/$experiment.$cell.$binsize.nonorm.cool
	$sing cooler balance -p $ncore $dir/$experiment.$cell.$binsize.cool

	$hicCorrect correct -m $dir/$experiment.$cell.$binsize.nonorm.cool --correctionMethod KR -o $dir/$experiment.$cell.$binsize.KR.cool
}


for cell in `ls $experiment/$build`
do
    func $cell &>> logs/${experiment}/hic2cool_${binsize}.log &
done

rm *~



