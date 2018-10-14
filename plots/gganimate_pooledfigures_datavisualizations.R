##install gganimate 
#library(devtools) 
#install_github('thomasp85/gganimate') 

##import libraries 
library(data.table)
library(ggplot2)
library(dplyr)
library(gganimate)
library(devtools)
library(animation)

  ##Todo notes; 
  #add in slider feature 
  #edit output width/height/resolution to be 1000px+ 
  #output to pdf 
  #add in plot descriptions 
  #create rmarkdown sheet 
  #integrate with Shiny 

###################################
##Import dataset

##fread import 
life_data_sep_avg <- fread("C:/Users/Owner/Documents/haqseq2018/life_data_sep_avg.csv", sep = ",")

# convert data types 
life_data_sep_avg[, Age_group := as.integer(Age_group)]
life_data_sep_avg[, YEAR := as.integer(YEAR)]

##label settings 
titleformat <- element_text(face = "bold", size = 14, color = "black")
labelformat <- element_text(face = "bold", size = 12, color = "black")

###------------------------POOLED vISUALIZATIONS BY PROVINCE ----------------------------- 
###------------Number of survivors at age x--------
##prepare data for plot 
survivordata <- life_data_sep_avg[Element == "Number of survivors at age x (lx)" & Sex %in% c("M", "F") & YEAR %in% seq(1980, 2016, 4)]
survivordata
colnames(survivordata)

##generate ggplot & gganimate 
survivorggplot <- ggplot(survivordata, aes(Age_group, AVG_VALUE, color = Sex)) + 
  geom_point(alpha = 0.6, size = 2, show.legend = TRUE) + 
  facet_wrap(~ GEO) +
  scale_x_continuous(breaks = c(0, seq(20,120,20)), limits = c(0, 120)) + 
  scale_y_continuous(breaks = c(0, seq(10000, 100000, 10000))) + 
  scale_colour_discrete() +
  theme_set(theme_bw()) + 
  theme(title = titleformat, axis.text = labelformat) + 
  transition_time(YEAR) +
  ease_aes('linear')+
  labs(title = "Canadian Survival Rates Across Time", subtitle = 'Year: {frame_time}', x = 'Age', y = 'Number of Survivors', color = "Sex") 

##view 
survivorggplot
##save the plot 
anim_save("canadiansurvivorplot.gif", animation = last_animation(), path = '~')


###------------Number of Deaths at age x-----------
##prepare data for plot 
deathdata <- life_data_sep_avg[Element == "Number of deaths between age x and x+1 (dx)" & Sex %in% c("M", "F") & YEAR %in% seq(1980, 2016, 1)]
deathdata
colnames(deathdata)

##generate ggplot & gganimate 
deathggplot <- ggplot (deathdata, aes(Age_group, AVG_VALUE, color = Sex)) +
  geom_point(alpha = 0.6, size = 2, show.legend = TRUE) + 
  facet_wrap(~ GEO) +
  scale_x_continuous(breaks = c(0, seq(20,120,20)), limits = c(0, 120)) + 
  scale_y_continuous(breaks = c(0, seq(10000, 100000, 10000))) + 
  scale_colour_discrete() +
  theme_set(theme_bw()) + 
  theme(title = titleformat, axis.text = labelformat) + 
  transition_time(YEAR) +
  ease_aes('linear')+
  labs(title = "Canadian Death Rates Across Time", subtitle = 'Year: {frame_time}', x = 'Age', y = 'Number of Deaths', color = "Sex") 


##view deathggplot
deathggplot

##save the plot 
anim_save("canadadeathplot.gif", animation = last_animation(), path = '~')

###----------------------- POOLED VISUALIZATIONS of survival BY GENDER --------------------------- 

###------------Number of Female survivors at age x--------
##prepare data for plot 
femalesurvivordata <- life_data_sep_avg[Element == "Number of survivors at age x (lx)" & Sex %in% c("F") & YEAR %in% seq(1980, 2016, 1)]
femalesurvivordata

