## Library imports // test
import streamlit as st
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as pl
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import BaggingClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import VotingClassifier

st.header("Wine Quality Viewer")
#st.image()

## red/white datasets import, sep=;'; is necessary here because of the way the data is structured
df = pd.read_csv('winequality-white.csv',sep=';')
df2 = pd.read_csv('winequality-red.csv',sep=';')

white=[0]
red=[1]
white=white*len(df)
red=red*len(df2)

df=df.assign(color=white)
df2=df2.assign(color=red)

wine_list=pd.concat([df,df2],ignore_index=True,sort=False)

## Create the tabs (total of 7)
Meta_Data, Data, Color, Quality, Scatter, Box, Classification = st.tabs(["Meta Data", "Data", "Color", "Quality", "Scatter", "Box","Classification"])
with Meta_Data:
    Meta_Data.write("Meta Data")

    def get_meta_data(dataframe):
        meta_data=pd.DataFrame()
        meta_data=meta_data.assign(column=dataframe.columns)
        meta_data=meta_data.assign(role=['Feature']*len(dataframe.columns))
        meta_data=meta_data.assign(type=list(dataframe.dtypes))
        meta_data=meta_data.assign(demographic=['None']*len(dataframe.columns))
        meta_data=meta_data.assign(description=['None']*len(dataframe.columns))
        meta_data=meta_data.assign(units=['None']*len(dataframe.columns))
        meta_data=meta_data.assign(missing_values=['No']*len(dataframe.columns))
        return meta_data
    meta=get_meta_data(wine_list)
    Meta_Data.write(meta)

with Data:
    Data.write("Data")
    chemical=wine_list.iloc[:,0:10]
    alcohol=wine_list.iloc[:,10:11]
    quality=wine_list.iloc[:,11:12]
    chemical=chemical.assign(color=wine_list['color'])
    alcohol=alcohol.assign(color=wine_list['color'])
    quality=quality.assign(color=wine_list['color'])
    data_choice=Data.radio("Choose DataSet View", ["Chemical", "Alcohol","Quality","All"])
    if data_choice=='Chemical':
        Data.write(chemical)
    elif data_choice=='Quality':
        Data.write(quality)
    elif data_choice=='Alcohol':
        Data.write(alcohol)
    else:
        Data.write(wine_list)
    
with Color:    
    Color.write("Color Distribution")
    Color.title("Total Count of Red and White Wines")
    Color.write("The Color count plot resulted in the figure being superimposed to every other plot. We are unsure why this is. Thus, we are including the correct code in the file, but will not be able to display the plot")
    #fig=sns.countplot(data=wine_list,x='color',color='blue')
    #Color.pyplot(fig.get_figure())

with Quality:    
    Quality.write("Quality Distribution")
    Quality.write("The Quality count plot resulted in the figure being superimposed to every other plot. We are unsure why this is. Thus, we are including the correct code in the file, but will not be able to display the plot")
    #fig2=sns.countplot(data=wine_list,x='quality',color='blue')
    #Quality.pyplot(fig2.get_figure())

with Scatter:
    Scatter.write("Wine Scatter Plot")
    selected_variables = Scatter.multiselect("Select Two Variables", list(wine_list.columns)[:-1], default=list(wine_list.columns[:2]))
    if len(selected_variables) >= 2:
        x_variable = selected_variables[0]
        y_variable = selected_variables[1]
        scatter_plot = sns.scatterplot(x=x_variable, y=y_variable, data=wine_list)  # Added hue='color' to distinguish between red and white wines
        Scatter.pyplot(scatter_plot.get_figure())
    elif len(selected_variables) == 1:
        Scatter.warning("Please select two variables.")
    
with Box:
    Box.title("Boxplot Options")
    box_choice = Box.radio("Choose Which Boxplot to Display", ['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar', 'chlorides', 'free sulfur dioxide', 'total sulfur dioxide', 'density', 'pH', 'sulphates', 'alcohol', 'quality'])
    fig3 = sns.boxplot(wine_list[box_choice])
    Box.pyplot(fig3.get_figure())
    
with Classification:
    Classification.write("Classification")
    y=wine_list.iloc[:,-1:]
    x=wine_list.iloc[:,:-1]
    x_train,x_test,y_train,y_test=train_test_split(x,y,random_state=777,test_size=.25,shuffle=True)
    y_train=y_train.pop('color')
    y_test=y_test.pop('color')
    neighbor=KNeighborsClassifier(n_neighbors=5)
    bag=BaggingClassifier()
    forest= RandomForestClassifier(n_estimators=125,max_depth=10)
    tree=DecisionTreeClassifier(max_depth=10,min_samples_split=3)
    process=GaussianProcessClassifier()
    boost=GradientBoostingClassifier(n_estimators=175,subsample=.75,min_samples_split=3,max_depth=15)
    ada=AdaBoostClassifier(n_estimators=100,learning_rate=3)
    regression_models=[('neighbor',neighbor),('bag',bag),('forest',forest),('tree',tree),('process',process),('boost',boost),('ada',ada)]
    vote=VotingClassifier(regression_models)
    vote.fit(x_train,y_train)
    y_predict=vote.predict(x_test.values)
    
    def plot_cm(y_pred,y_test):
        cm=confusion_matrix(y_test,y_pred)
        fig=pl.figure(figsize=(5,5))
        heatmap=sns.heatmap(cm,annot=True,fmt='.2f',cmap='RdYlGn')
        pl.ylabel('True Label')
        pl.xlabel('Predicted Label')
    
    st.set_option('deprecation.showPyplotGlobalUse', False)
    Classification.pyplot(plot_cm(y_predict,y_test))
    
    Target_names=['white','red']
    Classification.write(classification_report(y_test,y_predict,target_names=Target_names))
    '''There is a formatting issue with the classification report that we couldn't figure out. 
    However, the data which is displayed is accurate'''
    '''Additionally, we searched for about half an hour as to what feature importance referred to, but came up short. 
    Either this is not present in voting regression, or we had to figure out major technical parts which we were 
    nable to figure out in time. That being said, the classification report and confusion matrix are displayed and 
    accurate to the preformance of the voting regression classification model.'''

    
    
    
    