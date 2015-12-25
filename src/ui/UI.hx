package ui;

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

class UI {

	var mFrame:Frame;
	var mWindow:Window;
	var mDrawArea:Window;

	public function new(node:Bool, ffmpeg:Bool) {
		mFrame = Frame.create(null, null, "Waud Audio Sprite Generator", null, { width: 800, height: 600 });
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

			mDrawArea = Panel.create(mWindow);
			var vertical_sizer:FlexGridSizer = FlexGridSizer.create(null, 1);
			vertical_sizer.addGrowableCol(0);
			var items_sizer:FlexGridSizer = FlexGridSizer.create(null, 2);
			var button_sizer:BoxSizer = BoxSizer.create(false);
			vertical_sizer.add(items_sizer, 0, Sizer.EXPAND);
			vertical_sizer.add(mDrawArea, 1, Sizer.EXPAND);
			vertical_sizer.add(button_sizer, 0,
			Sizer.ALIGN_CENTRE | Sizer.BORDER_TOP | Sizer.BORDER_BOTTOM, 10);
			vertical_sizer.addGrowableRow(1);
			var close = Button.create(mWindow, null, "Close");
			button_sizer.add(close);

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

			mWindow.sizer = vertical_sizer;

			close.onClick = function(_) App.quit();
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