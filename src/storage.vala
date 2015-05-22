/*
 * storage.vala
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
using Smart;


namespace SystemInfo{
	public class Storage : Module {
	    public string[] disk_list	
		public Storage(){
			name = _("Storage");
			disk_list={};
			try{
				var directory = File.new_for_path ("/sys/block");
				var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);
				FileInfo file_info;
				while ((file_info = enumerator.next_file ()) != null) {
					if( file_info.get_name ().has_prefix("sd")){
						disk_list+= "/dev/"+file_info.get_name();
					}
				}
			} catch (Error e) {
				stderr.printf ("Error: %s\n", e.message);
			}
			report_store = new CardStore (2, typeof (string), typeof (string));
			report_store.append (out root, null);
			report_store.set (root, 0, _("Drives available"), -1);
			drive_parser = new DriveParser(this, report_store);
			foreach (string disk_name in disk_list){
				drive_parser.parse(name);
			}
		}
		public void parse(string path) {
			var disk = Smart.Disk.open(path);
			Smart.IdentifyParsedData identity;
			disk.identify_parse(identity);
			Smart.SmartParsedData smart;
			disk.smart_parse(smart);
			uint64 size;
			disk.get_size(size);
			string si_size = GLib.format_size(size);
			string computer_size = GLib.format_size(size, FormatSizeFlags.IEC_UNITS);
			var status = true;
			disk.is_good(status);
			Gtk.TreeIter disk_iter;
			Gtk.TreeIter info_iter;
			report_store.append (out disk_iter, root);
			report_store.set (disk_iter, 0, _("%s Disk").printf(si_size), -1);
			report_store.append (out info_iter, disk_iter);
			report_store.set (info_iter, 0, _("Model"), 1, identity.model, -1);
			report_store.append (out info_iter, disk_iter);
			report_store.set (info_iter, 0, _("Firmware version"), 1, identity.firmware, -1);
			report_store.append (out info_iter, disk_iter);
			report_store.set (info_iter, 0, _("Serial")), 1, identity.serial, -1);
			report_store.append (out info_iter, disk_iter);
			report_store.set (info_iter, 0, _("Size in byte units"), 1, computer_size, -1);
			report_store.append (out info_iter, disk_iter);
			report_store.set (info_iter, 0, _("Status"), 1, status ? _("GOOD") : _("ISSUES"), -1);
		}				
	}



}
