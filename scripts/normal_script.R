
# Packages ----------------------------------------------------------------

install.packages('remotes') # for installing packages from sources that aren't CRAN
library(remotes) # load the package

install_github("allisonhorst/palmerpenguins") #installing development version of dataset
library(palmerpenguins) # loading the package which contains dataset we will use


install.packages('tidyverse')
library(tidyverse) # loading tidyverse package for ggplot etc.


# Session Info ------------------------------------------------------------

sessionInfo()

# R version 3.6.2 (2019-12-12)
# Platform: x86_64-apple-darwin15.6.0 (64-bit)
# Running under: macOS Catalina 10.15.7
# 
# Matrix products: default
# BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
# LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib
# 
# locale:
#   [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
# 
# attached base packages:
#   [1] stats     graphics 
# [3] grDevices utils    
# [5] datasets  methods  
# [7] base     
# 
# other attached packages:
#   [1] forcats_0.4.0       
# [2] stringr_1.4.0       
# [3] dplyr_1.0.1.9000    
# [4] purrr_0.3.4         
# [5] readr_1.3.1         
# [6] tidyr_1.1.1         
# [7] tibble_3.0.3        
# [8] ggplot2_3.2.1       
# [9] tidyverse_1.3.0     
# [10] palmerpenguins_0.1.0
# [11] remotes_2.4.2       
# 
# loaded via a namespace (and not attached):
#   [1] Rcpp_1.0.2       
# [2] cellranger_1.1.0 
# [3] compiler_3.6.2   
# [4] pillar_1.4.6     
# [5] dbplyr_1.4.2     
# [6] prettyunits_1.0.2
# [7] tools_3.6.2      
# [8] pkgbuild_1.1.0   
# [9] lubridate_1.7.4  
# [10] jsonlite_1.7.0   
# [11] gtable_0.3.0     
# [12] lifecycle_1.0.1  
# [13] nlme_3.1-142     
# [14] lattice_0.20-38  
# [15] pkgconfig_2.0.3  
# [16] rlang_1.0.2      
# [17] reprex_0.3.0     
# [18] cli_3.2.0        
# [19] DBI_1.0.0        
# [20] rstudioapi_0.11  
# [21] curl_4.0         
# [22] haven_2.3.1      
# [23] xml2_1.2.2       
# [24] httr_1.4.1       
# [25] withr_2.5.0      
# [26] fs_1.3.1         
# [27] hms_0.5.3        
# [28] generics_0.0.2   
# [29] vctrs_0.3.2      
# [30] rprojroot_1.3-2  
# [31] grid_3.6.2       
# [32] tidyselect_1.1.0 
# [33] glue_1.6.2       
# [34] R6_2.4.1         
# [35] processx_3.4.1   
# [36] readxl_1.3.1     
# [37] modelr_0.1.5     
# [38] callr_3.4.3      
# [39] magrittr_1.5     
# [40] scales_1.0.0     
# [41] backports_1.1.4  
# [42] ps_1.3.0         
# [43] ellipsis_0.3.1   
# [44] rvest_0.3.6      
# [45] assertthat_0.2.1 
# [46] colorspace_1.4-1 
# [47] stringi_1.4.3    
# [48] lazyeval_0.2.2   
# [49] munsell_0.5.0    
# [50] broom_0.5.6      
# [51] crayon_1.3.4 


# Create data -------------------------------------------------------------

data(penguins, package = "palmerpenguins")

write.csv(penguins_raw, "raw_data/penguins_raw.csv", row.names = FALSE)

write.csv(penguins,"data/penguins.csv",row.names = FALSE)


# Load data ---------------------------------------------------------------

pen.data <- read.csv("data/penguins.csv")

str(pen.data) # look at data types (e.g., factor, character)
colnames(pen.data) # look at the column names

# [row, column] and we want columns 3:6 and 8 which are the numeric variables
#?pairs # will give you information about the function

pairs(pen.data[,c(3:6,8)]) # pairwise correlation plot of numeric columns;you can see if you need to transform any of those variables

hist(pen.data$body_mass_g)  # make a histogram    
?hist


boxplot(pen.data$body_mass_g ~ pen.data$species) # boxplot of body mass x species
?boxplot


# save boxplot as pdf -----------------------------------------------------

pdf("outputs/wt_by_spp.pdf",
    width = 7,
    height = 5) # open a graphics device (everything you print to the screen while this is open will be saved to the file name that you give here), there are analogous functions for png and other image types


boxplot(pen.data$body_mass_g ~ pen.data$species, xlab="Species", ylab="Body Mass (g)") # print the boxplot to the pdf file


dev.off() #close the graphics device (very important to run this line or the pdf won’t save and will continue to add new plots that you run afterwards. all the plots you make before the dev.off get added)



# ggplot! -----------------------------------------------------------------

pen_fig <- pen.data %>% # calling on the data
  drop_na() %>%  # dropping "NAs" from the plot
  ggplot(aes(y = body_mass_g, x = sex, # aesthetic: y = body mass, x = sex
             colour = sex)) + # colour violin plots by sex
  facet_wrap(~species) + # each species will have it's own plot
  geom_violin(trim = FALSE, # violin plot, turn off trim the edges
              lwd = 1) + # make the lines thick
  theme_bw() + # black and white background theme
  theme(text = element_text(size = 12), # change the text size
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size=12),
        legend.position = "none") + # remove the legend
  labs(y = "Body Mass (g)", # specify labels on axes
       x = " ") +
  scale_colour_manual(values = c("black", "darkgrey"))

pen_fig

ggsave("outputs/pen_fig.jpeg", pen_fig, # save figure to output
       width = 7,
       height = 5)
