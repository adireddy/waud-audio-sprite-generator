package ui;

import sys.FileSystem;
import wx.MessageDialog;
import wx.CheckBox;
import sys.io.Process;
import sys.io.File;
import wx.DirDialog;
import wx.Point;
import wx.DC;
import wx.Button;
import wx.StaticText;
import wx.Colour;
import wx.Brush;
import wx.Pen;
import wx.Font;
import wx.ComboBox;
import wx.TextCtrl;
import wx.BoxSizer;
import wx.FlexGridSizer;
import wx.Sizer;
import wx.App;
import wx.Frame;
import wx.Window;
import wx.Panel;
import haxe.Timer;

class UI {

	var mFrame:Frame;
	var mWindow:Window;
	var mDrawArea:Window;

	public function new(node:Bool, ffmpeg:Bool) {
		mFrame = Frame.create(null, null, "Waud Audio Sprite Generator", null, { width: 800, height: 400 });
		mFrame.onSize = function(evt) { layout(); evt.skip = true; }

		mWindow = Panel.create(mFrame);

		if (!node) {
			var verticalSizer:FlexGridSizer = FlexGridSizer.create(null, 1);
			var txt = "node not installed\n\nhttps://nodejs.org/en/download/";
			var supportTxt:StaticText = StaticText.create(mWindow, null, txt, new Point(300, 200));
			verticalSizer.add(supportTxt, 0, Sizer.ALIGN_CENTRE_VERTICAL);
		}
		else if (!ffmpeg) {
			var verticalSizer:FlexGridSizer = FlexGridSizer.create(null, 1);
			var txt = "ffmpeg not installed\n\nbrew install ffmpeg --with-theora --with-libogg --with-libvorbis";
			var supportTxt:StaticText = StaticText.create(mWindow, null, txt, new Point(200, 200));
			verticalSizer.add(supportTxt, 0, Sizer.ALIGN_CENTRE_VERTICAL);
		}
		else {
			var verticalSizer:FlexGridSizer = FlexGridSizer.create(3, 2, 10, 10);
			var nodeModulesBtn:Button = Button.create(mWindow, null, " Install Node Modules ", new Point(320, 10));
			nodeModulesBtn.onClick = function(evt) {
				nodeModulesBtn.label = " Installing... ";
				var installCnt = 0;
				var mod = new Process("npm", ["install", "underscore"]);
				installCnt += mod.exitCode();
				mod.kill();
				mod = new Process("npm", ["install", "winston"]);
				installCnt += mod.exitCode();
				mod.kill();
				mod = new Process("npm", ["install", "async"]);
				installCnt += mod.exitCode();
				mod.kill();
				mod = new Process("npm", ["install", "optimist"]);
				installCnt += mod.exitCode();
				mod.kill();
				mod = new Process("npm", ["install", "mkdirp"]);
				installCnt += mod.exitCode();
				mod.kill();
				nodeModulesBtn.label = (installCnt == 0) ? "Success" : "Failed";
				nodeModulesBtn.onClick = null;
			};

			var dirLabel:StaticText = StaticText.create(mWindow, null, "Select sounds directory:", new Point(30, 52));
			var dirPath:TextCtrl = TextCtrl.create(mWindow, null, "", new Point(200, 50), { width: 465, height: 24 });
			dirPath.value = FileSystem.fullPath("./");
			var dirWindow:DirDialog = new DirDialog(mWindow, "Choose sounds folder", "./");
			var browseBtn:Button = Button.create(mWindow, null, "Browse", new Point(675, 48));

			var exportOption:StaticText = StaticText.create(mWindow, null, "Export format:", new Point(92, 90));
			var m4a:CheckBox = CheckBox.create(mWindow, null, "M4A", new Point(200, 90));
			var mp3:CheckBox = CheckBox.create(mWindow, null, "MP3", new Point(260, 90));
			var ogg:CheckBox = CheckBox.create(mWindow, null, "OGG", new Point(320, 90));
			var ac3:CheckBox = CheckBox.create(mWindow, null, "AC3", new Point(380, 90));
			m4a.checked = mp3.checked = ogg.checked = ac3.checked = true;

			var channelsLabel:StaticText = StaticText.create(mWindow, null, "Channels:", new Point(119, 117));
			var channels:ComboBox = ComboBox.create(mWindow, null, "1", new Point(200, 115), { width: 30, height: 20 }, ["1", "2"]);
			channels.fit();

			browseBtn.onClick = function(evt) {
				dirWindow.showModal();
				dirPath.value = dirWindow.directory;
				//App.quit();
			}

			var msgDialog:MessageDialog = new MessageDialog(mWindow, "", "Error");
			var execBtn = Button.create(mWindow, null, " Generate Audio Sprite ", new Point(320, 300));

			execBtn.onClick = function(evt) {
				if (dirPath.value == "") {
					msgDialog.caption = "Directory";
					msgDialog.message = "Empty Sounds Directory";
					msgDialog.showModal();
				}

				var dirContent = FileSystem.readDirectory(dirPath.value);
				for (file in dirContent) {
					if (file.indexOf(".m4a") > -1 || file.indexOf(".mp3") > -1 || file.indexOf(".ogg") > -1 || file.indexOf(".wav") > -1) {

					}
				}

				var exportStr = [];
				if (m4a.checked) exportStr.push("m4a");
				if (mp3.checked) exportStr.push("mp3");
				if (ogg.checked) exportStr.push("ogg");
				if (ac3.checked) exportStr.push("ac3");

				/*var mod = new Process("node", ["waudaudiosprite",
				"-e", exportStr.join(","),
				"-o", dirPath.value + "/sprite",
				dirPath.value + "*//**//*.mp3"
				]);*/

				var mod = new Process("cd", [dirPath.value]);
				mod = new Process("node", ["waudaudiosprite",
				"-o " + "/sprite",
				"-e " + exportStr.join(","),
				"/*.mp3"
				]);

				/*Sys.command("node", ["waudaudiosprite",
				"-o " + dirPath.value + "/sprite",
				"-e " + exportStr.join(","),
				dirPath.value + "*//*.mp3"
				]);*/

				trace("node waudaudiosprite -e " + exportStr.join(",") + " -o " + dirPath.value + "/sprite" + " " + dirPath.value + "/*.mp3");

				//trace(mod.exitCode());

				//--loop loop --autoplay loop
				//logLabel.label = "" + mod.stdout;


				//Sys.command("npm");
				//Sys.getEnv("npm install underscore");
				//trace(Sys.environment());
				//mod.kill();
				//node audiosprite --loop loop --autoplay loop -o assets/sprite -e m4a assets/*.mp3
			}




			//verticalSizer.add(dirPath, 0, Sizer.ALIGN_CENTRE_HORIZONTAL);



			//var button_sizer:BoxSizer = BoxSizer.create(false);
			//button_sizer.add(close);

			/*mDrawArea = Panel.create(mWindow);
			var vertical_sizer:FlexGridSizer = FlexGridSizer.create(null, 1);
			vertical_sizer.addGrowableCol(0);
			var items_sizer:FlexGridSizer = FlexGridSizer.create(null, 2);

			vertical_sizer.add(items_sizer, 0, Sizer.EXPAND);
			vertical_sizer.add(mDrawArea, 1, Sizer.EXPAND);
			vertical_sizer.add(button_sizer, 0,
			Sizer.ALIGN_CENTRE | Sizer.BORDER_TOP | Sizer.BORDER_BOTTOM, 10);
			vertical_sizer.addGrowableRow(1);


			items_sizer.addGrowableCol(1, 1);
			items_sizer.add(StaticText.create(mWindow, null, "TextCtrl"), 0, Sizer.ALIGN_CENTRE_VERTICAL);
			var text:TextCtrl = TextCtrl.create(mWindow, null, "Here is some text");
			items_sizer.add(text, 1, Sizer.EXPAND | Sizer.BORDER_ALL, 10);

			items_sizer.add(StaticText.create(mWindow, null, "ComboBox"), 0, Sizer.ALIGN_CENTRE_VERTICAL);
			var combo:ComboBox = ComboBox.create(mWindow, null, "Some Text", ["Choice 1", "Choice 2"]);
			items_sizer.add(combo, 1, Sizer.EXPAND | Sizer.BORDER_ALL, 10);

			items_sizer.add(StaticText.create(mWindow, null, "Text 3"), 0, Sizer.ALIGN_CENTRE_VERTICAL);
			var text:TextCtrl = TextCtrl.create(mWindow, null, "Hello !");
			items_sizer.add(text, 1, Sizer.EXPAND | Sizer.BORDER_ALL, 10);

			mWindow.sizer = vertical_sizer;*/
		}

		/*

		var menu_bar = new MenuBar();
		var file_menu = new Menu();
		file_menu.append(1, "Open File");

		// make sure the About, Preferences and Exit menus are correctly handled on OSX.
		// they shoudl remain under the File menu on other platforms.
		file_menu.append(App.s_macAboutMenuItemId, "About Simple.hx");
		file_menu.append(App.s_macPreferencesMenuItemId, "Preferences of Simple.hx");
		// on OSX, the label of the Exit menu will always be the localized system one.
		// "Quit" in english; you cannot override that label
		file_menu.append(App.s_macExitMenuItemId, "Exit");

		// on OSX, never append or set the menubar before it is completed
		menu_bar.append(file_menu, "File");

		// attach the menubar to the application
		mFrame.menuBar = menu_bar;*/

		//mDrawArea.backgroundColour = 0xffffff;


		layout();

		//mDrawArea.onPaint = paintWindow;
		App.setTopWindow(mFrame);
		mFrame.shown = true;
	}

	function paintWindow(dc:DC) {
		dc.clear();
		dc.pen = new Pen( Colour.Pink(), 3 );
		dc.drawLine(0, 0, 300, 250);
		dc.brush = new Brush( Colour.Yellow(), Brush.SOLID );
		dc.drawRectangle(100, 100, 100, 200);
		dc.brush = new Brush( Colour.DarkGreen(), Brush.SOLID );
		dc.pen = new Pen( Colour.Black(), 3, Pen.SHORT_DASH );
		dc.drawCircle(100, 10, 50);
		dc.drawEllipse(100, 200, 200, 40);
		dc.font = new Font(20);
		dc.drawText("Hello!", 20, 20);
	}

	function layout() {
		mWindow.size = mFrame.clientSize;
	}
}