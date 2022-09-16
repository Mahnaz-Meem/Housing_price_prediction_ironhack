import streamlit as st
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
import pickle
from PIL import Image
#--------------------------------------------------------#

# Page layout
## Page expands to full width
st.set_page_config( page_title = "House Price Detector", layout='wide')
st.header('House Price Predictor')
st.title('Would you like to buy/sell a house?')

#--------------------------------------------------------#

st.markdown('_Whether to buy or sell knowing the house price for a particular area helps a lot! The buyer can get an estimation of house price not to lose money while buying. And the sellers can calculate the price and their profit margin according to different parameters._')

def user_info():

	st.markdown('**Please input your preferred house details**')
	st.markdown('**a) Bedrooms**')
	bedrooms = st.selectbox("Please enter the number of bedrooms: ",[1,2,3,4,5,6,7,8,9,10], key='1')
	st.write("You chose: ", bedrooms)
	st.markdown('**b) Bathrooms**')
	bathrooms = st.selectbox("Please enter the number of bathrooms: ",[1,2,3,4,5], key='2')
	st.write("You chose: ", bathrooms)
	st.markdown('**c) Living space**')
	sqft_living = st.slider("Please enter the living surface in square feet: ",
					min_value= 0, max_value=10000, step=100, key='3')
	st.write("You chose: ", sqft_living)
	st.markdown('**d) Land space**')
	sqft_lot = st.number_input("Please enter the land surface in square feet: ", key='4')
	st.write("You wrote: ", sqft_lot)
	st.markdown('**e) Floors**')
	floors = st.selectbox("Please enter the number of floors: ",[1,2,3,4], key='5')
	st.write("You chose: ", floors)
	st.markdown('**f) waterfront**')
	waterfront = st.radio("Do you want to have a waterfront?: ", ["Yes", "No"], key='6')
	st.write("You chose: ", waterfront)
	st.markdown('**g) View**')
	view = st.selectbox("Please enter the number from 0-4: ",[0,1,2,3,4], key='7')
	st.write("You chose: ", view)
	st.write("This means how good the view of the property is.")
	st.markdown('**h) Condition**')
	condition = st.selectbox("Please enter the number from 1-5: ",[1,2,3,4,5], key='8')
	st.write("You chose: ", condition)
	st.write("This means how the condition of the property is.")
	st.markdown('**i) Grade**')
	grade = st.number_input("Please enter the number from 1-13: ", key='9')
	st.write("You chose: ", grade)
	st.write("Range: 1-3: building construction and design falls short.")
	st.write("Range: 4-10: building construction and design is average.")
	st.write("Range: 11-13: modern and high quality building construction and design.")
	st.markdown('**j) Above ground surface**')
	sqft_above=st.slider("Please enter the above ground surface in square feet: ", min_value= 0, max_value=10000, step=100, key='10')
	st.write("You chose: ", sqft_above)
	st.markdown('**k) Basement area**')
	sqft_basement=st.slider("Please enter the basement area in square feet: ", min_value= 0, max_value=5000, step=100, key='11')
	st.write("You chose: ", sqft_basement)
	st.markdown('**l) zipcode**')
	zipcode=st.slider("Please enter a valid zipcode for the Seattle city: ", min_value= 98000, max_value=98200, step=2, key='12')
	st.write("You chose: ", zipcode)
	st.markdown('**m) Latitude**')
	lat = st.slider("Please enter the latitude: ", min_value= 47.150, max_value= 47.778, step=0.001, key='13')
	st.write("You chose: ", lat)
	st.markdown('**n) Longitude**')
	lon = st.slider("Please enter the longitude: ", min_value= -122.50, max_value= -121.50, step=0.01, key='14')
	st.write("You chose: ", lon)
	st.markdown('**o) Average living space in the neighbourhood**')
	sqft_living15= st.slider("Please enter the average size of interior housing living of 15 closest houses : ", min_value= 0, max_value= 7000, step=100, key='15')
	st.write("You chose: ", sqft_living15)
	st.markdown('**p) Average land size in the neighbourhood**')
	sqft_lot15= st.slider("Please enter the average size of land of 15 closest houses : ", min_value= 500, max_value= 500000, step=100, key='16')
	st.write("You chose: ", sqft_lot)
	st.markdown('**q) House age**')
	house_age = st.number_input("How old is the house? : ", key='17')
	st.write("You chose: ", house_age)
	st.markdown('**r) Renovation**')
	yr_after_renovation = st.number_input("How long since the house was renovated? If never please input 0 : ", key='18')
	st.write("You chose: ", yr_after_renovation)

	user_data = {"bedrooms":[bedrooms],"bathrooms":[bathrooms], "sqft_living":[sqft_living], "sqft_lot":[sqft_lot], "floors": [floors], "waterfront": [waterfront], "view": [view], "condition": [condition], "grade": [grade], "sqft_above":[sqft_above], "sqft_basement":[sqft_basement],"zipcode":[zipcode],"lat":[lat], "long": [lon],"sqft_living15":[sqft_living15],"sqft_lot15":[sqft_lot15],"house_age": [house_age],"yr_after_renovation":[yr_after_renovation]}
	data_df = pd.DataFrame(user_data)
	st.markdown('_Great! Ready to see the price?_')
	return data_df

df = user_info()

button = st.button("Get the house price prediction")

if button:

	with open('../scalers/standard_scaler.pkl', "rb") as file:
		standard_scaler = pickle.load(file)

	with open('../models/RF_model.pkl', "rb") as file:
		best_model = pickle.load(file)

#pipe = Pipeline([('scaler', standard_scaler), ('model', best_model)])

	df['waterfront'] = df['waterfront'].apply(lambda x: 1 if (x == "Yes") else 0)
	df_scaled_np = standard_scaler.transform(df)
	df_scaled_df = pd.DataFrame(df_scaled_np, columns = df.columns)
	predicted_price = best_model.predict(df_scaled_df)

	st.success("The estimated price is ${:.2f}".format(np.exp(predicted_price[0])))
	image = Image.open('../visualization/wow.png')
	st.image(image, caption='Surprised?')

