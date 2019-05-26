public class Satellite.App : Gtk.Application {
    construct {
        application_id = "com.github.ryanafrish7.satellite";
        flags = ApplicationFlags.FLAGS_NONE;
    }

    protected override void activate () {
        var main_window = new Satellite.MainWindow (this);
        main_window.show_all ();
    }

    public static int main (string[] args) {
        var application = new Satellite.App ();
        return application.run (args);
    }
}