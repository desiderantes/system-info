/*
 * datablock.vala
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

namespace SystemInfo{

	public class CardNode : Object {
		// Data:
		public int id { get; set; }
		public string name { get; set; }
		public string val { get; set; }
		public Gtk.Widget? widget { get; set; }
	
		public CardNode (int id, string name, string val, Gtk.Widget? widget = null) {
			this.val = val;
			this.widget = widget;
			this.name = name;
			this.id = id;
		}
	}	

	public class CardStore : Gtk.ListStore{
		private CardNode data[];
		private int stamp = 0;
	
		public CardStore () {
			
			if (data == null) {
				this.data = new CardNode [] ();
			} else {
				this.data = (owned) data;
			}
		}
	
		public void add (int id, string name, string val, Gtk.Widget? widget = null) {
			data.add (new CardNode (id, name, val, widget));
			stamp++;
		}
	
		public Type get_column_type (int index) {
			switch (index) {
			case 0:
				return typeof (int);
			case 1:
			case 2:
				return typeof (string);
			case 3:
				return typeof (Gtk.Widget)
			default:
				return Type.INVALID;
			}
		}
	
		public Gtk.TreeModelFlags get_flags () {
			return 0;
		}
	
		public void get_value (Gtk.TreeIter iter, int column, out Value val) {
			assert (iter.stamp == stamp);
	
			CardNode node = data.get ((int) iter.user_data);
			switch (column) {
			case 0:
				val = Value (typeof (int));
				val.set_int (node.id);
				break;
	
			case 1:
				val = Value (typeof (string));
				val.set_string (node.name);
				break;
	
			case 2:
				val = Value (typeof (string));
				val.set_string (node.val);
				break;
	
			case 3:
				val = Value (typeof (Gtk.Widget));
				val.set_object (node.widget);
				break;
	
			default:
				val = Value (Type.INVALID);
				break;
			}
		}
	
		public bool get_iter (out Gtk.TreeIter iter, Gtk.TreePath path) {
			if (path.get_depth () != 1 || data.length == 0) {
				return invalid_iter (out iter);
			}
	
			iter = Gtk.TreeIter ();
			iter.user_data = path.get_indices ()[0].to_pointer ();
			iter.stamp = this.stamp;
			return true;
		}
	
		public int get_n_columns () {
			// id, name, value, widget
			return 4;
		}
	
		public Gtk.TreePath? get_path (Gtk.TreeIter iter) {
			assert (iter.stamp == stamp);
	
			Gtk.TreePath path = new Gtk.TreePath ();
			path.append_index ((int) iter.user_data);
			return path;
		}
	
		public int iter_n_children (Gtk.TreeIter? iter) {
			assert (iter == null || iter.stamp == stamp);
			return (iter == null)? data.length : 0;
		}
	
		public bool iter_next (ref Gtk.TreeIter iter) {
			assert (iter.stamp == stamp);
	
			int pos = ((int) iter.user_data) + 1;
			if (pos >= data.length) {
				return false;
			}
			iter.user_data = pos.to_pointer ();
			return true;
		}
	
		public bool iter_previous (ref Gtk.TreeIter iter) {
			assert (iter.stamp == stamp);
	
			int pos = (int) iter.user_data;
			if (pos >= 0) {
				return false;
			}
	
			iter.user_data = (--pos).to_pointer ();
			return true;
		}
	
		public bool iter_nth_child (out Gtk.TreeIter iter, Gtk.TreeIter? parent, int n) {
			assert (parent == null || parent.stamp == stamp);
	
			if (parent == null && n < data.length) {
				iter = Gtk.TreeIter ();
				iter.stamp = stamp;
				iter.user_data = n.to_pointer ();
				return true;
			}
	
			// Only used for trees
			return invalid_iter (out iter);
		}
	
		public bool iter_children (out Gtk.TreeIter iter, Gtk.TreeIter? parent) {
			assert (parent == null || parent.stamp == stamp);
			// Only used for trees
			return invalid_iter (out iter);
		}
	
		public bool iter_has_child (Gtk.TreeIter iter) {
			assert (iter.stamp == stamp);
			// Only used for trees
			return false;
		}
	
		public bool iter_parent (out Gtk.TreeIter iter, Gtk.TreeIter child) {
			assert (child.stamp == stamp);
			// Only used for trees
			return invalid_iter (out iter);
		}
	
		private bool invalid_iter (out Gtk.TreeIter iter) {
			iter = Gtk.TreeIter ();
			iter.stamp = -1;		
			return false;
		}
	}
	public class CardBlock : Gtk.Box{
		public string name;
		private Gtk.Widget widget;
		private Gtk.Label name_label;
		private Gtk.Label value_label;
		
		
		public CardBlock (string name, string val, bool expandable, bool title){
			Object(orientation: Gtk.Orientation.HORIZONTAL, spacing:10);
			this.name = name;
			data = new Gee.HashMultiMap<string,string>();

		}
		
		public CardBlock.with_widget(string name, string val, bool expandable, Gtk.Widget widget){
			Object(orientation: Gtk.Orientation.VERTICAL, spacing:15);
			
		}
	}
	
	public class CardView:{
		public Gtk.Box internal_box
	}
	
	
	public class Cardbox: Gtk.Box{
		public Gee.HashMultiMap<string, string> data;
		public string name;

		
		public Cardbox (string name){
			Object(orientation: Gtk.Orientation.VERTICAL, spacing:15);
			this.name = name;
			data = new Gee.HashMultiMap<string,string>();

		}
		

		
	}
}