##generate plot 
femalesurvivalplot <- ggplot(femalesurvivordata, aes(Age_group, AVG_VALUE, color = GEO)) +
  geom_point(alpha = 0.6, size = 2, show.legend = TRUE) + 
  scale_x_continuous(breaks = c(0, seq(20,120,20)), limits = c(0, 120)) + 
  scale_y_continuous(breaks = c(0, seq(10000, 100000, 10000))) + 
  scale_color_hue()+
  theme_set(theme_bw()) + 
  theme(title = titleformat, axis.text = labelformat) + 
  transition_time(YEAR) +
  ease_aes('linear')+
  labs(title = "Canadian Female Survival Rates Across Time", subtitle = 'Year: {frame_time}', x = 'Age', y = 'Number of Survivors', color = "Province") 

##view 
femalesurvivalfinal
##save the plot 
anim_save("femalesurvivorplot.gif", animation = last_animation(), path = '~')


###------------Number of Male survivors at age x--------
##prepare data for plot 
malesurvivordata <- life_data_sep_avg[Element == "Number of survivors at age x (lx)" & Sex %in% c("M") & YEAR %in% seq(1980, 2016, 1)]
malesurvivordata

##generate plot 
malesurvivalplot <- ggplot(malesurvivordata, aes(Age_group, AVG_VALUE, color = GEO)) +
  geom_point(alpha = 0.6, size = 2, show.legend = TRUE) + 
  scale_x_continuous(breaks = c(0, seq(20,120,20)), limits = c(0, 120)) + 
  scale_y_continuous(breaks = c(0, seq(10000, 100000, 10000))) + 
  scale_color_hue()+
  theme_set(theme_bw()) + 
  theme(title = titleformat, axis.text = labelformat) + 
  transition_time(YEAR) +
  ease_aes('linear')+
  labs(title = "Canadian Male Survival Rates Across Time", subtitle = 'Year: {frame_time}', x = 'Age', y = 'Number of Survivors', color = "Province") 

#view 
malesurvivalplot

##save the plot 
anim_save("malesurvivorplot.gif", animation = last_animation(), path = '~')

###------------------------- POOLED VISUALIZATIONS OF DEATH BY GENDER -------------------------- 

###------------Number of Female Deaths--------
##prepare the data 
femaledeathdata <- life_data_sep_avg[Element == "Number of deaths between age x and x+1 (dx)" & Sex %in% c("F") & YEAR %in% seq(1980, 2016, 1)]
femaledeathdata
##generate plot
femaledeathplot <- ggplot(femaledeathdata, aes(Age_group, AVG_VALUE, color = GEO)) +
  geom_point(alpha = 0.6, size = 2, show.legend = TRUE) + 
  scale_x_continuous(breaks = c(0, seq(20,120,20)), limits = c(0, 120)) + 
  scale_y_continuous(breaks = c(0, seq(10000, 100000, 10000))) + 
  scale_color_hue()+
  theme_set(theme_bw()) + 
  theme(title = titleformat, axis.text = labelformat) + 
  transition_time(YEAR) +
  ease_aes('linear')+
  labs(title = "Canadian Female Death Rates Across Time", subtitle = 'Year: {frame_time}', x = 'Age', y = 'Number of Deaths', color = "Province") 
#view
femaledeathplot
##save the plot 
anim_save("femaledeathplot.gif", animation = last_animation(), path = '~')

###------------Number of Male Deaths--------
##prepare the data 
maledeathdata <- life_data_sep_avg[Element == "Number of deaths between age x and x+1 (dx)" & Sex %in% c("M") & YEAR %in% seq(1980, 2016, 1)]
maledeathdata
##generate plot 
maledeathplot <- ggplot(maledeathdata, aes(Age_group, AVG_VALUE, color = GEO)) +
  geom_point(alpha = 0.6, size = 2, show.legend = TRUE) + 
  scale_x_continuous(breaks = c(0, seq(20,120,20)), limits = c(0, 120)) + 
  scale_y_continuous(breaks = c(0, seq(10000, 100000, 10000))) + 
  scale_color_hue()+
  theme_set(theme_bw()) + 
  theme(title = titleformat, axis.text = labelformat) + 
  transition_time(YEAR) +
  ease_aes('linear')+
  labs(title = "Canadian Male Death Rates Across Time", subtitle = 'Year: {frame_time}', x = 'Age', y = 'Number of Deaths', color = "Province") 
##view 
maledeathplot
##save the plot 
anim_save("maledeathplot.gif", animation = last_animation(), path = '~')

