public class Satellite.MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application app) {
        Object (application: app);

        default_height = 300;
        default_width = 480;

        title = "Satellite";
    }
}
