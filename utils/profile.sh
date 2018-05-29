#!/bin/bash

#SBATCH --job-name=profile3
#SBATCH --output=profile3.log
#SBATCH --ntasks=1
#SBATCH --time=02:00:00

#SBATCH --partition=compute 

module load tau
export TAU_MAKEFILE="/opt/tau/intel/mvapich2_ib/x86_64/lib/Makefile.tau-icpc-papi-mpi-pdt"

tau_exec -memory -T serial -ebs \
blastp \
-query cow.1.protein.faa \
-db human.1.protein.faa \
-out cow_vs_human_blast_results.tab \
-evalue 1e-5 \
-outfmt 6 \
-max_target_seqs 1
