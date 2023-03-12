import { Controller } from "@hotwired/stimulus"

let timer = null;
export default class extends Controller {
  static targets = ["reset","next"]

  connect() {
    this._timer = null;
  }

  startGeneration(){
    timer = setInterval(() => {
      document.getElementById('next').click()

    }, 1000);

  }

  stopTimer() {

    console.log(timer);
    if (!timer) return;

    clearInterval(timer);
  }
}
