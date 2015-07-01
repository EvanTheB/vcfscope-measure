#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail


main() {
  #
  # Fetch inputs (~/in/vcfgz/*)
  #
  dx-download-all-inputs --parallel

  #
  # Locate the assets bundle, the location of which varies, depending on whether
  # this is an app or an applet.
  #
  if [[ "$DX_RESOURCES_ID" != "" ]]; then
    # This is an app; fetch assets from the app's private asset container
    DX_ASSETS_ID="$DX_RESOURCES_ID"
  else
    # This is an applet; fetch assets from the parent project
    DX_ASSETS_ID="$DX_PROJECT_CONTEXT_ID"
  fi

  #
  # Stream and unpack assets bundle
  #
  mkdir ~/resources
  cd ~/resources
  dx cat "${DX_ASSETS_ID}:/assets/kccg_validation_reporter_resources_bundle-1.0.tar.gz" | tar zxf - # => functional_regions/* gold_standard/* kccg/* mask_regions/* orig/*

  #
  # setup R
  #
  cd ~
  # This R is Aaron's R-3.2.0 with pre-installed packages, with the following 
  # additional packages pre-installed:
  # CRAN: inline, RSQLite, png, gsalib
  # BioC: VariantAnnotation, GenomicRanges, BSgenome
  dx cat "${DX_ASSETS_ID}:/assets/R-3.2.0.compiled.packages_v2.tar.gz" | tar -zxf -
  export PATH="$PWD/bin:$PATH"
  export RHOME=${HOME} # This is needed to make RScript work, since it was compiled in a different dir.

  dx get "${DX_ASSETS_ID}:/assets/BSgenome.HSapiens.1000g.37d5_1.0.0.tar.gz"
  R CMD INSTALL BSgenome.HSapiens.1000g.37d5_1.0.0.tar.gz

  #
  # process options
  #
  if [ "${extended}" == "true" ]; then
    opts+=("-x")
  fi
  if [ "${runtests}" == "true" ]; then
    opts+=("-t")
  fi
  if [ -n "${region}" ]; then
    opts+=("-r" "${region_path}")
  fi

  #
  # run report
  #
  mkdir -p ~/out/report/
  sample_basename=$(basename ${vcfgz_path} .vcf.gz)
  ./validation_report.sh -o ~/out/report/${sample_basename}.valrept.pdf "${opts[@]}" ${vcfgz_path}

  #
  # upload results
  #
  dx-upload-all-outputs
  propagate-user-meta vcfgz report
}
