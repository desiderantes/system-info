/***
    Copyright (C) 2013 Sysinfo Developers

    This program or library is free software; you can redistribute it
    and/or modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 3 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General
    Public License along with this library; if not, write to the
    Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
    Boston, MA 02110-1301 USA.
***/

namespace Sysinfo
{
    /**
     * Main class of the application.
     */
    public class App : Gtk.Window {

        public App () {
            this.title = "Sysinfo";
            this.window_position = Gtk.WindowPosition.CENTER;
            this.destroy.connect (Gtk.main_quit);
            set_default_size (500, 300);

            var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            hbox.homogeneous = true;
            add (hbox);

            // Welcome widget
            var welcome = new Granite.Widgets.Welcome ("Granite's Welcome Screen",
                                                        "Hello World");

            hbox.add (welcome);
        }
    }
}

public static int main (string[] args) {
    Gtk.init (ref args);

    var window = new Sysinfo.App ();
    window.show_all ();

    Gtk.main ();
    return 0;
}


