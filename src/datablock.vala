
namespace SystemInfo{
	public class Datablock{
		public Gee.HashMap<string, string, double> data;
		public string name;
		public GLib.List<Datablock> childs;
		
		public Datablock (string name){
			this.name = name;
			data = new Gee.HashMap<string,string,double>();
			childs = new GLib.List<Datablock>();
		}
		
		public Datablock? get_child(string name){
			foreach (Datablock block in childs ){
				if(block.name == name){
					return block;
				}
			}
			return null;
		}
		
	}
}
