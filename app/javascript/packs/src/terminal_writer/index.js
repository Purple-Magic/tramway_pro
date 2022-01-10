import { Terminal } from 'xterm'
let bashPrompt = '~:'
let term = new Terminal({ cols: 120, rows: 26, fontSize: '30' });
const typingTimeout = 100
const directives = ['input:', 'output:', 'audio:', 'delay:']
const newLine = '\n\r'
const delayRegex = /\%\{delay \d+\}/g;

const buildPrompt = () => {
  return `\x1B[36m${bashPrompt}\x1B[0m `
}

const typing = (command, typingTimeout) => {
  _.each(command, (ch, i) => {
    setTimeout(() => {
      if (ch === '\\') {
        switch(command[i + 1]) {
          case 'b': {
            console.log('hui')
            term.write("\b \b")
          }
          case ';': {
            term.write('\\')
          }
        }
      } else {
        if (command[i - 1] == '\\') {
          if (ch === ';') {
            term.write(ch)
          }
        } else {
          term.write(ch)
        }
      }
    }, typingTimeout * i)
  })
}

const runPastePart = (data, index) => {
  const part = data[index]
  let timeoutBeforeTheNext;
  if (part) {
    switch(part.type) {
      case 'insert': {
        term.write(part.data)
        timeoutBeforeTheNext = 100
        break
      }
      case 'delay': {
        timeoutBeforeTheNext = part.data
      }
    }
  }
  setTimeout(() => {
    runPastePart(data, index + 1)
  }, timeoutBeforeTheNext)
}

const runPaste = (data, actions, index) => {
  let overallTimeout = 0
  _.each(data, (part) => {
    switch(part.type) {
      case 'insert': {
        overallTimeout += 100
        break
      }
      case 'delay': {
        overallTimeout += part.data
        break
      }
    }
  })

  setTimeout(() => {
    term.write('\n\r');
    runAction(actions, index + 1)
  }, overallTimeout)

  term.write(bashPrompt())
  runPastePart(data, 0)
}

const runInputPart = (data, index) => {
  const part = data[index]
  let timeoutBeforeTheNext;
  if (part) {
    switch(part.type) {
      case 'typing': {
        typing(part.data, typingTimeout)
        timeoutBeforeTheNext = part.data.length * typingTimeout
        break
      }
      case 'delay': {
        timeoutBeforeTheNext = part.data
      }
    }
  }
  setTimeout(() => {
    runInputPart(data, index + 1)
  }, timeoutBeforeTheNext)
}

const runInput = (data, actions, index) => {
  let overallTimeout = 0
  _.each(data, (part) => {
    switch(part.type) {
      case 'typing': {
        overallTimeout += (part.data.length + 1) * typingTimeout
        break
      }
      case 'delay': {
        overallTimeout += part.data
        break
      }
    }
  })

  setTimeout(() => {
    term.write('\n\r');
    runAction(actions, index + 1)
    console.log(`Input ends at ${time}`)
  }, overallTimeout)

  term.write(buildPrompt())
  runInputPart(data, 0)
}

const showPart = (output, index) => {
  const part = output[index]
  let timeoutBeforeTheNext = 0;
  if (part) {
    switch(part.type) {
      case 'text': {
        const nextPart = output[index + 1] 
        if (index != output.length - 1) {
          if (nextPart && ['colorBegin', 'colorEnd', 'delay'].includes(nextPart.type)) {
            term.write(part.data)
          } else {
            term.write(part.data + newLine)
          }
        }
        break
      }
      case 'colorBegin': {
        term.write(`\x1B[0;${part.data.textColor}\x1B[${part.data.backgroundColor}`)
        break
      }
      case 'colorEnd': {
        term.write('\x1B[0m')
        break
      }
      case 'delay': {
        timeoutBeforeTheNext = part.data
        break
      }
    }
  }
  setTimeout(() => {
    showPart(output, index + 1)
  }, timeoutBeforeTheNext)
}

const showOutput = (output, actions, index) => {
  let overallTimeout = 0
  _.each(output, (part) => {
    switch(part.type) {
      case 'delay': {
        overallTimeout += part.data
        break
      }
    }
  })
  setTimeout(() => {
    runAction(actions, index + 1)
    console.log(`Output ends at ${time}`)
  }, overallTimeout)
  setTimeout(() => {
    showPart(output, 0)
  }, 100)
}

const delay = (milliseconds, actions, index) => {
  setTimeout(() => {
    runAction(actions, index + 1)
    console.log(`Delay ends at ${time}`)
  }, milliseconds)
}

const clear = (actions, index) => {
  term.clear()
  setTimeout(() => {
    runAction(actions, index + 1)
    console.log(`Clear ends at ${time}`)
  }, 100)
}

const changePrompt = (prompt, actions, index) => {
  bashPrompt = prompt
  setTimeout(() => {
    runAction(actions, index + 1)
    console.log(`Change Prompt ends at ${time}`)
  }, 100)
}

const scrollLines = (data, actions, index) => {
  const count = parseInt(data)
  _.times(Math.abs(data), (i) => {
    setTimeout(() => {
      if (data > 0) {
        term.scrollLines(1)
      } else {
        term.scrollLines(-1)
      }
    }, 10 * i)
  })
  setTimeout(() => {
    runAction(actions, index + 1)
    console.log(`Scroll Lines ends at ${time}`)
  }, 100)
}

