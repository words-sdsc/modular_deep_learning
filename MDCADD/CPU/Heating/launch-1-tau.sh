#!/bin/sh

#SBATCH -J pmemd-tau
#SBATCH -A sds170
#SBATCH -D /home/kkew/pmemd_profiles/launch.1
#SBATCH -N 1
#SBATCH -o pmemd-tau.log
#SBATCH --partition=compute
#SBATCH --time=04:00:00

module load tau
module load amber
source ~/.bashrc
mpirun -v -np 8 tau_exec -io -memory $AMBERHOME_CPU/pmemd.MPI -O -i \
	/home/kkew/MD_TEST/confDir/min1_switch.conf -o \
	/home/kkew/MD_TEST/r175h_stictic/min1.out -p \
	/home/kkew/MD_TEST/r175h_stictic/r175h_stictic.top \
	-c \
	/home/kkew/MD_TEST/r175h_stictic/r175h_stictic.crd \
	-r /home/kkew/MD_TEST/r175h_stictic/min1.rst -ref \
	/home/kkew/MD_TEST/r175h_stictic/r175h_stictic.crd
