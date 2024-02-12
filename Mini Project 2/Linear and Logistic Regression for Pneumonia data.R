phnumo<-read.table(file=file.choose(),header=TRUE,sep=',')

#we start with a model which uses all 20 variables in the dataset
phnumomodel<-lm(tcs_days~dem_age+dem_sex+exam_height+exam_weight+exam_hr+exam_rr+exam_rr+exam_sbp+exam_dbp+exam_temp+exam_o2sat+exam_o2satvalue+exam_mental+cx_rul+cx_rml+cx_rll+cx_lul+cx_lll+cx_cav+cx_pe,data=phnumo)

summary(phnumomodel)

#The first model yields an R^2 of 8.6%, which is very low. However, this could be due to extranious variables.
phnumomodel2<-lm(tcs_days~dem_age+exam_height+exam_weight+exam_rr+exam_sbp+exam_o2satvalue+exam_mental+cx_lul+cx_cav+cx_pe,data=phnumo)
summary(phnumomodel2)

#With the removal of the extranious variables, R^2 has actually decreased.

#It is clear that linear regression will not be effective in this model.

#Logistic Regression
PhnumoModelLogistic<-glm(early_late~dem_age+dem_sex+exam_height+exam_weight+exam_hr+exam_rr+exam_rr+exam_sbp+exam_dbp+exam_temp+exam_o2sat+exam_o2satvalue+exam_mental+cx_rul+cx_rml+cx_rll+cx_lul+cx_lll+cx_cav+cx_pe,data=phnumo,family=binomial)

summary(PhnumoModelLogistic)

#After removing extraneous variables

PhnumoModelLogistic2<-glm(early_late~dem_age+exam_height+exam_weight+exam_hr+exam_rr+exam_sbp+exam_o2satvalue+exam_mental+cx_lul+cx_cav+cx_pe, data=phnumo, family=binomial)

summary(PhnumoModelLogistic2)

#calculating R^2 for the model using the McFadden approximation
with(summary(PhnumoModelLogistic),1-(deviance/null.deviance))

#The McFadden R^2 is .059, which is very low for the model and suggests a low amount of correlation of variables in the logistic model