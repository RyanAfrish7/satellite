public class Satellite.ProcessInfo {
    public int pid { get; private set; }
    public string command_line { get; private set; }
    public int uid { get; private set; }
    public string user_name { get; private set; }

    public ProcessInfo (int pid, string command_line, int uid, string user_name) {
        this.pid = pid;
        this.command_line = command_line;
        this.uid = uid;
        this.user_name = user_name;
    }
}
