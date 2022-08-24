
### Behavioral analyses for Dorfman, et al., 2019 ###

##--------------------------------------------------------Experiment 1--------------------------------------------------------##


lr_df <- read.csv("/Users/hayleydorfman/Dropbox/studies/OptControl/PsychSci_2019_OpenMaterials/exp1_data/exp1_behav_data.csv") #read in data

#----------Stat1: Exp 1----------------#


#Participants were more likely to believe that a hidden cause resulted in negative outcomes, as opposed to positive outcomes

lr_df_means6 <- ddply(lr_df, .(subject, feedback), summarize, mean_guess=mean(latent_guess, na.rm = T))
t.test(mean_guess ~ feedback, data = lr_df_means6, paired = TRUE) #t=4.71, p<0.001, CI [0.0799, 0.197]
cohen.d(lr_df_means6$mean_guess ~ lr_df_means6$feedback | Subject (subject), paired = TRUE, within = FALSE) #d= 0.554 CI[0.30, 0.80]

#----------Stat2: Exp 1----------------#

#Importantly, participants were more likely to believe that the hidden agent had intervened after negative than after positive outcomes in the adversarial condition
#and after positive than after negative outcomes in the benevolent condition
#Participants were also slightly more likely to believe that the hidden agent had intervened after negative outcomes in the neutral condition

#split by condition
df1 <- subset(lr_df, condition == 1)
df2 <- subset(lr_df, condition == 2)
df3 <- subset(lr_df, condition == 3)

#adversarial
lr_df_means_adv <- ddply(df1, .(subject, feedback), summarize, mean_guess_adv=mean(latent_guess, na.rm = T))
t.test(mean_guess_adv ~ feedback, data = lr_df_means_adv, paired = TRUE) #t=17.556, p < 0.001, CI [0.536, 0.674]
cohen.d(lr_df_means_adv$mean_guess_adv ~ lr_df_means_adv$feedback | Subject(subject), paired = TRUE, within = FALSE) #d=2.069

#benevolent
lr_df_means_ben <- ddply(df2, .(subject, feedback), summarize, mean_guess_ben=mean(latent_guess, na.rm = T))
t.test(mean_guess_ben ~ feedback, data = lr_df_means_ben, paired = TRUE)  #t= -10.377, p < 0.001, CI [-0.492, -0.333]
cohen.d(lr_df_means_ben$mean_guess_ben ~ lr_df_means_ben$feedback | Subject(subject), paired = TRUE, within = FALSE) #d= -1.223

#neutral
lr_df_means_rand <- ddply(df3, .(subject, feedback), summarize, mean_guess_rand=mean(latent_guess, na.rm = T))
t.test(mean_guess_rand ~ feedback, data = lr_df_means_rand, paired = TRUE) #t = 2.223, p = 0.0294
cohen.d(lr_df_means_rand$mean_guess_rand ~ lr_df_means_rand$feedback | Subject(subject), paired = TRUE, within = FALSE) #d = 0.2619


#---------Stat3: Exp1-----------------------------------#

#participants generally learned more from positive than from negative outcomes across all conditions

lr_df_means <- ddply(lr_df, .(subject, feedback), summarize, mean_lr=mean(lr, na.rm = TRUE))
t.test(mean_lr ~ feedback, data = lr_df_means, paired = TRUE) #t = 3.10, p = 0.002, CI [0.002, 0.011]
cohen.d(lr_df_means$mean_lr ~ lr_df_means$feedback | Subject(subject), paired = TRUE, within = FALSE) #d = 0.365


#---------Stat4: Exp1-----------------------------------#
#We found that learning rates were significantly lower for trials in which participants believed that the hidden agent intervened, compared with trials in which participants believed that the hidden agent did not intervene

lr_df_means2 <- ddply(lr_df, .(subject, latent_guess), summarize, mean_lr=mean(lr, na.rm = F))
t.test(mean_lr ~ latent_guess, data = lr_df_means2, paired = TRUE) # t=10.377, p < 0.0001, CI [0.0247, 0.0365]
cohen.d(lr_df_means2$mean_lr ~ lr_df_means2$latent_guess | Subject(subject), paired = TRUE, within = FALSE) #d=1.222

