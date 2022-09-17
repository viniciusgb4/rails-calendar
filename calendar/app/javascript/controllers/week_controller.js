import {Controller} from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="week"
export default class extends Controller {

    static values = {"weekid": String }
    static targets = ["week"]

    connect() {
        this.channel = consumer.subscriptions.create({
            channel: "WeekChannel",
            week_id: this.weekidValue}, {
            connected: this._cableConnected.bind(this),
            disconnected: this._cableDisconnected.bind(this),
            received: this._cableReceived.bind(this)
        });
    }

    disconnect() {
        this.channel.unsubscribe()
    }

    _cableConnected() {
    }

    _cableDisconnected() {
    }

    _cableReceived(data) {
        this.weekTarget.innerHTML = data.week_reminders
    }
}