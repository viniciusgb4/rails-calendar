import {Controller} from "@hotwired/stimulus"
import * as bootstrap from "bootstrap";

// Connects to data-controller="reminder"
export default class extends Controller {

    static values = {
        timeout: Number
    }

    connect() {
        // call the _addShowMore when the page is loaded to treat
        // reminders overflow
        this._addShowMore(this)
    }

    /*
    * Adds a delay before another function (func parameter) call.
    *
     */
    _debounce(ctx, func, wait, immediate) {
        return function () {
            var context = this, args = arguments;
            var later = function () {
                ctx.timeoutValue = null;
                if (!immediate) func.apply(context, args);
            };
            var callNow = immediate && !timeout;
            clearTimeout(ctx.timeoutValue);
            ctx.timeoutValue = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    };

    /*
    * This function adds a delay before calling the _addShowMore(ctx) function.
    * This delay is needed to prevent excessive calls after a window resize
     */
    addShowMore() {
        let fcall = this._debounce(this, function (ctx, f) {
            f(ctx)
        }, 100);
        fcall(this, this._addShowMore)
    }

    /*
    * This function is responsible for treating reminders overflow. When a day cell
    * does not fit all reminders, this function adds a show more element with a list
    * of the reminders that are not fitting in the cell. When user clicks in the show
    * more element, a popover with the reminders is opened.
     */
    _addShowMore(ctx) {
        let rect = ctx.element.getBoundingClientRect();
        let tr_reminders = ctx.element.children

        if (tr_reminders.length > 0) {
            if (tr_reminders[tr_reminders.length - 1].getAttribute("show-more")) {
                tr_reminders[tr_reminders.length - 1].remove()
            }
        }
        let last_shown_element = null
        let hidden_elements = {}
        let need_show_more = false

        for (let i = 0; i < tr_reminders.length; i++) {
            let tr_reminder = tr_reminders[i]
            tr_reminder.hidden = false

            let crect = tr_reminder.getBoundingClientRect()
            let tds = tr_reminder.getElementsByTagName("td")

            if (crect.bottom <= rect.bottom) {
                tr_reminder.hidden = false
                last_shown_element = tr_reminder
            } else {
                ctx._organize_hidden_elements(tds, hidden_elements);
                tr_reminder.hidden = true
                need_show_more = true
            }
        }

        const tr = document.createElement("tr")

        if (need_show_more) {
            let tds = last_shown_element.getElementsByTagName("td")
            ctx._organize_hidden_elements(tds, hidden_elements);
            last_shown_element.hidden = true
            ctx.element.appendChild(tr)
        }

        for (let i = 0; i < Object.keys(hidden_elements).length; i++) {
            let hidden_elements_by_column_count = hidden_elements[i].length
            if (hidden_elements_by_column_count > 0 && last_shown_element) {
                const td = document.createElement("td")
                td.setAttribute('class', "calendar-column reminder-column p-0 m-0 show-more")
                td.setAttribute('overflow', "hidden")
                tr.appendChild(td);
                tr.setAttribute("show-more", "show_more")
                let aTag = document.createElement('a')
                aTag.setAttribute('role',"button")
                aTag.setAttribute('tabindex',"0")
                aTag.setAttribute('data-bs-trigger',"focus")
                aTag.setAttribute('data-bs-toggle', "popover")
                aTag.setAttribute('data-bs-html', 'true')
                aTag.setAttribute('data-bs-content', ctx._createRemindersList(hidden_elements[i]))
                aTag.setAttribute("class", "show-more__link")
                let divTag = document.createElement('div');
                divTag.setAttribute('class', 'day-reminder text-start mb-1 p-0 m-0')
                aTag.innerText = hidden_elements_by_column_count
                new bootstrap.Popover(aTag, {sanitizeFn: function (content) {
                        return content
                }})
                divTag.appendChild(aTag)
                td.appendChild(divTag);
            } else {
                const td = document.createElement("td")
                td.setAttribute('class', "calendar-column reminder-column p-0 m-0")
                tr.appendChild(td);
            }
        }
    }

    /*
    * Organizes all hidden reminders in the *hidden_elements* hash parameter.
    * The *hidden_elements* has a key for each week day pointing to an array.
    * This function gets the array of a week day and adds it it all hidden reminders
    * of that day.
     */
    _organize_hidden_elements(tds, hidden_elements) {
        let col = 0

        for (let j = 0; j < tds.length; j++) {
            if (!hidden_elements[col]) {
                hidden_elements[col] = []
            }
            let td_content = tds[j].children
            let colspan = tds[j].getAttribute('colspan')
            if (td_content.length) {
                hidden_elements[col].push(td_content)
            }
            col++
            if (colspan > 0) {
                colspan = Number(colspan)
                for (let ntd = 1; ntd < colspan; ntd++) {
                    if (!hidden_elements[col]) {
                        hidden_elements[col] = []
                    }
                    if (td_content.length) {
                        hidden_elements[col].push(td_content)
                    }
                    col++
                }
            }
        }
    }

    /*
    * Creates the list of hidden reminders to show in the popover
     */
    _createRemindersList(hidden_tds) {
        const div = document.createElement('div');
        hidden_tds.forEach((reminder) => {
            if (reminder.length) {
                let reminder_clone = reminder[0].cloneNode(true)
                let aReminder = reminder_clone.children[0]
                aReminder.removeAttribute("style")
                div.prepend(reminder_clone)
            }
        })
        return div.outerHTML
    }

}
