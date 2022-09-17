import { Controller } from "@hotwired/stimulus"
import * as bootstrap from 'bootstrap'

// Connects to data-controller="reminder-modal"
export default class extends Controller {

  static targets = ["reminderModal"]

  connect() {
    if (this.hasReminderModalTarget) {
      var myModal = new bootstrap.Modal(this.reminderModalTarget)
      myModal.show(this.reminderModalTarget)
    }
  }

  submitReminder(e) {
    if (e.detail.success) {
      this.hideReminderModalTarget()
    }
  }

  hideReminderModalTarget() {
    var myModal = bootstrap.Modal.getInstance(this.reminderModalTarget)
    myModal.hide()
  }

  deleteReminder(e) {
    var myModal = bootstrap.Modal.getInstance(this.reminderModalTarget)
    myModal.hide()
  }

}
