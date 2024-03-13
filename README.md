# 2GezerAdvancedLogger

## Introduction

This app let you have a view on your account and opportunities layouts usage, and so, helps you to keep your organization clean.
In order to collect data, you juste have to drop our Lightning Web Component on your object page, have a few steps of setting and you are good to go.

## Setting

### Install the LWC component

1.Go to your account page >> SetUp >> Edit page

2.Drag & drop the $\color{green}{twogz}$ component from the left panel to the location you choose on the page >> Activate >> Save
<br/><br/>
The component provides you information about weather, now and forecast, depending of your localisation. 

<img width="944" alt="Screenshot 2023-10-26 120233" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/61454ddb-1ba6-49cb-aa71-5753244ae8c9" width=1%>

<br/><br/>
> **Note**
> If you choose to not let your browser know about your localisation, you can can configure the latitude and the longitude in the **Custom Setting**. 


### Create and set a connected app

By default, some fields that may be interesting (_Layoutfullname_ for example) are not accessible in REST Salesforce API. To have access to such fields and display it in our reports, an apex class included in the package, will be in charge to authenticate to your Salesforce Org, in order to use the tooling API.

1 Setup >> App Manager >> New connected app

- Populate the fields of **Basic information**
- Enable **Oauth Settings**
- Populate the **Callback URL** with the following : https://login.salesforce.com/services/oauth2/callback
  
2 Select **Oauth Scopes:**
  -_Full access_
  -_Manage user data via APIs_
  -_Manage user data Web_
  -_Perform requests at any time_

3 Check boxes *PKCE, Require Secret for Web Sever Flow, Require Secret for Refresh Token Flow, Enable Client Credentials Flow"*
<br/><br/>
<img width="500" alt="Screenshot 2023-10-26 144012" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/a209d6e4-ccbe-46ce-908d-56d5f369a678">
<br/><br/>
4 Save >> You are now informed that changes will get around 10mn to get effect >> Continue >> Manage Consumer Details
5 You are invited to verify You Identity. Once done; a window will is appearing with your app's *client_id* and  *client_secret*  >> Keep the credentials somhewhere, you will need it soon.
<br/><br/>
<img width="500" alt="image" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/026198dc-70ba-4894-af7f-ff7babd6ccf0">![Screenshot 2023-10-26 155015](https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/24b90986-738e-4633-9475-5eb6ce32a71e)
<br/><br/>
6 Set Up >> App Manager >> *YourApp* >> Manage >> Edit policies 
<br/><br/>
In **Client Credentials Flow Section**, you will have to set ab user than is *API enabled* and have a full permissions on *Twz_loc_c* object. 
<br/><br/>
<img width="500" alt="image" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/d27931f3-6e74-4a8f-9e7c-4b1e1bb1b498">
<br/><br/>

### Set the custom setting

A custom setting named *twogz_credential* is already provided in the package 
<br/><br/>
<img width="500" alt="image" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/257e059c-5c23-4090-89cf-0cea63c65bc5">

1 Click on **Twogs_credential** >> Manage >> Defaut Organization Level Value >> New
<br/><br/>
<img width="500" alt="image" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/578d3143-621e-49ea-986e-a37b631330f4">

Populate the fields *client_id* and *client_secret* respectivly with the *consumer key* and the *consumer secret* obtained earlier.

$${\color{red}ET \space \color{orange}VOILA}$$

> **Note**
> A weather API, and latitude and longitude are already set, in order for the app to be ready to use. Feel free to set your own values !

> **Warning**
> For security matters, it is recommended to change frequently the consumer and client keys.

## Usage
Two Reports, *Account/opportunities usage*  and one Dasboard are included in the package. Each time an user opens an Account or Opportunity detail, a new log is created. A the end of the day, it gives you a quick visual about the layouts that are used or not. 
<br/><br/>
<img width="600" alt="Screenshot 2023-10-26 162434" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/32991038-ceb0-4745-8243-64d0e4dc5ce3">
<br/><br/>
<img width="600" alt="image" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/102649ad-176c-43e1-8233-bd9dc106de17">

<img width="600" alt="image" src="https://github.com/2gezercorp/2GezerAdvancedLogger/assets/113261345/e1f34910-4630-4528-bd20-b14cfb39b86c">

















