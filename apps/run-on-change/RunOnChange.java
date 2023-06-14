import java.io.IOException;
import java.net.http.WebSocket;
import java.nio.file.*;
import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;

public class RunOnChange {
    public static void main(String[] args) throws IOException, InterruptedException {
        var directory = Paths.get(args[0]);
        var directoryFile = directory.toFile();
        var command = Arrays.copyOfRange(args, 1, args.length);

        var watcher = FileSystems.getDefault().newWatchService();
        Files.walk(directory)
            .filter(path -> path.toFile().isDirectory())
            .forEach(dir -> registerWatcher(dir, watcher));

        System.out.println(directory);
        System.out.println(String.join(" - ", command));

        WatchKey key;
        var cooldown = Duration.ofMillis(300);
        var lastCheck = Instant.now();
        while ((key = watcher.take()) != null) {
            if (Instant.now().isBefore(lastCheck.plus(cooldown))) {
                key.reset();
                continue;
            }

            var out = Runtime.getRuntime().exec(command, new String[]{}, directoryFile);
            var status = out.waitFor();

            if (status != 0) {
                var error = new String(out.getErrorStream().readAllBytes());
                System.out.println("Command failed with status of " + status + ", Err: " + error);
            }

            var result = new String(out.getInputStream().readAllBytes());

            var event = key.pollEvents().get(0);
            System.out.printf("FIle: %s changed, command output: %s %n", event.context(), result);

            key.reset();
            lastCheck = Instant.now();
        }
    }

    private static void registerWatcher(Path path, WatchService watcher) {
        try {
            path.register(watcher, StandardWatchEventKinds.ENTRY_MODIFY);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}