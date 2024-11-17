# Gene-Taxa Downstream Analysis

This repository contains a series of scripts of methods that we compare to our **[Scorpio](https://github.com/EESI/Scorpio)** model. The tools used for comparison include **Kraken2**, **MMseqs2**, **BERTax**, and **DeepMicrobes**.

##  Steps

### Data Preparation
- Download gene-taxa datasets from Zenodo.
- Extract and preprocess FASTA files for Kraken2.
- Modify headers to ensure compatibility with tools like Kraken2.

```bash
wget -P gene-taxa-dataset https://zenodo.org/api/records/12964684/files-archive
unzip gene-taxa-dataset/files-archive -d gene-taxa-dataset
```

### Kraken2 
- **Download Taxonomy Database**:
  ```bash
  singularity exec kraken2_latest.sif kraken2-build --download-taxonomy --db ./databases
  ```
- **Add Sequences to Database**:
  ```bash
  kraken2-build --add-to-library train_kraken_like.fasta --db ./databases
  ```
- **Inference on Taxa**:
  ```bash
  kraken2 --db ./databases --output kraken2_results.txt --report kraken2_report.txt taxa_out.fasta
  ```

### MMseqs2 
- Perform sequence similarity searches using:
  ```bash
  mmseqs easy-search taxa_out.fasta train.fasta taxa_out.m8 tmp --max-accept 1 --max-seqs 1 --search-type 3
  ```

### BERTax
- Pull and run the BERTax model:
  ```bash
  singularity pull bertax.sif docker://fkre/bertax
  singularity run --bind ${PWD}:/mnt --nv bertax.sif -o result_test.txt test.fasta
  ```

### DeepMicrobes
- Prepare datasets and train models:
  ```bash
  tfrec_train_kmer.sh -i train_gene_label.fasta -v tokens_merged_8mers.txt -o train_gene.tfrec -k 8 -s 2000
  python3 DeepMicrobes.py --input_tfrec train_gene.tfrec --model_name attention --model_dir gene_model --num_classes 437
  ```

### ART Simulation
- Simulate Illumina reads:
  ```bash
  ./art_illumina -ss HS25 -i gene_out.fasta -l 150 -f 20 -m 200 -s 10 -o simulated_art
  ```

