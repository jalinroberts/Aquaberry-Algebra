## Library imports // test
import streamlit as st
import pandas as pd
import seaborn as sns
import 
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
    fig=sns.countplot(data=wine_list,x='color',color='blue')
    Color.pyplot(fig.get_figure())

with Quality:    
    Quality.write("Quality Distribution")
    fig2=sns.countplot(data=wine_list,x='quality',color='blue')
    Quality.pyplot(fig2.get_figure())

with Scatter:
    Scatter.write("Wine Scatter Plot")
    selected_variables = st.multiselect("Select Two Variables", list(wine_list.columns)[:-1], default=list(wine_list.columns[:2]))
    if len(selected_variables) >= 2:
        x_variable = selected_variables[0]
        y_variable = selected_variables[1]
        scatter_plot = sns.scatterplot(x=x_variable, y=y_variable, hue='color', data=wine_list)  # Added hue='color' to distinguish between red and white wines
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

