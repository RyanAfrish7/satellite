public class Satellite.CPUViewModel : Satellite.AbstractModel<int> {
    public Satellite.ProcessInfoProvider process_info_provider;

    public enum Column {
        PID,
        COMMAND_LINE,
        UID,
        USER,
        CPU_USAGE
    }

    public CPUViewModel (Satellite.ProcessInfoProvider process_info_provider) {
        set_column_types (new Type[] {
            typeof (int),       // pid
            typeof (string),    // command_line
            typeof (int),       // uid
            typeof (string),    // username
            typeof (float)      // cpu_usage
        });

        this.process_info_provider = process_info_provider;
    }

    public void refresh () {
        Gee.Set<ProcessInfo> process_info_list = process_info_provider.fetch_all ();
        Gee.Set<int> pids = new Gee.HashSet<int> ();

        foreach (ProcessInfo process_info in process_info_list) {
            Gtk.TreeIter iter = get_or_append_row (process_info.pid);
            set (iter,
                Column.PID, process_info.pid,
                Column.COMMAND_LINE, process_info.command_line,
                Column.UID, process_info.uid,
                Column.USER, process_info.user_name,
                Column.CPU_USAGE, 0.0,
                -1
            );
            pids.add(process_info.pid);
        }

        // remove processes which are no longer alive     
        retain_by_ids (pids);
    }
}
