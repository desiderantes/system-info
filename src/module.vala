namespace SysInfo{
	public abstract class Module : Object{
		public string name {get; construct set}
		private CardStore report_store;
		private Gtk.TreeIter root;
		
		
		public static string byte_to_human(uint64 bytes, bool si) {
	    	int unit = si ? 1000 : 1024;
	    	if (bytes < unit) return bytes + " B";
	    	int exp = (int) (Math.log(bytes) / Math.log(unit));
	    	string pre = (si ? "kMGTPE" : "KMGTPE").get_char(exp-1).to_string() + (si ? "" : "i");
	    	return "".printf("%.1f %sB", bytes / Math.pow(unit, exp), pre);
		}
	
	}
	

}
