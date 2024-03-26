rent<-read.table(file=file.choose(),header=TRUE,sep=',')
rentmodel<-lm(Payment~Rentals,data=rent)
summary(rentmodel)

#The rent model presents an R^2 value of .9993, meaning that roughly 99.93% of 
#the variation in the total payment made by a country is explained by the 
#variation in the number of rentals. The rentals variable yields a p-value of
#2*10^-16, which is low enough to reject the null hypothesis and conclude that 
#the total rental payment of a country is dependent on the total number of 
#rentals made by citizens of the given countries.