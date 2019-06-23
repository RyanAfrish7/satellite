public class Satellite.MainWindow : Gtk.ApplicationWindow {
    private Gtk.HeaderBar header_bar;
    private Granite.Widgets.ModeButton view_mode;
    private Gtk.SearchEntry search_entry;
    private Gtk.Stack stack;

    private CPUView cpu_view;
    private MemoryView memory_view;
    private Orchestrator orchestrator;

    enum View {
        CPU,
        MEMORY,
        NETWORK,
        ENERGY,
        DISK;

        public string name() {
            switch (this) {
                case CPU: return "CPU";
                case MEMORY: return "Memory";
                case NETWORK: return "Network";
                case ENERGY: return "Energy";
                case DISK: return "Disk";
                default: assert_not_reached();
            }
        }

        public static const View[] _all = { CPU, MEMORY, NETWORK, ENERGY, DISK };
    }

    public MainWindow (Gtk.Application app) {
        Object (application: app);

        default_height = 480;
        default_width = 840;

        title = "Satellite";

        header_bar = new Gtk.HeaderBar ();
        header_bar.show_close_button = true;

        view_mode = new Granite.Widgets.ModeButton ();

        foreach (View view in View._all ) {
            view_mode.append_text (view.name());
        }

        view_mode.set_active (0);

        view_mode.mode_changed.connect((widget) => {
            stack.visible_child_name = View._all[view_mode.selected].name();
        });

        header_bar.set_custom_title (view_mode);

        search_entry = new Gtk.SearchEntry ();
        search_entry.valign = Gtk.Align.CENTER;
        search_entry.placeholder_text = "Search..";

        header_bar.pack_end (search_entry);

        set_titlebar (header_bar);

        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        cpu_view = new Satellite.CPUView ();
        stack.add_named (wrap_with_scrolled_window (cpu_view), View.CPU.name ());

        memory_view = new Satellite.MemoryView ();
        stack.add_named (wrap_with_scrolled_window (memory_view), View.MEMORY.name ());

        stack.add_named (not_available_widget(), View.NETWORK.name ());
        stack.add_named (not_available_widget(), View.ENERGY.name ());
        stack.add_named (not_available_widget(), View.DISK.name ());

        add (stack);

        orchestrator = new Orchestrator (cpu_view, memory_view);
        orchestrator.init ();
        orchestrator.start ();
    }

    Gtk.Widget not_available_widget () {
        return new Gtk.Label ("Not available");
    }

    Gtk.ScrolledWindow wrap_with_scrolled_window (Gtk.Widget child) {
        var scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.add (child);
        return scrolled_window;
    }
}
