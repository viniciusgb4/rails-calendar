import {Controller} from "@hotwired/stimulus"
import * as bootstrap from "bootstrap";

// Connects to data-controller="color-menu"
export default class extends Controller {

    static values = {
        color: String
    }

    connect() {
        console.log("connect color-menu")
    }

    changeColor(event) {
        let color = event.params['color']
        let colorSelector = document.getElementById("color-selector")
        colorSelector.setAttribute('class', 'color-field background-' + color)
        let colorInput = document.getElementById("color-input")
        colorInput.value = color;
        let colorMenu = document.getElementById("color-menu")
        colorMenu.setAttribute('class', 'dropdown-menu p-1');
    }

}
