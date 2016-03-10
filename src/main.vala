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
	public class Options : Object {
		public OptionContext opt_context;
		public bool version = false;
		[CCode (array_length = false, array_null_terminated = true)]
		public string? config_file = null;
		public Window window;
		public OptionEntry entries[3];
		public Options(){
			version = false;
			entries[0] = { "config-file", 'c', 0, OptionArg.STRING, ref config_file,
				_("Uses a different config file"), "CONFIG_FILE"};
			entries[1] = { "version", 0, 0, OptionArg.NONE, ref version,
						   _("Display version number"), null };
			entries[2] = {null};

			opt_context = new OptionContext (Build.PROGRAM_NAME);
			opt_context.set_help_enabled (true);
			opt_context.add_main_entries (entries, Build.RELEASE_NAME);
			opt_context.add_group( Gtk.get_option_group(true) );
		}
		public void parse(string[] args) throws OptionError {
			try {
				opt_context.parse(ref args);
			} catch(OptionError e){
				throw e;
			}
		}
	}


	public class Application : Granite.Application{
	
		public Options opts;
		public MainWindow window;
		
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
			app_years = Build.COPYRIGHT_YEARS;

			main_url = Build.MAIN_URL;
			bug_url = Build.BUG_URL;
			help_url = Build.HELP_URL;
			translate_url = Build.TRANSLATE_URL;

			about_authors = {"Mario Daniel Ruiz Saavedra (Desiderantes) <desiderantes@rocketmail.com>"};
			about_comments = "";
			about_license_type = Gtk.License.GPL_3_0;
			
		}

		protected override void startup() {

			var action = new GLib.SimpleAction ("quit", null);
			action.activate.connect (quit);
			add_action (action);
			add_accelerator ("<Ctrl>Q", "app.quit", null);
			action = new GLib.SimpleAction ("generate-report", null);
			// action.activate.connect ();
			add_action (action);
			add_accelerator ("<Ctrl>E", "app.generate-report", null);
			base.startup();
		}
		protected override void activate() {
			hold();
			if(window == null) {
				this.window = new MainWindow (this);
				window.destroy.connect (Gtk.main_quit);
			}
			window.present();
			release();
		}

		public static int main (string[] args){
			if (!Thread.supported ()) {
				GLib.error ("Cannot run without thread support.\n");
			}
			GLib.Intl.textdomain(Build.GETTEXT_PACKAGE);
			GLib.Intl.setlocale ();
			Environment.set_application_name(Build.EXEC_NAME);
			MainLoop loop = new MainLoop();
			Gtk.init(ref args);
			// Gst.init(ref args);
			Options opts = new Options();
			try {
				opts.parse (args);
			} catch (OptionError e) {
				stdout.printf ("error: %s\n", e.message);
				stdout.printf (
					_("Run '%s --help' to see a full list of available command line options.\n"),
					Build.EXEC_NAME);
				return 0;
			}

			if (opts.version) {
				stdout.printf("%s (%s) - a System Report Utility", Build.VERSION_INFO,  Build.VERSION);
				stdout.printf("Copyright © %s authors, see AUTHORS file for a complete list", Build.PROGRAM_NAME);
				return 0;
			}
			var app = new Application ();
			loop.run();
			return app.run (args);
		}
	
	}
}