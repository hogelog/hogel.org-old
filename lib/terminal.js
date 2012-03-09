// require: suggest.js

// for IE
function findInList(list, x) {
  for (var i=0,len=this.length;i<len;++i) {
    if (this[i] === x) {
      return true;
    }
  }
  return false;
}

//if (Terminal) {
//  var Terminal = {};
//}
//Terminal.prototype = {
//initialize: function(win, insertBeforeId, inputId, lineClass, suggestId){
//  
//}
//};
var Terminal = function(win, insertBeforeId, inputId, lineClass, suggestId) {
  var self = this;
  self.win = win;
  self.doc = win.document;
  self.insertBefore = self.doc.getElementById(insertBeforeId);
  self.input = self.doc.getElementById(inputId);
  self.lineClass = lineClass;
  self.history = {log: [], num:0};

  self.reservedWords = [
    // 'debugger', 'double', 'enum', 'export', 'extends', 'final',
    // 'finally','float', 'goto', 'implements', 'import', 'interface',
    // 'int',  'label', 'long', 'native', 'package', 'private',
    // 'protected', 'public', 'short', 'static', 'super', 'synchronized',
    // 'throws', 'transient', 'volatile',
    'continue', 'default', 'delete', 'do', 'else', 'false', 'for',
    'function', 'if', 'in', 'instanceof', 'new', 'null', 'return',
    'switch', 'this', 'throw', 'true', 'try', 'typeof', 'var', 'void',
    'while', 'with'
  ];
  self.globalObjects = [
    'NaN', 'Infinity', 'undefined',
    'eval', 'parseInt', 'parseFloat', 'isNaN', 'isFinite', 
    'decodeURI', 'decodeURIComponent', 'encodeURI', 'encodeURIComponent', 
    'Array', 'Boolean', 'Date', 'Function', 'JSON', 'Math', 
    'Number', 'Object', 'RegExp', 'String',
    'Error', 'EvalError', 'RangeError', 'ReferenceError', 'SyntaxError',
    'TypeError', 'URIError'
  ];
  self.builtinPrototypes = [
    [Object, ['prototype', 'constructor', 'toString', 'toLocaleString',
      'valueOf', 'hasOwnProperty', 'isPrototypeOf', 'propertyIsEnumerable']],
    [Function, ['apply', 'call', 'length']], 
    [Array, ['concat', 'join', 'pop', 'push', 'reverse', 'shift', 'slice',
      'sort', 'splice', 'unshift', 'length']],
    [String, ['charAt', 'charCodeAt', 'concat', 'indexOf',
      'lastIndexOf', 'localeCompare', 'match', 'replace', 'search', 'slice',
      'split', 'substring', 'toLowerCase', 'toLocaleLowerCase', 'toUpperCase',
      'toLocaleUpperCase', 'length']],
    [Number, ['toFixed', 'toExponential', 'toPrecision']],
    [Date, ['toDateString', 'toTimeString', 'toLocaleDateString',
      'toLocaleTimeString', 'getTime', 'getFullYear', 'getUTCFullYear',
      'getMonth', 'getUTCMonth', 'getDate', 'getUTCDate', 'getDay',
      'getUTCDay', 'getHours', 'getUTCHours', 'getMinutes', 'getUTCMinutes',
      'getSeconds', 'getUTCSeconds', 'getMilliseconds', 'getUTCMilliseconds',
      'getTimezoneOffset', 'setTime', 'setMilliseconds', 'setUTCMilliseconds',
      'setSeconds', 'setMinutes', 'setHours', 'setDate', 'setMonth',
      'setFullYear', 'setUTCSeconds', 'setUTCMinutes', 'setUTCHours',
      'setUTCDate', 'setUTCMonth', 'setUTCFullYear', 'toUTCString']],
    [RegExp, ['exec', 'test', 'source', 'global', 'ignoreCase', 'multiline', 'lastIndex',]],
    [Error, ['message', 'name']]
  ];
  self.builtinObjects = [
    [String, ['fromCharCode']],
    [Number, ['MAX_VALUE', 'MIN_VALUE', 'NaN', 'NEGATIVE_INFINITY', 'POSITIVE_INFINITY']],
    [Math, ['E', 'LN10', 'LN2', 'LOG2E', 'LOG10E', 'PI', 'SQRT1_2', 'SQRT2', 'abs', 'acos', 'asin', 'atan', 'atan2', 'celi', 'cos', 'exp', 'floor', 'log', 'max', 'min',  'pow', 'random', 'round', 'sin', 'sqrt', 'tan']],
    [Date, ['parse', 'UTC']],
    [JSON, ['parse', 'stringify'],]
  ];
  self.globalCandidates = self.globalObjects.concat(self.reservedWords);

  self.evalPrint = function(expr) {
    self.print('jstalk> ' + expr, " muted");
    self.addHistory(expr);
    try {
      var result = eval(expr);
      self.print(result, " muted");
      self.initInputLine();
      return result;
    } catch (e) {
      self.print(e.toLocaleString(), " error");
      self.initInputLine();
      return e;
    }
  };
  
  self.createLine = function(klass) {
    var line = self.doc.createElement("div");
    line.className = self.lineClass;
    if (klass) {
      line.className += klass;
    }
    return line;
  };
  self.print = function(html, klass) {
    var line = self.createLine(klass);
    line.appendChild(self.doc.createTextNode(html));
    self.insertBefore.parentNode.insertBefore(line, self.insertBefore);
  };
  self.addHistory = function(expr) {
    self.history.log.push(expr);
    self.history.num = self.history.log.length;
  };
  self.initInputLine = function() {
    self.win.scrollTo(0, self.insertBefore.offsetTop);
    self.input.value = "";
    self.input.focus();
  }
  self.input.onkeydown = function(e) {
    var ev = (e ? e : event);
    var keycode = ev.keyCode;
    if (self.SPKey[keycode]) {
      self.SPKey[keycode](ev);
    }
  };


  self.initInputLine();

  self.addHashkeyProperties = function(list, obj, prefix) {
    for (var key in obj) {
      var name = prefix + key;
      if (String(Number(key)) !== key && !findInList(list, name)) {
        list.push(name);
      }
    }
    return list;
  };
  self.addPrototypeProperties = function(list, obj, prefix) {
    function addProperties(list, props, prefix) {
      for (var i=0, len=props.length;i<len;++i) {
        var name = prefix + props[i];
        if (!findInList(list, name)) {
          list.push(name);
        }
      }
    }
    var objects = self.builtinObjects;;
    for (var i=0, len=objects.length;i<len;++i) {
      if (obj === objects[i][0]) {
        addProperties(list, objects[i][1], prefix);
        break;
      }
    }
    var prototypes = self.builtinPrototypes;
    for (var i=0, len=prototypes.length;i<len;++i) {
      var constructor = prototypes[i][0];
      if (obj instanceof constructor || obj === constructor.prototype) {
        addProperties(list, prototypes[i][1], prefix);
      }
    }
    if (typeof obj == "string") {
      addProperties(list, prototypes[3][1], prefix);
    }
    return list;
  };
  self.addProperties = function(list, obj, prefix) {
    self.addHashkeyProperties(list, obj, prefix);
    self.addPrototypeProperties(list, obj, prefix);
    return list;
  };
  var objRefRegExp = /(.+)\.[^.]*$/;
  self.newSuggestions = function(text) {
    if (objRefRegExp.test(text)) {
      var objname = RegExp.$1;
      try {
        var obj = eval(objname);
        self.suggest.candidateList = self.addProperties([], obj, objname+".");
      } catch (e) {
      }
    } else {
      var candidates = self.addProperties([], self.win, "");
      self.suggest.candidateList = candidates.concat(self.globalCandidates.slice(0));
    }
  };
  self.existsSuggest = function() {
    return self.suggest.suggestList && self.suggest.suggestList.length != 0;
  };

  self.keyReturn = function(ev) {
    self.suggest._stopEvent(ev);
    if (self.existsSuggest()) {
      self.suggest.keyEventReturn();
    } else if (self.input.value.length > 0) {
      return self.evalPrint(self.input.value);
    }
  };
  self.keySpace = function(ev) {
    if (ev.ctrlKey) {
      self.suggest._stopEvent(ev);
      var text = self.suggest.getInputText();
      //self.suggest.search();
      self.suggest.clearSuggestArea();

      var text = self.suggest.getInputText();

      self.newSuggestions(text);
      var resultList = self.suggest._search(text);
      if (resultList.length != 0) self.suggest.createSuggestArea(resultList);
    }
  };
  self.keyUp = function(ev) {
    self.suggest._stopEvent(ev);
    if (self.existsSuggest()) {
      self.suggest.keyEventMove(ev.keyCode);
    } else {
      if (self.history.num > 0)
        self.input.value = self.history.log[--self.history.num];
    }
  };
  self.keyDown = function(ev) {
    self.suggest._stopEvent(ev);
    if (self.existsSuggest()) {
      self.suggest.keyEventMove(ev.keyCode);
    } else {
      if (self.history.num < self.history.log.length-1)
        self.input.value = self.history.log[++self.history.num];
    }
  };

  self.SPKey = {
    13: self.keyReturn,
    32: self.keySpace,
    38: self.keyUp,
    40: self.keyDown
  };

  Suggest.LocalMulti.prototype.checkLoop = function(event) {};
  Suggest.LocalMulti.prototype.keyEvent = function(event) {};
  self.suggest = new Suggest.LocalMulti(inputId, suggestId, self.globalCandidates,
      { dispMax: 10, highlight: true, hookBeforeSearch: self.newSuggestions});

  return self;
}
// vim: set ts=2 sw=2 et:
