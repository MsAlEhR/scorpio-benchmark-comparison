#!/bin/bash
#SBATCH --partition=def
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5
#SBATCH --time=4:00:00
#SBATCH --mem=10G
#SBATCH --job-name=triplet
#SBATCH --output=./slurm/download_log.%A_%a.out   # Standard output and error log
#SBATCH --array=1-4634   # Job array with the total number of accessions from the file


module load python/anaconda3
. ~/.bashrc

conda activate base


# Set the output directory
output_directory='download_standard'

# Ensure the output directory exists, create it if necessary
if [ ! -d $output_directory ]; then
  mkdir -p $output_directory
fi

# Read the accession list from the file
current_accession=$(sed -n "${SLURM_ARRAY_TASK_ID}p" accession_2.txt)

# Run the datasets download genome command for the current accession
datasets download genome accession $current_accession --include cds --filename $output_directory/$current_accession.zip

# Check if the file was downloaded successfully
if [ -e $output_directory/$current_accession.zip ]; then
  echo "Downloaded $current_accession.zip"
else
  echo "Failed to download $current_accession"
fi
