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
        MEMORY;

        public string name() {
            switch (this) {
                case CPU: return _("CPU");
                case MEMORY: return _("Memory");
                default: assert_not_reached();
            }
        }

        public const View[] _all = { CPU, MEMORY };
    }

    private View last_selected_view;

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

        header_bar.set_custom_title (view_mode);

        search_entry = new Gtk.SearchEntry ();
        search_entry.valign = Gtk.Align.CENTER;
        search_entry.placeholder_text = _("Search…");

        header_bar.pack_end (search_entry);

        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        set_titlebar (header_bar);

        cpu_view = new Satellite.CPUView ();
        stack.add_named (wrap_with_scrolled_window (cpu_view), View.CPU.name ());

        memory_view = new Satellite.MemoryView ();
        stack.add_named (wrap_with_scrolled_window (memory_view), View.MEMORY.name ());

        add (stack);

        view_mode.mode_changed.connect((widget) => {
            View selected_view = View._all[view_mode.selected];

            stack.visible_child_name = selected_view.name();
            get_treeview (last_selected_view).set_search_entry (null);
            get_treeview (selected_view).set_search_entry (search_entry);
        });

        view_mode.set_active (0);
        last_selected_view = View._all[0];

        orchestrator = new Orchestrator (cpu_view, memory_view);
        orchestrator.init ();
        orchestrator.start ();
    }

    /*
    Gtk.Widget not_available_widget () {
        return new Gtk.Label (_("Not available"));
    }
    */

    Gtk.ScrolledWindow wrap_with_scrolled_window (Gtk.Widget child) {
        var scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.add (child);
        return scrolled_window;
    }

    Gtk.TreeView get_treeview (View view) {
        switch (view) {
            case CPU: return cpu_view;
            case MEMORY: return memory_view;
            default: assert_not_reached();
        }
    }
}
