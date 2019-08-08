public class Satellite.MemoryViewModel : Satellite.AbstractModel<int> {
    ProcessInfoProvider process_info_provider;
    MemoryUsageProvider memory_usage_provider;

    public enum Column {
        PID,
        COMMAND_LINE,
        UID,
        USER,
        MEMORY_USAGE,
        MEMORY_USAGE_IN_PERCENTAGE
    }

    public MemoryViewModel (ProcessInfoProvider process_info_provider, MemoryUsageProvider memory_usage_provider) {
        set_column_types (new Type[] {
            typeof (int),       // pid
            typeof (string),    // command_line
            typeof (int),       // uid
            typeof (string),    // username
            typeof (uint64),    // memory_usage
            typeof (double)     // memory_usage_in_percentage
        });

        this.process_info_provider = process_info_provider;
        this.memory_usage_provider = memory_usage_provider;
    }

    public void refresh () {
        // TODO: restructure fetch_all api to return Map of pids to ProcessInfo
        Gee.Set<ProcessInfo> process_info_list = process_info_provider.fetch_all ();
        Gee.Set<int> pids = new Gee.HashSet<int> ();

        foreach (ProcessInfo process_info in process_info_list) {
            pids.add(process_info.pid);
        }

        Gee.Map<int, ProcessMemoryUsage> pid_memory_usage_map = memory_usage_provider.fetch_by_pids (pids);
        SystemMemoryUsage system_memory_usage = memory_usage_provider.fetch_overall ();

        foreach (ProcessInfo process_info in process_info_list) {
            Gtk.TreeIter iter = get_or_append_row (process_info.pid);
            set (iter,
                Column.PID, process_info.pid,
                Column.COMMAND_LINE, process_info.command_line,
                Column.UID, process_info.uid,
                Column.USER, process_info.user_name,
                Column.MEMORY_USAGE, pid_memory_usage_map.get (process_info.pid).resident,
                Column.MEMORY_USAGE_IN_PERCENTAGE, pid_memory_usage_map.get (process_info.pid).resident * 100.0 / system_memory_usage.total,
                -1
            );
            pids.add(process_info.pid);
        }

        // remove processes which are no longer alive     
        retain_by_ids (pids);
    }
}
