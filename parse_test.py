import argparse
import os
import subprocess

parser = argparse.ArgumentParser(description='Align files, calculate coverage, print output to files.')
parser.add_argument('-1', '--read-1', type=str, required = True)
parser.add_argument('-2', '--read-2', type=str, required = True)
parser.add_argument('-x', '--reference-genome', type=str, required = True)
parser.add_argument('-q', '--quality-threshold', type=str, default = "0")
#parser.add_argument('-t', '--aligner-threads', type=int, default = 1)
#parser.add_argument('-c', '--check-quality', action='store_true', help="run FastQC on samples?")


results = parser.parse_args()
print results.read_1
print results.read_2
print results.reference_genome
print results.quality_threshold

#use read 1 to come up with the base name of the files
#use that variable to name the sam file and then the bam file
subprocess.call(['/Users/andrewleith/mark_assignment/bwa-0.7.15/bwa mem '+ results.reference_genome +' '+ results.read_1 +' '+ results.read_2 +'> SRR961514.sam'], shell=True)
subprocess.call(['samtools view -bSq '+ results.quality_threshold +' SRR961514.sam > SRR961514.bam'], shell=True)
#flagstat goes here
#use the same bam file name from above
subprocess.call(['/Users/andrewleith/mark_assignment/bedtools/bin/bedtools genomecov -ibam SRR961514.bam -d > coverage.tsv'], shell=True)
subprocess.call(['Rscript coverage.R coverage.tsv '+ results.reference_genome], shell=True)
#distribution of coverage for each base type
#K-S test to compare these distributions for any significant differences
#if none, there is no association between base and coverage
#if so, determine if skewness accounts for the difference