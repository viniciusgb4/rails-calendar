import {Controller} from "@hotwired/stimulus"
import * as bootstrap from "bootstrap";

// Connects to data-controller="calendar"
export default class extends Controller {

    connect() {
        this.setToday()
    }

    setToday() {
        let todayDate = new Date()
        let today = this._getCurrentDate(todayDate)
        let todayCell = document.getElementById(`cell-${today}`)
        if (todayCell) {
            let todaySpan = todayCell.getElementsByTagName("span")[0]
            todaySpan.classList.add("today")
            let year = this._getCookie("year")
            let month = this._getCookie("month")

            if (!(year && month)) {
                this._setCookie("year", todayDate.getFullYear())
                this._setCookie("month", todayDate.getMonth() + 1)
            }
        }
    }

    _getCurrentDate(date) {
        const offset = date.getTimezoneOffset()
        date = new Date(date.getTime() - (offset*60*1000))
        return date.toISOString().split('T')[0]
    }

    _setCookie(name,value,days) {
        var expires = "";
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days*24*60*60*1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + (value || "")  + expires + "; path=/";
    }

    _getCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }

    _eraseCookie(name) {
        document.cookie = name +'=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
    }

}
