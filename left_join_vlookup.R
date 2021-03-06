##INSTALL PACKAGES FIRST TIME YOU RUN

install.packages("tidyverse")
install.packages("magrittr")
install.packages("Lahman")

##LOAD PACKAGES

library(tidyverse)
library(magrittr)
library(Lahman)


###BUILD THE INITIAL EXCEL FILE##

# t <- Teams
# head(t)
# filter(t,name=="Washington Nationals")
# #WAS
# filter(t,name=="Colorado Rockies")
# #COL
# filter(t,name=="Houston Astros")
# #HOU

d <- Batting
keep <- c("WAS","COL","HOU")

names(d)
library(magrittr)
d %<>% filter(.,teamID %in% keep)
d %<>% filter(.,yearID >= 1962)
d %<>% distinct(playerID,.keep_all = T)

library(xlsx)
write.xlsx(d,"Desktop/baseball.xlsx",sheetName = "batters",col.names = T,row.names = F,append = F)

m <- Master
head(m)

m %<>% select(.,playerID,birthCity,birthState,birthYear)
m %<>% filter(., birthYear >= 1930)

write.xlsx(m,"Desktop/baseball.xlsx",sheetName = "birth_info",col.names = T,row.names = F,append = T)


##END GOAL##

#1. APPEND BIRTH YEAR TO TEAM STATS FILE
#2. CALCULATE THE AGE OF THE PLAYER AT THE TIME HE FIRST JOINED THE TEAM
#3. CALCULATE THE AVERAGE AGE OF ALL PLAYERS IN THE GROUP
#4. SAVE TO EXCEL FILE FOR SENDING BACK TO CLIENT

#=VLOOKUP(A2,birth_info!A2:D10226,4,FALSE)

###THE MAGIC OF REPRODUCIBLE DATA##

#READ IN BATTER DATA FROM EXCEL FILE

players <- read.xlsx("Desktop/baseball.xlsx",sheetName = "batters_orig",as.data.frame = T,stringsAsFactors = F)
head(players)

birth <- read.xlsx("Desktop/baseball.xlsx",sheetName = "birth_info_orig",as.data.frame = T,stringsAsFactors = F)
head(birth)


##HERE IS THE CODE THAT

#MERGES THE DATA FILES
#CREATES TWO NEW VARIABLES
#ORDERS THE VARIABLES
#CREATES A DATA FRAME CALLED 'PLAYERS'


players <- left_join(players,birth) %>%
        mutate(age_first_year = yearID - birthYear,
               avg_age = mean(age_first_year,na.rm = T)) %>%
        select(playerID,yearID,birthYear,age_first_year,avg_age,stint:GIDP) %>%
        as.data.frame(.)
        

#This could also be accomplished in five separate lines, but the piping operators reduce redundant typing

# players <- left_join(players,birth)
# 
# players$age_first_year <- players$yearID - players$birthYear
# 
# players$avg_age <- mean(players$age_first_year)
# 
# players <- select(players, playerID,yearID,birthYear,age_first_year,avg_age,stint:GIDP)
# 
# players <- as.data.frame(players)

###

##EXPORT PLAYERS DATA FRAME BACK TO EXCEL

head(players)

write.xlsx(players,"Desktop/baseball.xlsx",sheetName = "left_join",row.names = F,append = T)


##TA DA!!##