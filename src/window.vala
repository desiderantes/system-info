using GLib;

namespace SystemInfo{
	public class Window : Gtk.ApplicationWindow{
		public Gtk.HeaderBar header_bar { get; private set; }
		public Gtk.Button export_button { get; private set; }
		public Gtk.MenuButton app_menu { get; private set; }
		private Gtk.Paned paned;
		private Gtk.MenuItem preferences_menu_item;
		private Gtk.Popover menu_popover;
		private Gtk.Revealer content_revealer;

		public Window (SystemInfo.Application app){
			Object(application: app);

			this.window_position = Gtk.WindowPosition.CENTER;
			this.destroy.connect (Gtk.main_quit);
			setup_ui(app);
		}
		
		public void setup_ui(Application app){
			
			
			// configure window
            width_request = 800;
            height_request = 600;
            
			content_revealer = new Gtk.Revealer ();
			content_revealer.set_transition_duration (0);
			content_revealer.set_transition_type (Gtk.RevealerTransitionType.CROSSFADE);

		
			// Menus
			app_menu = new Gtk.MenuButton ();
			preferences_menu_item = new Gtk.MenuItem.with_label ("Preferences");

			var menu_icon = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
			app_menu.set_image (menu_icon);
			menu_popover = new Gtk.Popover.from_model (app_menu, app.app_menu);
			app_menu.popover = menu_popover;

			// main paned widget
			paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
			paned.position = 250;
			paned.position_set = true;
			this.add (paned);
			
			paned.pack2 (content_revealer, true, false);
			
			// header bar
			header_bar = new Gtk.HeaderBar ();
			header_bar.show_close_button = true;
			set_titlebar (header_bar);
			header_bar.pack_end (app_menu);
			
			// export button
			export_button = new Gtk.Button.from_icon_name ("document-export", Gtk.IconSize.LARGE_TOOLBAR);
			export_button.tooltip_text = _("Export report");
			header_bar.pack_end (export_button);
			header_bar.show_all ();
			// done! show all
			
		}
		
	
	}
}
