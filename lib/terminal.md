---
layout: page
title: JavaScript terminal
---

<div id="terminal" class="well">
  <div class="line highlight"><b>JavaScript read eval print loop</b></div>
  <div id="inputline" class="line">jstalk&gt; <input type="text" id="input" autocomplete="off"></input></div>
  <div id="suggest"></div>
</div>

Control+Space
: show completion

Up
: previous expression

Down:
: next expression

<script type="text/javascript" src="terminal.js"></script>
<script type="text/javascript" src="suggest.js"></script>
<script type="text/javascript">
  window.onload = function() {
      window.term = new Terminal(window, "inputline", "input", "line", "suggest");
  }
</script>
