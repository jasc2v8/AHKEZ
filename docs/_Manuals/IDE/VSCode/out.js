"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Out = void 0;
const vscode = require("vscode");
class Out {
    static log(value) {
			
				//disable output window
				return
				
        if (!this.channel) {
            this.channel = vscode.window.createOutputChannel('AHK');
        }
        this.channel.show(true);
        this.channel.appendLine(value + '');
    }
}
exports.Out = Out;
//# sourceMappingURL=out.js.map