##--------------------------------------------------------Experiment 2--------------------------------------------------------##

lr_df <- read.csv("/Users/hayleydorfman/Dropbox/studies/OptControl/PsychSci_2019_OpenMaterials/exp2_data/exp2_behav_data.csv") #read in data

#----------Stat1: Exp 2----------------#
#Participants believed that the hidden agent caused negative outcomes more often than positive outcomes across all conditions

lr_df_means6 <- ddply(lr_df, .(subject, feedback), summarize, mean_guess=mean(latent_guess, na.rm = T))
t.test(mean_guess ~ feedback, data = lr_df_means6, paired = TRUE) #t=6.26, p<0.001, CI [0.0768, 0.147]
cohen.d(lr_df_means6$mean_guess ~ lr_df_means6$feedback | Subject (subject), paired = TRUE, within = FALSE) #d= 0.392


#----------Stat2: Exp 2----------------#
#participants were more likely to believe that the hidden agent had intervened after negative compared to positive outcomes in the adversarial condition and for positive compared to negative outcomes in the benevolent condition. Participants were also slightly more likely to believe that the hidden agent had intervened after negative outcomes in the neutral condition

df1 <- subset(lr_df, condition == 1)
df2 <- subset(lr_df, condition == 2)
df3 <- subset(lr_df, condition == 3)

lr_df_means_adv <- ddply(df1, .(subject, feedback), summarize, mean_guess_adv=mean(latent_guess, na.rm = T))
t.test(mean_guess_adv ~ feedback, data = lr_df_means_adv, paired = TRUE) #t = 43.721, p < 0.0001, CI [0.680, 0.744]
cohen.d(lr_df_means_adv$mean_guess_adv ~ lr_df_means_adv$feedback | Subject (subject), paired = TRUE, within = FALSE) #d = 2.737

lr_df_means_ben <- ddply(df2, .(subject, feedback), summarize, mean_guess_ben=mean(latent_guess, na.rm = T))
t.test(mean_guess_ben ~ feedback, data = lr_df_means_ben, paired = TRUE)  #t = -21.777, p < 0.0001, CI [-0.586, -0.489]
cohen.d(lr_df_means_ben$mean_guess_ben ~ lr_df_means_ben$feedback | Subject (subject), paired = TRUE, within = FALSE)  #d= -1.363

lr_df_means_rand <- ddply(df3, .(subject, feedback), summarize, mean_guess_rand=mean(latent_guess, na.rm = T))
t.test(mean_guess_rand ~ feedback, data = lr_df_means_rand, paired = TRUE) #t = 1.619, p = 0.106, CI [-0.011, 0.1183]
cohen.d(lr_df_means_rand$mean_guess_rand ~ lr_df_means_rand$feedback | Subject (subject), paired = TRUE, within = FALSE) #d=0.101


#---------Stat3: Exp2-----------------------------------#
#participants had significantly higher learning rates for positive outcomes than for negative outcomes


lr_df_means <- ddply(lr_df, .(subject, feedback), summarize, mean_lr=mean(lr, na.rm = TRUE))
t.test(mean_lr ~ feedback, data = lr_df_means, paired = TRUE) #t = 3.569, p < 0.001, CI [0.002, 0.006]
cohen.d(lr_df_means$mean_lr ~ lr_df_means$feedback | Subject (subject), paired = TRUE, within = FALSE) #d = 0.223



#---------Stat4: Exp2-----------------------------------#
#learning rates were significantly lower for trials in which participants believed that the hidden agent intervened, compared with trials in which they believed that the hidden agent did not intervene

lr_df_means2 <- ddply(lr_df, .(subject, latent_guess), summarize, mean_lr=mean(lr, na.rm = F))
lr_df_means3 <- subset(lr_df_means2, subject != 37249 & subject != 94487) #remove subjs who always answered 0 or 1
t.test(mean_lr ~ latent_guess, data = lr_df_means3, paired = TRUE) # t = 17.551, df=252, p < 0.0001, CI [0.0405, 0.0507]
cohen.d(lr_df_means3$mean_lr ~ lr_df_means3$latent_guess | Subject (subject), paired = TRUE, within = FALSE) #d=1.1033
















