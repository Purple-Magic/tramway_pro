import { create } from '../../crud'

document.addEventListener("DOMContentLoaded", function() {
  function timeToString(time) {
    let diffInHrs = time / 3600000;
    let hh = Math.floor(diffInHrs);

    let diffInMin = (diffInHrs - hh) * 60;
    let mm = Math.floor(diffInMin);

    let diffInSec = (diffInMin - mm) * 60;
    let ss = Math.floor(diffInSec);

    let diffInMs = (diffInSec - ss) * 100;
    let ms = Math.floor(diffInMs);

    let formattedMM = mm.toString().padStart(2, "0");
    let formattedSS = ss.toString().padStart(2, "0");
    let formattedMS = ms.toString().padStart(2, "0");

    return `${formattedMM}:${formattedSS}:${formattedMS}`;
  }

  let startTime;
  let elapsedTime = 0;
  let timerInterval;

  function print(txt) {
    document.getElementById("display").innerHTML = txt;
  }

  function start() {
    startTime = Date.now() - elapsedTime;
    timerInterval = setInterval(function printTime() {
      elapsedTime = Date.now() - startTime;
      print(timeToString(elapsedTime));
    }, 10);
    showButton("PAUSE");
  }

  function pause() {
    clearInterval(timerInterval);
    showButton("PLAY");
  }
  
  const save = () => {
    create('hui')
  }

  function showButton(buttonKey) {
    const buttonToShow = buttonKey === "PLAY" ? playButton : pauseButton;
    const buttonToHide = buttonKey === "PLAY" ? pauseButton : playButton;
    buttonToShow.style.display = "block";
    buttonToHide.style.display = "none";
  }

  let playButton = document.getElementById("playButton");
  let pauseButton = document.getElementById("pauseButton");
  let buttonSave = document.getElementById("buttonSave");

  playButton.addEventListener("click", start);
  pauseButton.addEventListener("click", pause);
  buttonSave.addEventListener("click", save);
});
