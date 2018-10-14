
# Please install a recent version of R (>3.5) https://cloud.r-project.org/ and
# RStudio (>1.1) https://www.rstudio.com/products/rstudio/#Desktop
# before installing the packages below.

# A script to check whether particular packages are installed and if not installed, install them.

# List of useful packages to install
useful_packages <- c("tidyverse", "ggplot2", "knitr", "plotly", "shiny",
                         "ggvis", "htmlwidgets", "DT", "googleVis",
                         "survival", "survminer",
                         "sp", "maptools", "ggmap", "maps")

# Check what packages are already installed
installed_packages <- installed.packages()

# Take the difference to only install those packages that aren't already installed
packages_to_install <- setdiff(useful_packages, rownames(installed_packages))

install.packages(packages_to_install)

# check that all the installations were successful
installed_packages <- installed.packages()
packages_to_install <- setdiff(useful_packages, rownames(installed_packages))

ifelse(length(packages_to_install) == 0, 
       print("All packages successfully installed"),
       print(paste0("Something went wrong with these packages: ", 
                    packages_to_install, 
                    ".")
             )
       )

