import { jarallax, jarallaxElement } from 'jarallax'

document.addEventListener("DOMContentLoaded", () => {
  jarallax(document.querySelectorAll('.jarallax'), {
    speed: 0.5
  });
  jarallaxElement();
  jarallax(document.querySelectorAll("[data-jarallax-element]"));
})
