/*
 * window.vala
 * Copyright (C) 2015 Mario Daniel Ruiz Saavedra <desiderantes@rocketmail.com>
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using GLib;
using Gtk;
using Granite;

namespace SystemInfo {
	public class MainWindow : Gtk.ApplicationWindow {
		public Gtk.HeaderBar header_bar { get; private set; }
		public Gtk.Button save_button { get; private set; }
		public Gtk.MenuButton app_menu { get; private set; }
		private Gtk.Paned paned;
		/*private CardBox general_box;
		private CardBox cpu_box;
		private CardBox motherboard_box;
		private CardBox ram_box;
		private CardBox peripherals_box;
		private CardBox graphics_box;
		private CardBox audio_box;
		private CardBox storage_box;
		private CardBox network_box;
		private List<Module> module_list;
		*/	
		private Granite.Widgets.SourceList source_list;
		private Gtk.MenuItem preferences_menu_item;
		private Gtk.Popover menu_popover;
		private Gtk.Revealer content_revealer;
		
		public MainWindow (SystemInfo.Application app) {
			Object (application: app);
			this.window_position = Gtk.WindowPosition.CENTER;
			this.destroy.connect (Gtk.main_quit);
			setup_ui (app);
		}
		
		public void setup_ui (Application app){
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
			paned.position_set = true;
			this.add (paned);
			setup_sourcelist ();
			paned.pack1 (source_list, true, false);
			paned.pack2 (content_revealer, true, false);
			
			// header bar
			header_bar = new Gtk.HeaderBar ();
			header_bar.show_close_button = true;
			header_bar.title = Build.PROGRAM_NAME;
			set_titlebar (header_bar);
			header_bar.pack_end (app_menu);
			
			// save button
			save_button = new Gtk.Button.from_icon_name ("document-save", Gtk.IconSize.LARGE_TOOLBAR);
			save_button.tooltip_text =_("Save report");
			header_bar.pack_end (save_button);
			header_bar.show_all ();
		}
		
		public void setup_sourcelist () {
			var system_category = new Granite.Widgets.SourceList.ExpandableItem (_("System"));
			//var benchmark_category = new Granite.Widgets.SourceList.ExpandableItem(_("Benchmark"));
			var general_item = new Granite.Widgets.SourceList.Item (_("General"));
			var cpu_item = new Granite.Widgets.SourceList.Item (_("Processor"));
			var motherboard_item = new Granite.Widgets.SourceList.Item (_("Motherboard"));
			var ram_item = new Granite.Widgets.SourceList.Item (_("RAM"));
			var peripherals_item = new Granite.Widgets.SourceList.Item (_("Peripherals"));
			var graphics_item = new Granite.Widgets.SourceList.Item (_("Graphics"));
			var audio_item = new Granite.Widgets.SourceList.Item (_("Audio"));
			var storage_item = new Granite.Widgets.SourceList.Item (_("Storage"));
			var network_item = new Granite.Widgets.SourceList.Item (_("Network"));
			
			system_category.add (general_item);
			system_category.add (cpu_item);
			system_category.add (motherboard_item);
			system_category.add (ram_item);
			system_category.add (peripherals_item);
			system_category.add (graphics_item);
			system_category.add (audio_item);
			system_category.add (storage_item);
			system_category.add (network_item);
			
			system_category.expanded = false;
			source_list = new Granite.Widgets.SourceList ();
			
			var root = source_list.root;
			root.add(system_category);
			/*source_list.item_selected.connect((item)=>{
				if (item != null){
					switch (item){
						case general_item:
							if(general_item.get_data<Module>("Module"))							
					
					}
				}
			});*/


//			root.add(benchmark_category);
		}
		
		public void setup_modules(){
			
		}	
	}
}
