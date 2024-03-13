import { LightningElement, api, wire, track } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import twogz from "@salesforce/resourceUrl/twogz";
import Id from "@salesforce/user/Id";
import getLayoutFullName from "@salesforce/apex/LayoutHelper.getLayoutFullName";
import getWeatherData from "@salesforce/apex/WeatherService.getWeatherData";
import insertInLog from "@salesforce/apex/LogHelper.insertInLog";
import ACCOUNT_NAME_FIELD from "@salesforce/schema/Account.Name";

export default class Twogz extends LightningElement {
  @track currentDate;
  @track tomorrowDate;
  @track afterTomorrowDate;

  error;
  user_Id;
  layoutObject;
  layoutId;
  layoutFullName;
  twogzLogo = twogz;
  recordTest;
  today;
  tomorrow;
  afterTomorrow;
  city;
  todayTemp;
  today_condition_text;
  today_condition_icon;
  tomorrowMaxTemp;
  tomorrowMinTemp;
  tomorrow_condition_icon;
  afterTomorrowMaxTemp;
  afterTomorrowMinTemp;
  afterTomorrow_condition_icon;

  handleLoad(evt) {
    evt.preventDefault();
    this.layoutId = Object.keys(evt.detail.layoutUserStates)[0];
    this.layoutObject = Object.keys(evt.detail.layouts)[0];
    this.user_Id = Id;
    this.invokeApexMethods();
  }

  callWeatherApi() {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        getWeatherData({
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        }).then((result) => {
          this.weatherData = result;
          this.city = result.city;
          this.todayTemp = result.todayTemp;
          this.today_condition_text = result.today_condition_text;
          this.today_condition_icon = result.today_condition_icon;
          this.tomorrowMaxTemp = result.tomorrowMaxTemp;
          this.tomorrowMinTemp = result.tomorrowMinTemp;
          this.tomorrow_condition_icon = result.tomorrow_condition_icon;
          this.afterTomorrowMaxTemp = result.afterTomorrowMaxTemp;
          this.afterTomorrowMinTemp = result.afterTomorrowMinTemp;
          this.afterTomorrow_condition_icon =
            result.afterTomorrow_condition_icon;
        });
        console.log(
          "getCurrentPosition",
          position.coords.latitude,
          position.coords.longitude
        );
        //console.log("weatherData", this.weatherData);
      },
      (error) => {
        console.log(error);
      }
    );
  }

  connectedCallback() {
    console.log("connectedCallback");
    this.callWeatherApi();
    const today = new Date();
    this.currentDate = this.getDayName(today).substring(0, 3);

    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);
    this.tomorrowDate = this.getDayName(tomorrow).substring(0, 3);

    const afterTomorrow = new Date(today);
    afterTomorrow.setDate(today.getDate() + 2);
    this.afterTomorrowDate = this.getDayName(afterTomorrow).substring(0, 3);
  }
  getDayName(date) {
    const daysOfWeek = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    return daysOfWeek[date.getDay()];
  }

  async invokeApexMethods() {
    //console.log("Layout Id: " + this.layoutId);
    try {
      this.layoutFullName = await getLayoutFullName({
        layoutId: this.layoutId
      });
    } catch (error) {
      //console.error(error);
    } finally {
      console.log("Layout Name: " + this.layoutFullName);
      insertInLog({
        layoutFullName: this.layoutFullName,
        userId: this.user_Id,
        layoutObject: this.layoutObject
      })
        .then((result) => {
          if (result === "success") {
            console.log("Insert in log ", result);
          } else {
            //console.log("Layout Name not found");
          }
        })
        .catch((error) => {
          console.error(error);
        });
    }
  }

  @api recordId;
  @api objectApiName;
  @wire(getRecord, { recordId: "$recordId", fields: [ACCOUNT_NAME_FIELD] })
  record;
}
