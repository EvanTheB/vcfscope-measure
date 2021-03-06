# VCFscope

VCFscope is a tool to investigate and report on the performance of a genome analysis pipeline. It does this by comparing variant calls (in vcf format, with a matched BAM file) generated by an analytical pipeline, to variant calls from a gold standard. Currently this is limited to germline sequencing of NA12878, compared to the GiaB consortium gold-standard reference. This DNAnexus app produces a raw data file (R's RDS format) that is then processed by VCFScope Report to make a detailed human-readable report.

## Inputs
* [Required] vcfgz: A `.vcf.gz` of variants called in an NA12878 sample. This must be a single-sample VCF file.
* [Required] bam: A `.bam` of mapped reads used to generate the variants above.
* [Required] bai: A `.bai` index for the BAM file above.
* [Optional] region: A `.bed` file of genomic intervals; only variants overlapping at least one of these intervals will be considered in calculations.  If missing, the entire genome and reportable range are considered.

## vcfscope_reporter_resources_bundle-2.0.tar
The app unpacks a tar bundle, which contains:
* the NIST v2.19 vcf and bed file
* mdust low complexity regions
* hs37d5 reference genome, in RTG format
* reportable range files, as defined by Garvan
* RTG executable

    ├── gold_standard
    │   ├── calls-2.19.vcf.gz
    │   ├── calls-2.19.vcf.gz.tbi
    │   └── valid_regions-2.19.bed.gz
    ├── redundant_regions
    │   └── mdust.bed.gz
    ├── reference
    │   └── hs37d5.sdf
    │       ├── done
    │       ├── format.log
    │       ├── mainIndex
    │       ├── namedata0
    │       ├── nameIndex0
    │       ├── namepointer0
    │       ├── progress
    │       ├── seqdata0
    │       ├── seqdata1
    │       ├── seqdata2
    │       ├── seqdata3
    │       ├── seqpointer0
    │       ├── seqpointer1
    │       ├── seqpointer2
    │       ├── seqpointer3
    │       ├── sequenceIndex0
    │       ├── suffixdata0
    │       ├── suffixIndex0
    │       ├── suffixpointer0
    │       └── summary.txt
    ├── reportable_range
    │   ├── genome.bed.gz
    │   └── reportable_range.bed
    └── rtg-tools
        └── RTG.jar

## R package dependencies
* This has been tested extensively with R 3.2.0, and more recently, but to less extent, R 3.2.3. The R package
dependencies are captured within the vcfscope-asset/Makefile.

## Output
* RDS of performance metrics.
