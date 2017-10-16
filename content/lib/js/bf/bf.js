var OP_INC = 1;
var OP_DEC = 2;
var OP_NEXT = 3;
var OP_PREV = 4;
var OP_PUT = 5;
var OP_GET = 6;
var OP_BEGIN_WHILE = 7;
var OP_END_WHILE = 8;
var OP_QUIT = 9;
function BF(src, input) {
    var self = this;
    self.execute = function() {
        var pc = 0, mp = 0;
        var output = "";
        for (pc=0, mp=0;;pc+=2) {
            var code = self.codes[pc];
            switch (code) {
                case OP_INC:
                    ++self.mem[mp];
                    break;
                case OP_DEC:
                    --self.mem[mp];
                    break;
                case OP_NEXT:
                    ++mp;
                    break;
                case OP_PREV:
                    --mp;
                    break;
                case OP_PUT:
                    output += String.fromCharCode(self.mem[mp]);
                    break;
                case OP_GET:
			        if (self.input.length == 0){
			        	self.mem[mp] = 0;
			        } else {
			        	self.mem[mp] = input.charCodeAt(0);
			        	self.input = self.input.substring(1, input.length);
			        }
                    break;
                case OP_BEGIN_WHILE:
                    if (self.mem[mp] == 0) {
                        pc = self.codes[pc+1];
                    }
                    break;
                case OP_END_WHILE:
                    pc = self.codes[pc+1];
                    break;
                case OP_QUIT:
                    return output;
                default:
                    throw "error";
            }
        }
        return output;
    };

    self.src = src;
    self.input = input;

	self.mem = Array(30000);
	for (i=0;i<30000;++i) self.mem[i] = 0;
    self.codes = [];

    var pcstack = [];
    for (var i=0;i<src.length;++i) {
        switch (src.charAt(i)) {
            case '+':
                self.codes.push(OP_INC, 0);
                break;
            case '-':
                self.codes.push(OP_DEC, 0);
                break;
            case '>':
                self.codes.push(OP_NEXT, 0);
                break;
            case '<':
                self.codes.push(OP_PREV, 0);
                break;
		    case '.':
                self.codes.push(OP_PUT, 0);
		    	break;
		    case ',':
                self.codes.push(OP_GET, 0);
		    	break;
		    case '[':
                self.codes.push(OP_BEGIN_WHILE, 0);
                pcstack.push(self.codes.length-1);
		    	break;
		    case ']':
                beginpc = pcstack.pop();
                self.codes[beginpc] = self.codes.length;
                self.codes.push(OP_END_WHILE, beginpc - 3);
		    	break;
		}
    }
    self.codes.push(OP_QUIT, 0);
    return self;
}
