#!/bin/bash

experiment=$1
build=$2

index="/work/Database/bwa-indexes/${build}"
gt="/work/Database/others/${build}/genome_table"
juicertool="singularity exec --bind /work,/work2 /work/SingularityImages/rnakato_juicer.1.5.7.sif juicertools.sh"

microc(){
    bwa mem -5SP -T0 -t16 $index $fq1 $fq2  |
	pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 --nproc-in 8 --nproc-out 8 --chroms-path $gt |
	pairtools sort --nproc 16 --tmpdir=${temp}/  |
	pairtools dedup --nproc-in 8 --nproc-out 8 --mark-dups --output-stats ${idir}/stats.txt |
	pairtools split --nproc-in 8 --nproc-out 8 --output-pairs ${idir}/mapped.pairs --output-sam -|samtools view -bS -@16 |
	samtools sort -@16 -T ${temp}/temp.bam -o ${idir}/mapped.PT.bam

        samtools index ${idir}/mapped.PT.bam ${idir}/mapped.PT.bam.bai
        python3 get_qc.py -p ${idir}/stats.txt > ${idir}/pair.stats.txt
    
    $juicertool pre -r 100,200,500,1000,2000 ${idir}/mapped.pairs ${idir}/contact_map_HR.hic $gt    	
}


run=$experiment
ldir="logs/${run}"
mkdir -p $ldir

for prefix in `ls $experiment/${build}`
do 
    idir=${experiment}/${build}/${prefix}
    fq1="${idir}/fastq/${prefix}_pass_1.fastq.gz" ; fq2="${idir}/fastq/${prefix}_pass_2.fastq.gz"
    mkdir -p "${idir}/temp" ; temp="${idir}/temp"
    microc &>> $ldir/microc.log &
done



rm *~
