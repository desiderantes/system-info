/*
 * main.vala
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

namespace SystemInfo{
	public class Application : Granite.Application{
	
		public OptionContext opt_context;
		public static bool version = false;
		public static string config_file = "";
		public Window window;
		public static const OptionEntry[] entries = {
			{ "config-file", 'c', 0, OptionArg.STRING, ref config_file,
				_("Uses a different config file"), "CONFIG_FILE"},
			{ "version", 'v', 0, OptionArg.NONE, ref version,
				_("Display version number"), null },
			{null}//Obligatory null terminator for this kind of list
		};
		construct {
			// App info
			build_data_dir = Build.DATADIR;
			build_pkg_data_dir = Build.PACKAGE_DATA_DIR;
			build_release_name = Build.RELEASE_NAME;
			build_version = Build.VERSION;
			build_version_info = Build.VERSION_INFO;

			program_name = Build.PROGRAM_NAME;
			exec_name = Build.EXEC_NAME;

			app_copyright = Build.COPYRIGHT_YEARS;
			application_id = "org.system-info";
			app_icon = "accessories-calculator";
			app_launcher = "system-info.desktop";
			app_years = "2015";

			main_url = Build.MAIN_URL;
			bug_url = Build.BUG_URL;
			help_url = Build.HELP_URL;
			translate_url = Build.TRANSLATE_URL;

			about_authors = {"Mario Daniel Ruiz Saavedra (Desiderantes) <desiderantes@rocketmail.com>"};
			about_comments = "";
			about_license_type = Gtk.License.GPL_3_0;
			
		}
		protected override void activate() {
			this.window = new SystemInfo.Window(this);
			window.show_all();
			window.destroy.connect(Gtk.main_quit);
		}
		public static int main(string[] args){
			if (!Thread.supported()) {
				GLib.error("Cannot run without thread support.\n");
			}
			GLib.Intl.set_locale();
			Gtk.init(ref args);
			var app = new Application();
			return app.run(args);
		}
	
	}
}