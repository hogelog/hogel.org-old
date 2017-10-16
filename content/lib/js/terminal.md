---
layout: page
title: JavaScript terminal
breadpath: /lib/terminal.html
---

<div class="container-fluid">
  <div class="row-fluid">
    <div class="span2">
      <dl>
        <dt>Control+Space</dt>
        <dd>show completion</dd>
        <dt>Up</dt>
        <dd>previous expression</dd>
        <dt>Down</dt>
        <dd>next expression</dd>
      </dl>
    </div>
    <div class="span10">
      <div id="terminal" class="well" style="height: 200px; overflow: auto">
        <div class="line highlight"><b>JavaScript read eval print loop</b></div>
        <div id="inputline" class="line"><span>jstalk&gt; </span><input type="text" id="input" autocomplete="off"></input></div>
        <div id="suggest"></div>
      </div>
    </div>
</div>

<script type="text/javascript" src="terminal.js"></script>
<script type="text/javascript" src="suggest.js"></script>
<script type="text/javascript">
  window.onload = function() {
      window.term = new Terminal(window, "inputline", "input", "line", "suggest", "terminal");
  }
</script>