const runAction = (actions, index) => {
  const action = actions[index]
  if (action) {
    switch(action.action) {
      case 'input': {
        runInput(action.data, actions, index)
        break
      }
      case 'output': {
        showOutput(action.data, actions, index)
        break
      }
      case 'delay': {
        delay(action.data, actions, index)
        break
      }
      case 'clear': {
        clear(actions, index)
        break
      }
      case 'paste': {
        runPaste(action.data, actions, index)
        break
      }
      case 'prompt': {
        changePrompt(action.data, actions, index)
        break
      }
      case 'scroll_lines': {
        scrollLines(action.data, actions, index)
        break
      }
    }
  }
}

let time;

const runTimer = () => {
  const timer = document.getElementById('timer')
  setInterval(() => {
    time = parseInt(timer.innerHTML)
    timer.innerHTML = time + 1
  }, 1000)
}

const runScenario = (actions) => {
  runTimer()
  runAction(actions, 0)
}

const parsePaste = (line) => {
  const action = {
    action: 'paste', 
  }
  let data
  if (line.match(delayRegex)) {
    const millisecondsRegex = /\d+/
    const mil = parseInt(line.match(delayRegex)[0].match(millisecondsRegex)[0])
    data = [
      { type: 'insert', data: line.split(delayRegex)[0] },
      { type: 'delay', data: mil },
      { type: 'insert', data: line.split(delayRegex)[1] },
    ]
  } else {
    data = [{ type: 'insert', data: line }]
  }
  return { ...action, data }
}

const parseInput = (line) => {
  const action = {
    action: 'input', 
  }
  let data = []
  if (line.match(delayRegex)) {
    const millisecondsRegex = /\d+/
    const delays = line.match(delayRegex)
    const parts = line.split(delayRegex)
    _.each(parts, (part, i) => {
      data.push({ type: 'typing', data: part })
      if (delays.length >= (i + 1)) {
        const mil = parseInt(delays[i].match(millisecondsRegex)[0])
        data.push({ type: 'delay', data: mil })
      }
    })
  } else {
    data = [{ type: 'typing', data: line }]
  }
  return { ...action, data }
}

const parseOutput = (lines, index) => {
  const action = {
    action: 'output'
  }
  var data = []
  for (var j = index + 1; j < lines.length; j++) {
    const line = lines[j]
    if (!directives.includes(line)) {
      const beginRegex = /\%\{begin:\d+m;\d+m}/
      const endRegex = /\%\{end:\d+m;\d+m}/
      const colorRegex = /\%\{begin:\d+m;\d+m\}.*\%\{end:\d+m;\d+m\}/
      if (line.match(colorRegex)) {
        const colorCodeRegex = /\d+\m/g
        const backgroundColor = line.match(colorRegex)[0].match(colorCodeRegex)[0]
        const textColor = line.match(colorRegex)[0].match(colorCodeRegex)[1]
        data.push({ type: 'text', data: line.split(beginRegex)[0] })
        data.push({ type: 'colorBegin', data: { backgroundColor, textColor } })
        data.push({ type: 'text', data: line.split(beginRegex)[1].split(endRegex)[0] })
        data.push({ type: 'colorEnd', data: { backgroundColor, textColor } })
        data.push({ type: 'text', data: line.split(endRegex)[1] })
      } else if (line.match(delayRegex)) {
        const millisecondsRegex = /\d+/
        const delays = line.match(delayRegex)
        const parts = line.split(delayRegex)
        _.each(parts, (part, i) => {
          data.push({ type: 'text', data: part })
          if (delays.length >= (i + 1)) {
            const mil = parseInt(delays[i].match(millisecondsRegex)[0])
            data.push({ type: 'delay', data: mil })
          }
        })
      } else {
        data.push({ type: 'text', data: line })
      }
    } else {
      break
    }
  }
  return { ...action, data }
}

const readSingleFile = (e) => {
  var file = e.target.files[0];
  if (!file) {
    return;
  }
  var reader = new FileReader();
  reader.onload = function(e) {
    var contents = e.target.result;
    var lines = contents.split("\n")
    let actions = []
    for (var i = 0; i < lines.length; i++) {
      if (lines[i] == 'input:') {
        actions.push(parseInput(lines[i + 1]))
        i++
      }
      if (lines[i] == 'output:') {
        actions.push(parseOutput(lines, i))
      }
      if (lines[i] == 'audio:') {
        const audio = document.createElement('audio')
        audio.autoplay = true
        const source = document.createElement('source')
        source.src = `./scenarios/${lines[i + 1]}`
        audio.appendChild(source)
        const body = document.getElementById('body')
        body.appendChild(audio)
      }
      if (lines[i] == 'delay:') {
        actions.push({ action: 'delay', data: parseInt(lines[i + 1]) })
      }
      if (lines[i] == 'clear:') {
        actions.push({ action: 'clear' })
      }
      if (lines[i] == 'paste:') {
        actions.push(parsePaste(lines[i + 1]))
        i++ 
      }
      if (lines[i] == 'prompt:') {
        actions.push({ action: 'prompt', data: lines[i + 1] })
        i++
      }
      if (lines[i] == 'scroll_lines:') {
        actions.push({ action: 'scroll_lines', data: lines[i + 1] })
        i++
      }
    }
    console.log(actions)

    runScenario(actions) 
  };
  reader.readAsText(file);
}

const pressEnter = () => {
  term.write('\n');
  setTimeout(() => {
    term.write(buildPrompt())
  }, 50)
}

window.addEventListener('load', () => {
  term.open(document.getElementById('terminal'));
  term.onKey((key, ev) => {
    if (key.domEvent.key == 'Enter') {
      pressEnter()
    }
    if (key.domEvent.key == 'Backspace') {
      term.write('\b');
    }
    term.write(key.key);
  });
})
