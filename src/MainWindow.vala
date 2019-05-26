public class Satellite.MainWindow : Gtk.ApplicationWindow {
    private Gtk.HeaderBar header_bar;
    private Granite.Widgets.ModeButton view_mode;
    private Gtk.SearchEntry search_entry;

    public MainWindow (Gtk.Application app) {
        Object (application: app);

        default_height = 480;
        default_width = 840;

        title = "Satellite";

        header_bar = new Gtk.HeaderBar ();
        header_bar.show_close_button = true;

        view_mode = new Granite.Widgets.ModeButton ();
        view_mode.append_text ("CPU");
        view_mode.append_text ("Memory");
        view_mode.append_text ("Energy");
        view_mode.append_text ("Disk");
        view_mode.append_text ("Network");

        header_bar.set_custom_title (view_mode);

        search_entry = new Gtk.SearchEntry ();
        search_entry.valign = Gtk.Align.CENTER;
        search_entry.placeholder_text = "Search..";

        header_bar.pack_end (search_entry);

        set_titlebar (header_bar);
    }
}
