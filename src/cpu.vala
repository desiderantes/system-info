/*
 * cpu.vala
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
using Gio;



namespace SystemInfo{
	protected class CPUParser: Object{
		
		private string base_dir = "/sys/devices/system/cpu/cpu";
		public string vendor = "Unknown";
		public uint cpus = 0;
		public CPU cpu_module;		
		public string name = "Unknown";
		public string frequency = "Unknown";
		public string cache = "Unknown";
		
		public string bogomips = "Unknown";
		public string numbering = "Unknown";
		public string flags = "Unknown";
		
		public CPUParser(CPU main){
			this.cpu_module = main;
		}
				
		public void parse(string path) {
		
			var file = File.new_for_path (path);
			if (!file.query_exists ()) {
				error("CPU data on '%s' is not avaliable.\n", file.get_path ());
			}
			try {
               
				var dis = new DataInputStream (file.read ());
				processor(dis);
				}
			} catch (Error e) {
				error ("%s", e.message);
			}
			
		}
		
		public void processor (DataInputStream dis) throws Error{
			
			try{
				string? line = dis.read_line();
				while(line != null){
					cpus++;
					do{
						string[] pair = line.split(":");
						var prop = pair[0];
						var vals = pair[1];
						prop.strip();
						vals.strip();
						line = dis.read_line();
					}while(line.strip() != "");
				}
				
			} catch (Error e) {
				throw e;
			}
		}
	}
	public class CPU : Module {
		public CPUParser cpu_parser;
		
		public CPU(){
			name = _("CPU");
			datablock = new Datablock();
			cpu_parser = new CPUParser(this);
		}		
		
		public void run(){
			cpu_parser.parse("/proc/cpuinfo");
		}

	}



}