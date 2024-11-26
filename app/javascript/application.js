// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import Rails from "@rails/ujs";
Rails.start();
document.addEventListener("DOMContentLoaded", () => {
  const flashMessages = document.querySelectorAll("#flash-messages .flash");
  if (flashMessages) {
    setTimeout(() => {
      flashMessages.forEach(msg => msg.remove());
    }, 3000);
  }
});
