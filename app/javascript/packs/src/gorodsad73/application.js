import { jarallax, jarallaxElement } from 'jarallax'

document.addEventListener("DOMContentLoaded", () => {
  jarallax(document.querySelectorAll('.jarallax'), {
    speed: 0.2
  });
  jarallaxElement();
  jarallax(document.querySelectorAll("[data-jarallax-element]"));
})
