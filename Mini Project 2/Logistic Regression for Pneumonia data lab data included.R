#Meant to include the phnumo_data_with_lab_data file in the choice
phnumo=read.csv(file=file.choose(),header=TRUE,sep=',')

phnumomodel=glm(early_late~dem_age+dem_sex+exam_height+exam_weight+exam_hr+exam_rr+exam_sbp+exam_dbp+exam_temp+exam_o2satvalue+exam_mental+cx_rul+cx_rml+cx_rll+cx_lul+cx_lll+cx_cav+cx_pe+lab_hematocrit+lab_hemoglobin+lab_wbc+lab_platelets+lab_na+lab_k+lab_creatinine+lab_glucose+lab_crp+lab_abg,data=phnumo,family=binomial)

summary(phnumomodel)

#Calculating R^2 for the model using the McFadden approximation
with(summary(phnumomodel),1-(deviance/null.deviance))

#R^2 returns as 6.8%. The total dataset which is made seems to have a small amount of correlation to predicting early or late tcs
