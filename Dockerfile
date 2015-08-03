FROM brenninc/r-base

#Install R packages
RUN apt-get install -y --force-yes \
    libcairo2-dev \
    libxt-dev \
    r-cran-colorspace \
    r-cran-dichromat \
    r-cran-digest \
    r-cran-Formula \
    r-cran-ggplot2 \
    r-cran-gtable \
    r-cran-Hmisc \
    r-cran-labeling \
    r-cran-latticeExtra \
    r-cran-munsell \
    r-cran-plyr \
    r-cran-proto \
    r-cran-Rcpp \
    r-cran-RcppArmadillo \
    r-cran-RColorBrewer \
    r-cran-reshape \
    r-cran-rjson \
    r-cran-scales \
    r-cran-snow \
    r-cran-SparseM \
    r-cran-XML \
    r-cran-xtable 

RUN \   
    curl https://cran.r-project.org/src/contrib/brew_1.0-6.tar.gz > brew_1.0-6.tar.gz && \
    curl https://cran.r-project.org/src/contrib/Cairo_1.5-8.tar.gz > Cairo_1.5-8.tar.gz && \
    curl https://cran.r-project.org/src/contrib/flexmix_2.3-13.tar.gz > flexmix_2.3-13.tar.gz && \
    curl https://cran.r-project.org/src/contrib/magrittr_1.5.tar.gz > magrittr_1.5.tar.gz && \
    curl https://cran.r-project.org/src/contrib/modeltools_0.2-21.tar.gz > modeltools_0.2-21.tar.gz && \
    curl https://cran.r-project.org/src/contrib/quantreg_5.11.tar.gz > quantreg_5.11.tar.gz && \
    curl https://cran.r-project.org/src/contrib/rjson_0.2.15.tar.gz > rjson_0.2.15.tar.gz && \
    curl https://cran.r-project.org/src/contrib/Rook_1.1-1.tar.gz > Rook_1.1-1.tar.gz && \
    curl https://cran.r-project.org/src/contrib/stringi_0.5-5.tar.gz > stringi_0.5-5.tar.gz && \
    curl https://cran.r-project.org/src/contrib/stringr_1.0.0.tar.gz > stringr_1.0.0.tar.gz && \
    R CMD INSTALL \ 
        modeltools_0.2-21.tar.gz \
        flexmix_2.3-13.tar.gz \
        brew_1.0-6.tar.gz \
        Rook_1.1-1.tar.gz \
        Cairo_1.5-8.tar.gz \
        quantreg_5.11.tar.gz \
        stringi_0.5-5.tar.gz \
        magrittr_1.5.tar.gz && \
    rm *.tar.gz
        
RUN R -e 'source("http://bioconductor.org/biocLite.R"); biocLite("edgeR"); biocLite("DESeq2");' 
    
RUN curl http://pklab.med.harvard.edu/scde/scde_1.2.1.tar.gz > scde_1.2.tar.gz && \
    R CMD INSTALL scde_1.2.tar.gz && \
    rm scde_1.2.tar.gz
    



