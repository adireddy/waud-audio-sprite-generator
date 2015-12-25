import ui.UI;
import wx.App;
import sys.io.Process;

class Main {

	function new() {
		var nodeCheck = new Process("node", ["-help"]);
		var node:Bool = (nodeCheck.exitCode() == 0);
		nodeCheck.kill();

		var ffmpegCheck = new Process("ffmpeg", ["-version"]);
		var ffmpeg:Bool = (ffmpegCheck.exitCode() == 0);
		ffmpegCheck.kill();

		App.boot(function() {
			new UI(node, ffmpeg);
		});
	}

	public static function main() {
		new Main();
	}
}