#!/bin/bash
# Mosaic of M17, K band, 1.5 deg x 1.5 deg
# Bruce Berriman, February, 2016

module load tau
module load pdt
module load papi

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/openmpi/intel/ib/lib/:/opt/papi/intel/lib"
export PATH="$PATH:/opt/tau/intel/openmpi_ib/x86_64/bin"
# export TAU_MAKEFILE="/opt/tau/intel/openmpi_ib/x86_64/lib/Makefile.tau-icpc-papi-mpi-pdt"
# export PATH="$PATH:/home/siyu/workflows/Montage-dev/bin"
export PATH="$PATH:/opt/papi/intel/bin"
export TAU_MAKEFILE="/opt/tau/intel/mvapich2_ib/x86_64/lib/Makefile.tau-icpc-papi-mpi-pdt"
export COUNTER1=PAPI_TOT_CYC

cd $1

echo "create directories to hold processed images"
mkdir Kprojdir diffdir corrdir profiles

echo "Create a metadata table of the input images, Kimages.tbl"
tau_exec -memory -T mpi,pdt,papi mImgtbl Kimages Kimages.tbl
cp profile.0.0.0 profiles/profile.0.0.1

echo "Create a FITS header describing the footprint of the mosaic"
tau_exec -memory -T mpi,pdt,papi mMakeHdr Kimages.tbl Ktemplate.hdr
cp profile.0.0.0 profiles/profile.0.0.2

echo "Reproject the input images"
tau_exec -memory -T mpi,pdt,papi mProjExec -p Kimages Kimages.tbl Ktemplate.hdr Kprojdir Kstats.tbl
cp profile.0.0.0 profiles/profile.0.0.3

echo "Create a metadata table of the reprojected images"
tau_exec -memory -T mpi,pdt,papi mImgtbl Kprojdir/ images.tbl
cp profile.0.0.0 profiles/profile.0.0.4

echo "Coadd the images to create a mosaic without background corrections"
tau_exec -memory -T mpi,pdt,papi mAdd -p Kprojdir/ images.tbl Ktemplate.hdr m17_uncorrected.fits
cp profile.0.0.0 profiles/profile.0.0.5

echo "Make a PNG of the mosaic for visualization"
tau_exec -memory -T mpi,pdt,papi mViewer -ct 1 -gray m17_uncorrected.fits -1s max gaussian-log -out m17_uncorrected.png
cp profile.0.0.0 profiles/profile.0.0.6

echo "Analyze the overlaps between images"
tau_exec -memory -T mpi,pdt,papi mOverlaps images.tbl diffs.tbl
cp profile.0.0.0 profiles/profile.0.0.7
tau_exec -memory -T mpi,pdt,papi mDiffExec -p Kprojdir/ diffs.tbl Ktemplate.hdr diffdir
cp profile.0.0.0 profiles/profile.0.0.8
tau_exec -memory -T mpi,pdt,papi mFitExec diffs.tbl fits.tbl diffdir
cp profile.0.0.0 profiles/profile.0.0.9

echo "Perform background modeling and compute corrections for each image"
tau_exec -memory -T mpi,pdt,papi mBgModel images.tbl fits.tbl corrections.tbl
cp profile.0.0.0 profiles/profile.0.0.10

echo "Apply corrections to each image"
tau_exec -memory -T mpi,pdt,papi mBgExec -p Kprojdir/ images.tbl corrections.tbl corrdir
cp profile.0.0.0 profiles/profile.0.0.11

echo "Coadd the images to create a mosaic with background corrections"
tau_exec -memory -T mpi,pdt,papi mAdd -p corrdir/ images.tbl Ktemplate.hdr m17.fits
cp profile.0.0.0 profiles/profile.0.0.12

echo "Make a PNG of the corrected mosaic for visualization"
tau_exec -memory -T mpi,pdt,papi mViewer -ct 1 -gray m17.fits -1s max gaussian-log -out m17.png
cp profile.0.0.0 profiles/profile.0.0.13

rm profile.0.0.0
