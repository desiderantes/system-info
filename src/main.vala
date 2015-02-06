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
			{ "config-file", 'c', 0, OptionArg.STRING,
				ref config_file,
				"Uses a different config file", "CONFIG_FILE"},
			{ "version", 'v', 0, OptionArg.NONE, ref version,
				"Display version number", null },
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
			Gtk.init(ref args);
			var app = new Application();
			return app.run(args);
		}
	
	}
}
