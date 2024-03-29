import { create, update, index } from '../../crud'
import _ from 'underscore'

document.addEventListener("DOMContentLoaded", function() {
  function timeToString(time) {
    let diffInHrs = time / 3600000;
    let hh = Math.floor(diffInHrs);

    let diffInMin = (diffInHrs - hh) * 60;
    let mm = Math.floor(diffInMin);

    let diffInSec = (diffInMin - mm) * 60;
    let ss = Math.floor(diffInSec);

    let formattedHH = hh.toString().padStart(2, "0");
    let formattedMM = mm.toString().padStart(2, "0");
    let formattedSS = ss.toString().padStart(2, "0");

    return `${formattedHH}:${formattedMM}:${formattedSS}`;
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
    index('Podcast::Episode').then((response) => {
      const lastEpisodeId = _.first(response.data.data).id
      update('Podcast::Episode', lastEpisodeId, { montage_state: 'recording' })
    })
  }

  function pause() {
    clearInterval(timerInterval);
    showButton("PLAY");
  }
  
  const save = () => {
    const time = timeToString(elapsedTime)
    const episode_id = document.getElementById('episodeId').value
    create('Podcast::Highlight', { time, episode_id })
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

  if (playButton) {
    playButton.addEventListener("click", start);
    pauseButton.addEventListener("click", pause);
    buttonSave.addEventListener("click", save);
  }
});
