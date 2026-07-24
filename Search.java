import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Search {
    public static void main(String[] args) throws Exception {
        try (Stream<java.nio.file.Path> walk = Files.walk(Paths.get("src/main/webapp"))) {
            List<String> result = walk.filter(Files::isRegularFile)
                    .filter(p -> p.toString().endsWith(".jsp"))
                    .map(p -> p.toString())
                    .collect(Collectors.toList());

            for (String file : result) {
                String content = new String(Files.readAllBytes(Paths.get(file)), "UTF-8");
                if (content.contains("THỂ LOẠI")) {
                    System.out.println("Found in: " + file);
                }
            }
        }
    }
}
